package poly.com.dao;

import jakarta.persistence.*;
import poly.com.entity.User;
import poly.com.utils.JpaUtils;

import java.util.List;

public class UserDao {

    private EntityManager getEntityManager() {
        return JpaUtils.getEntityManager();
    }

    // 1. Tìm theo ID (username)
    public User findById(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    // 2. Tìm theo email – ĐÃ SỬA LỖI BIÊN DỊCH!
    public User findByEmail(String email) {
        EntityManager em = getEntityManager();
        String jpql = "SELECT u FROM User u WHERE u.email = :email";
        TypedQuery<User> query = em.createQuery(jpql, User.class);
        query.setParameter("email", email);
        try {
            return query.getSingleResult(); // ← CHỈ DÒNG NÀY LÀ ĐÚNG
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    // 3. Đăng nhập (dùng nhiều nhất)
    public User login(String id, String password) {
        User user = findById(id);
        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null;
    }

    // 4. Lấy tất cả user (Admin)
    public List<User> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u ORDER BY u.fullname", User.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    // 5. Tạo mới
    public void create(User user) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(user);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi tạo user: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // 6. Cập nhật
    public void update(User user) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(user);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi cập nhật user: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // 7. Xóa
    public void delete(String id) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, id);
            if (user != null) {
                em.remove(user);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi xóa user: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // 8. Kiểm tra username tồn tại
    public boolean isUsernameExists(String username) {
        return findById(username) != null;
    }

    // 9. Kiểm tra email tồn tại
    public boolean isEmailExists(String email) {
        return findByEmail(email) != null;
    }

    // Bonus: Đếm tổng số user (dùng cho AdminServlet siêu nhanh)
    public long countAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(u) FROM User u", Long.class)
                     .getSingleResult();
        } finally {
            em.close();
        }
    }
}