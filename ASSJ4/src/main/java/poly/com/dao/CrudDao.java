package poly.com.dao;

import java.util.List;

public interface CrudDao<T,K> {
 void insert(T entity);
 void update(T entity);
 void delete(K id);
 T findById(K id);
 List<T> findAll();
 
}
