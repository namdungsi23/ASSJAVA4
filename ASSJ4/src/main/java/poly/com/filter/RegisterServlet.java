
package poly.com.filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.persistence.*;
import poly.com.entity.User;
import poly.com.utils.JpaUtils;

import java.io.IOException;

@WebServlet("/registerbao")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fullname = req.getParameter("fullname");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        // Validate mật khẩu nhập lại
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu không khớp!");
            req.getRequestDispatcher("/account/register.jsp").forward(req, resp);
            return;
        }

        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Kiểm tra trùng username (Id) hoặc email
            TypedQuery<User> q = em.createQuery(
                "SELECT u FROM User u WHERE u.id = :id OR u.email = :email", User.class);
            q.setParameter("id", username);
            q.setParameter("email", email);

            if (!q.getResultList().isEmpty()) {
            // nếu có ít nhất 1 kết quả → bị trùng
                req.setAttribute("error", "Tên đăng nhập hoặc Email đã tồn tại!");
                req.getRequestDispatcher("/account/register.jsp").forward(req, resp);
                tx.rollback();
                return;
            }

            // Tạo user mới
            User user = new User();
            user.setId(username);                    // Id = username
            user.setPassword(password);              // LƯU MẬT KHẨU DẠNG TEXT THƯỜNG
            user.setFullname(fullname);
            user.setEmail(email);
            user.setAdmin(false);                    // mặc định không phải admin

            em.persist(user);
            tx.commit();

            // Đăng nhập luôn sau khi đăng ký thành công
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/videos");

        } catch (Exception e) {
            e.printStackTrace();
            if (tx.isActive()) tx.rollback();
            req.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
            req.getRequestDispatcher("/account/register.jsp").forward(req, resp);
        } finally {
            em.close();
        }
    }
}