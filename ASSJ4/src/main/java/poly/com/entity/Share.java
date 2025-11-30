package poly.com.entity;

import jakarta.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "Share")  
public class Share {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Long id;

    @Column(name = "UserId", length = 20, nullable = false)
    private String userId;

    @Column(name = "VideoId", length = 255, nullable = false)
    private String videoId;

    @Column(name = "Emails", columnDefinition = "NVARCHAR(MAX)")
    private String emails;

    @Column(name = "ShareDate")
    private Date shareDate;

    // ===== Constructors =====

    public Share() {}

    public Share(String userId, String videoId, String emails, Date shareDate) {
        this.userId = userId;
        this.videoId = videoId;
        this.emails = emails;
        this.shareDate = shareDate;
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

    public String getEmails() {
        return emails;
    }

    public void setEmails(String emails) {
        this.emails = emails;
    }

    public Date getShareDate() {
        return shareDate;
    }

    public void setShareDate(Date shareDate) {
        this.shareDate = shareDate;
    }
}

