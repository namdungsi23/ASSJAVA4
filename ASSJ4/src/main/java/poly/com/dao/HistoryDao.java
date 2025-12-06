package poly.com.dao;

import java.util.List;
import jakarta.persistence.*;
import poly.com.entity.History; // Cần thiết cho việc quản lý lịch sử
import poly.com.entity.Video;
import poly.com.utils.JpaUtils;

public class HistoryDao  {

    // --- HÀM HỖ TRỢ JPA (Lấy từ VideoDao) ---
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

    /**
     * Ghi nhận hoặc cập nhật lịch sử xem.
     * Tìm bản ghi History dựa trên userId và videoId. Nếu tồn tại, cập nhật viewDate. Nếu không, tạo mới.
     * @param userId ID người dùng (Users.Id).
     * @param videoId ID của video.
     */
    public void create(String userId, String videoId) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            em.getTransaction().begin();

            // 1. Tìm bản ghi History hiện có
            // Sử dụng Native Query hoặc Query JPA phức tạp hơn do khóa kép
            String jpqlCheck = "SELECT h FROM History h WHERE h.userId = :uid AND h.videoId = :vid";
            TypedQuery<History> queryCheck = em.createQuery(jpqlCheck, History.class);
            queryCheck.setParameter("uid", userId);
            queryCheck.setParameter("vid", videoId);
            
            History existingHistory = null;
            try {
                 // Đảm bảo chỉ lấy 1 kết quả
                existingHistory = queryCheck.getSingleResult(); 
            } catch (NoResultException ignored) {
                // Không tìm thấy kết quả nào
            }

            if (existingHistory != null) {
                // 2. Nếu tồn tại: Cập nhật thời gian xem (viewDate)
                existingHistory.setViewDate(new java.util.Date()); // Sử dụng java.util.Date
                em.merge(existingHistory);
            } else {
                // 3. Nếu chưa tồn tại: Tạo bản ghi mới
                History newHistory = new History();
                newHistory.setUsersId(userId);
                newHistory.setVideoId(videoId);
                newHistory.setViewDate(new java.util.Date());
                em.persist(newHistory);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            rollback(em);
            throw new RuntimeException("Lỗi ghi nhận/cập nhật lịch sử xem JPA", e);
        } finally {
            close(em);
        }
    }

    /**
     * Lấy danh sách các Video mà người dùng đã xem, sắp xếp theo thời gian xem gần nhất.
     * @param userId ID người dùng.
     * @return Danh sách các đối tượng Video đã xem.
     */
    public List<Video> findViewedVideos(String userId) {
        EntityManager em = null;
        try {
            em = JpaUtils.getEntityManager();
            
            // JPQL JOIN: Lấy dữ liệu Video thông qua History, sắp xếp theo viewDate
            String jpql = "SELECT v FROM Video v JOIN History h ON v.id = h.videoId WHERE h.userId = :uid ORDER BY h.viewDate DESC";
            
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("uid", userId);
            
            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi lấy lịch sử xem JPA", e);
        } finally {
            close(em);
        }
    }
}