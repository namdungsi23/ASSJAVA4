package poly.com.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "Video")
public class Video {

    @Id
    @Column(name = "Id")
    private String id;

    @Column(name = "Title", nullable = false)
    private String title;

    @Column(name = "Views")
    private Integer views = 0;

    @Column(name = "Description")
    private String description;

    @Column(name = "Active")
    private Boolean active = true;

    @Column(name = "Link")
    private String link;

    @Transient
    private String poster;

    // --- Getter & Setter (đổi tên method cho chuẩn) ---
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Integer getViews() { return views; }
    public void setViews(Integer views) { this.views = views; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public String getPoster() { return poster; }
    public void setPoster(String poster) { this.poster = poster; }
}