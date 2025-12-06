package poly.com.dao;

import java.util.List;
import jakarta.persistence.*;
import poly.com.entity.Video;
import poly.com.utils.JpaUtils;

public class VideoDao implements CrudDao<Video, String> {

    // ==================== CRUD CƠ BẢN ====================
    @Override
    public void insert(Video entity) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
        } catch (Exception e) {
            rollback(em);
            throw new RuntimeException("Lỗi insert Video", e);
        } finally {
            close(em);
        }
    }

    @Override
    public void update(Video entity) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            em.getTransaction().begin();
            em.merge(entity);
            em.getTransaction().commit();
        } catch (Exception e) {
            rollback(em);
            throw new RuntimeException("Lỗi update Video", e);
        } finally {
            close(em);
        }
    }

    @Override
    public void delete(String id) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            em.getTransaction().begin();
            Video entity = em.find(Video.class, id);
            if (entity != null) {
                em.remove(entity);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            rollback(em);
            throw new RuntimeException("Lỗi delete Video ID: " + id, e);
        } finally {
            close(em);
        }
    }

    @Override
    public Video findById(String id) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            return em.find(Video.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi findById Video ID: " + id, e);
        } finally {
            close(em);
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            String jpql = "SELECT v FROM Video v WHERE v.active = true ORDER BY v.views DESC";
            return em.createQuery(jpql, Video.class).getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi findAll Video", e);
        } finally {
            close(em);
        }
    }

    // ==================== HÀM HỖ TRỢ CƠ BẢN ====================
    private void rollback(EntityManager em) {
        if (em != null && em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }
    }

    private void close(EntityManager em) {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }

    // ==================== CÁC HÀM ĐÃ CÓ ====================
    public List<Video> findRelatedVideos(String excludeId) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            String jpql = "SELECT v FROM Video v WHERE v.active = true AND v.id != :vid ORDER BY v.views DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("vid", excludeId);
            query.setMaxResults(5);
            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi findRelatedVideos", e);
        } finally {
            close(em);
        }
    }

    public void incrementViewCount(String videoId) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            em.getTransaction().begin();
            String jpql = "UPDATE Video v SET v.views = v.views + 1 WHERE v.id = :id";
            Query query = em.createQuery(jpql);
            query.setParameter("id", videoId);
            int updated = query.executeUpdate();
            if (updated == 0) {
                System.err.println("Cảnh báo: Không tìm thấy Video ID để tăng lượt xem: " + videoId);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            rollback(em);
            throw new RuntimeException("Lỗi tăng lượt xem cho Video ID: " + videoId, e);
        } finally {
            close(em);
        }
    }

    public List<Video> findByVideoIds(List<String> videoIds) {
        if (videoIds == null || videoIds.isEmpty()) {
            return List.of();
        }
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            String jpql = "SELECT v FROM Video v WHERE v.active = true AND v.id IN :ids ORDER BY v.views DESC";
            return em.createQuery(jpql, Video.class)
                     .setParameter("ids", videoIds)
                     .getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi findByVideoIds", e);
        } finally {
            close(em);
        }
    }

    public List<Video> findPage(int page, int size) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            String jpql = "SELECT v FROM Video v WHERE v.active = true ORDER BY v.views DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi phân trang Video trang " + page, e);
        } finally {
            close(em);
        }
    }

    public long countActiveVideos() {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            String jpql = "SELECT COUNT(v) FROM Video v WHERE v.active = true";
            return em.createQuery(jpql, Long.class).getSingleResult();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi đếm số video active", e);
        } finally {
            close(em);
        }
    }

    // ==================== HÀM MỚI – SIÊU QUAN TRỌNG CHO TRANG YÊU THÍCH ====================
    /**
     * LẤY DANH SÁCH VIDEO MÀ NGƯỜI DÙNG ĐÃ THÍCH (DÙNG CHO TRANG /favorite)
     * @param userId ID của người dùng
     * @return List<Video> đã được set poster đầy đủ
     */
    public List<Video> findByFavoriteUser(String userId) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();

            // 1. Lấy danh sách videoId mà user đã like
            String sqlFav = "SELECT f.videoId FROM Favorite f WHERE f.userId = :uid ORDER BY f.likeDate DESC";
            List<String> videoIds = em.createQuery(sqlFav, String.class)
                                      .setParameter("uid", userId)
                                      .getResultList();

            if (videoIds.isEmpty()) {
                return List.of();
            }

            // 2. Lấy chi tiết video theo danh sách ID
            String sqlVideo = "SELECT v FROM Video v WHERE v.id IN :ids AND v.active = true ORDER BY v.views DESC";
            List<Video> videos = em.createQuery(sqlVideo, Video.class)
                                   .setParameter("ids", videoIds)
                                   .getResultList();

            // 3. Tự động tạo poster YouTube
            for (Video v : videos) {
                String youtubeId = extractYouTubeId(v.getLink());
                v.setPoster(youtubeId != null
                    ? "https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg"
                    : "https://via.placeholder.com/480x360/333/fff?text=No+Image");
            }

            return videos;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi lấy video yêu thích của user: " + userId, e);
        } finally {
            close(em);
        }
    }

    // HÀM TRÍCH XUẤT YOUTUBE ID (dùng chung)
    private String extractYouTubeId(String url) {
        if (url == null || url.trim().isEmpty()) return null;
        String[] patterns = {
            "v=([^&]+)",
            "youtu\\.be/([^?&/]+)",
            "embed/([^?&/]+)",
            "v/([^?&/]+)",
            "shorts/([^?&/]+)"
        };
        for (String p : patterns) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile(p).matcher(url);
            if (m.find()) return m.group(1);
        }
        return null;
    }
}