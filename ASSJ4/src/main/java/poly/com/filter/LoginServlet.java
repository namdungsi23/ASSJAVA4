package poly.com.filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import poly.com.dao.UserDao;
import poly.com.entity.User;

import java.io.IOException;

@WebServlet("/loginbao")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        // Kiểm tra đầu vào
        if (id == null || id.trim().isEmpty() || password == null || password.isEmpty()) {
            setErrorAndRedirect(req, resp, "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            return;
        }

        try {
            User user = userDao.findById(id.trim());

            if (user != null && password.equals(user.getPassword())) {
                // ĐĂNG NHẬP THÀNH CÔNG
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.removeAttribute("message"); // Xóa lỗi cũ

                // GHI NHỚ TÀI KHOẢN (COOKIE 30 NGÀY)
                if ("on".equals(remember)) {
                    Cookie cookie = new Cookie("user", id.trim());
                    cookie.setMaxAge(30 * 24 * 60 * 60);
                    cookie.setPath("/");
                    resp.addCookie(cookie);
                } else {
                    removeCookie(resp, "user");
                }

                // PHÂN QUYỀN ĐÚNG THEO TRƯỜNG admin TRONG DATABASE
                if (Boolean.TRUE.equals(user.getAdmin())) {
                    // Là ADMIN → vào trang quản trị
                    resp.sendRedirect(req.getContextPath() + "/admin");
                } else {
                    // Là USER thường → về trang chủ người dùng
                    resp.sendRedirect(req.getContextPath() + "/videos");
                }

            } else {
                setErrorAndRedirect(req, resp, "Sai tên đăng nhập hoặc mật khẩu!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndRedirect(req, resp, "Lỗi hệ thống, vui lòng thử lại sau!");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/account/login.jsp");
    }

    // HÀM HỖ TRỢ: hiện lỗi + quay lại trang login
    private void setErrorAndRedirect(HttpServletRequest req, HttpServletResponse resp, String message)
            throws IOException {
        req.getSession().setAttribute("message", message);
        resp.sendRedirect(req.getContextPath() + "/account/login.jsp");
    }

    // HÀM HỖ TRỢ: xóa cookie
    private void removeCookie(HttpServletResponse resp, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }
}