package poly.com.entity;
import jakarta.persistence.*;
@Entity
@Table(name="Users")
public class User {
	@Id
    @Column(name = "Id", length = 20, nullable = false)
    private String id;

    @Column(name = "Password", length = 255, nullable = false)
    private String password;

    @Column(name = "Fullname", length = 255)
    private String fullname;

    @Column(name = "Email", length = 255)
    private String email;

    @Column(name = "Admin")
    private Boolean admin;

    // ===== Constructors =====
    public User() {}

    public User(String id, String password, String fullname, String email, Boolean admin) {
        this.id = id;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.admin = admin;
    }

    // ===== Getters & Setters =====
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getAdmin() {
        return admin;
    }

    public void setAdmin(Boolean admin) {
        this.admin = admin;
    }
}
