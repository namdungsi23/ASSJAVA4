package poly.com.entity;
import jakarta.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "Favorite")   
public class Favorite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)   // big int auto increment
    @Column(name = "Id")
    private Long id;

    @Column(name = "UserId", length = 20, nullable = false)
    private String userId;

    @Column(name = "VideoId", length = 255, nullable = false)
    private String videoId;

    @Column(name = "LikeDate")
    private Date likeDate;

    // ===== Constructors =====
    public Favorite() {}

    public Favorite(String userId, String videoId, Date likeDate) {
        this.userId = userId;
        this.videoId = videoId;
        this.likeDate = likeDate;
    }

    // ===== Getters & Setters =====
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public Date getLikeDate() {
        return likeDate;
    }

    public void setLikeDate(Date likeDate) {
        this.likeDate = likeDate;
    }

    }
