// poly.com.dao.VideoDao.java
package poly.com.dao;

import java.util.List;
import jakarta.persistence.*;
import poly.com.entity.Video;
import poly.com.utils.JpaUtils;

public class VideoDao implements CrudDao<Video, String> {

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
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi findAll Video", e);
        } finally {
            close(em);
        }
    }

    // --- HÀM HỖ TRỢ ---
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
}