package poly.com.dao;

import jakarta.persistence.*;
import poly.com.entity.Favorite;
import poly.com.entity.Video;
import poly.com.utils.JpaUtils;

import java.util.List;

public class FavoriteDao {

    private EntityManager em() {
        return JpaUtils.getEntityManager();
    }

    // LIKE VIDEO (CHUẨN, CÓ KIỂM TRA TRÙNG)
    public void create(String userId, String videoId) {
        EntityManager em = em();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Video video = em.find(Video.class, videoId);
            if (video == null) {
                throw new RuntimeException("Video không tồn tại trong DB: " + videoId);
            }

            Long count = em.createQuery(
                    "SELECT COUNT(f) FROM Favorite f WHERE f.userId = :u AND f.videoId = :v", Long.class)
                    .setParameter("u", userId)
                    .setParameter("v", videoId)
                    .getSingleResult();

            if (count == 0) {
                Favorite f = new Favorite();
                f.setUserId(userId);
                f.setVideoId(videoId);
                f.setLikeDate(new java.util.Date());
                em.persist(f);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi Like video: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // BỎ LIKE
    public void delete(String userId, String videoId) {
        EntityManager em = em();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Favorite f = em.createQuery(
                    "SELECT f FROM Favorite f WHERE f.userId = :u AND f.videoId = :v", Favorite.class)
                    .setParameter("u", userId)
                    .setParameter("v", videoId)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
            if (f != null) em.remove(f);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi Unlike: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // LẤY DANH SÁCH VIDEO USER ĐÃ LIKE
    public List<Favorite> findByUserId(String userId) {
        EntityManager em = em();
        try {
            return em.createQuery(
                    "SELECT f FROM Favorite f WHERE f.userId = :u ORDER BY f.likeDate DESC", Favorite.class)
                    .setParameter("u", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // KIỂM TRA ĐÃ LIKE CHƯA
    public boolean isLiked(String userId, String videoId) {
        EntityManager em = em();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(f) FROM Favorite f WHERE f.userId = :u AND f.videoId = :v", Long.class)
                    .setParameter("u", userId)
                    .setParameter("v", videoId)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    // XÓA TẤT CẢ LIKE CỦA 1 VIDEO (khi xóa video)
    public void deleteByVideoId(String videoId) {
        EntityManager em = em();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery("DELETE FROM Favorite f WHERE f.videoId = :v")
                    .setParameter("v", videoId)
                    .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi xóa like theo videoId", e);
        } finally {
            em.close();
        }
    }

    // ĐẾM TỔNG LƯỢT LIKE (dùng cho Admin Dashboard)
    public long countAll() {
        EntityManager em = em();
        try {
            return em.createQuery("SELECT COUNT(f) FROM Favorite f", Long.class)
                     .getSingleResult();
        } finally {
            em.close();
        }
    }

    // HÀM MỚI: LẤY TẤT CẢ LƯỢT LIKE (CHO TRANG QUẢN LÝ YÊU THÍCH)
    public List<Favorite> findAll() {
        EntityManager em = em();
        try {
            return em.createQuery(
                    "SELECT f FROM Favorite f ORDER BY f.likeDate DESC", Favorite.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // HÀM BONUS: LẤY TOP USER LIKE NHIỀU NHẤT (dùng cho báo cáo)
    public List<Object[]> getTopLikers(int limit) {
        EntityManager em = em();
        try {
            return em.createQuery(
                    "SELECT f.userId, COUNT(f) as cnt FROM Favorite f GROUP BY f.userId ORDER BY cnt DESC", Object[].class)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}