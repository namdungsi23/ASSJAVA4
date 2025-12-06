package poly.com.filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false); // false = không tạo session mới nếu chưa có

        if (session != null) {
            // Xóa hết dữ liệu trong session
            session.removeAttribute("user");
            session.removeAttribute("message");
            session.invalidate(); // Hủy luôn session
        }

        // Xóa cookie "user" (nếu có) để lần sau không tự fill
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("user".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    resp.addCookie(cookie);
                }
            }
        }

        // Thông báo thành công (hiển thị ở trang chủ hoặc login)
        req.getSession(true).setAttribute("message", "Đăng xuất thành công! Hẹn gặp lại bạn ");

        // Chuyển về trang chủ (không về login để trải nghiệm tốt hơn)
        resp.sendRedirect(req.getContextPath() + "/videos");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}