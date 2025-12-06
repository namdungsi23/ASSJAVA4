package poly.com.filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import poly.com.entity.User;
import poly.com.utils.JpaUtils;

import jakarta.persistence.*;

import java.io.IOException;

@WebServlet("/registerbao")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Đảm bảo nhận tiếng Việt
        req.setCharacterEncoding("UTF-8");

        String fullname = req.getParameter("fullname");
        String username = req.getParameter("username");
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirmPassword");

        // === VALIDATE CƠ BẢN ===
        if (isEmpty(fullname) || isEmpty(username) || isEmpty(email) || isEmpty(password)) {
            setError(req, resp, "Vui lòng điền đầy đủ thông tin!");
            return;
        }

        if (!password.equals(confirm)) {
            setError(req, resp, "Mật khẩu nhập lại không khớp!");
            return;
        }

        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Kiểm tra trùng username hoặc email
            TypedQuery<Long> countQuery = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.id = :id OR u.email = :email", Long.class);
            countQuery.setParameter("id", username.trim());
            countQuery.setParameter("email", email.trim());

            if (countQuery.getSingleResult() > 0) {
                setError(req, resp, "Tên đăng nhập hoặc Email đã được sử dụng!");
                tx.rollback();
                return;
            }

            // Tạo user mới
            User user = new User();
            user.setId(username.trim());
            user.setPassword(password);           // Hiện tại lưu plain-text (đồ án OK)
            user.setFullname(fullname.trim());
            user.setEmail(email.trim());
            user.setAdmin(false);                 // Người dùng thường

            em.persist(user);
            tx.commit();

            // Đăng ký thành công → Đăng nhập luôn
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("success", "Đăng ký thành công! Chào mừng " + fullname + " ");

            resp.sendRedirect(req.getContextPath() + "/videos");

        } catch (Exception e) {
            e.printStackTrace();
            if (tx.isActive()) tx.rollback();
            setError(req, resp, "Đăng ký thất bại! Vui lòng thử lại.");
        } finally {
            em.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/account/register.jsp");
    }

    // === HÀM HỖ TRỢ ===
    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void setError(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher("/account/register.jsp").forward(req, resp);
    }
}