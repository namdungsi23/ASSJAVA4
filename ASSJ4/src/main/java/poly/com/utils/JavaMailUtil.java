package poly.com.utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class JavaMailUtil {

    // THAY ĐỔI 2 DÒNG NÀY BẰNG EMAIL + APP PASSWORD CỦA BẠN
    private static final String FROM_EMAIL = "your-email@gmail.com";     // Ví dụ: myvideo.poly2025@gmail.com
    private static final String PASSWORD   = "your-app-password-here";  // Mật khẩu ứng dụng (App Password)

    /**
     * GỬI EMAIL CHIA SẺ VIDEO – DÙNG TRONG LikeShareServlet
     */
    public static void sendMail(String toEmail, String subject, String body) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Gửi email thành công đến: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Gửi email thất bại: " + e.getMessage(), e);
        }
    }

    // HÀM TIỆN ÍCH: TẠO NỘI DUNG EMAIL ĐẸP (HTML)
    public static String createShareEmailBody(String senderName, String videoTitle, String videoLink) {
        return """
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; background:#f9f9f9;">
                <h2 style="color:#d32f2f;">MyVideo - Video được chia sẻ</h2>
                <p>Xin chào bạn,</p>
                <p><strong>%s</strong> đã chia sẻ một video rất hay với bạn:</p>
                <div style="background:#fff; padding:15px; border-left:5px solid #d32f2f; margin:20px 0;">
                    <h3 style="margin:0; color:#333;">%s</h3>
                    <p style="margin:10px 0 0;"><a href="%s" style="color:#d32f2f; font-weight:bold;">Xem ngay tại đây</a></p>
                </div>
                <p>Cảm ơn bạn đã sử dụng <strong>MyVideo</strong>!</p>
                <hr>
                <small style="color:#777;">Đây là email tự động, vui lòng không trả lời.</small>
            </div>
            """.formatted(senderName, videoTitle, videoLink);
    }
}