package poly.com.entity;

import java.util.Date;
import java.util.Objects;
import jakarta.persistence.*; // Import cần thiết cho JPA

@Entity
@Table(name = "History") // Khai báo ánh xạ tới bảng History trong CSDL
public class History {

    // --- KHÓA CHÍNH KÉP ---
    // Trường UsersId (Tương ứng với cột UsersId)
    @Id
    @Column(name = "UsersId") // Tên cột trong DB
    private String usersId;

    // Trường VideoId (Tương ứng với cột VideoId)
    @Id
    @Column(name = "VideoId") // Tên cột trong DB
    private String videoId;
    
    // --- THUỘC TÍNH KHÁC ---
    // Trường ViewDate (Tương ứng với cột viewDate)
    @Temporal(TemporalType.TIMESTAMP) // Chỉ định kiểu lưu trữ ngày/giờ
    @Column(name = "viewDate")
    private Date viewDate = new Date(); // Khởi tạo mặc định là thời gian hiện tại
    
    // -------------------------------------------------------------------
    // --- CONSTRUCTORS (Đã được sửa) ---
    // -------------------------------------------------------------------

    public History() {
        // Constructor mặc định cần thiết cho JPA
    }

    // Tùy chọn: Constructor tiện ích để tạo đối tượng mới
    public History(String usersId, String videoId) {
        this.usersId = usersId;
        this.videoId = videoId;
        this.viewDate = new Date();
    }
    
    // -------------------------------------------------------------------
    // --- GETTERS & SETTERS (Đã được sửa tên trường để khớp chuẩn Java) ---
    // -------------------------------------------------------------------

    public String getUsersId() {
        return usersId;
    }

    public void setUsersId(String usersId) {
        this.usersId = usersId;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public Date getViewDate() {
        return viewDate;
    }

    public void setViewDate(Date viewDate) {
        this.viewDate = viewDate;
    }

    // Bạn nên thêm phương thức hashCode() và equals() khi sử dụng khóa chính kép,
    // đặc biệt nếu bạn cần quản lý mối quan hệ hoặc sử dụng các Collection.
}