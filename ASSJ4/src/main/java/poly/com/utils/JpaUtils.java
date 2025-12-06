package poly.com.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtils {
private static EntityManagerFactory factory;
static public EntityManager getEntityManager()
{
	if(factory==null || !factory.isOpen()) {
		factory =Persistence.createEntityManagerFactory("POLYOE");
		
	}
	return factory.createEntityManager();
}
static public void shutDown() {
	if(factory !=null && factory.isOpen()) {;
	factory.close();
	}
  factory= null;
}
}
