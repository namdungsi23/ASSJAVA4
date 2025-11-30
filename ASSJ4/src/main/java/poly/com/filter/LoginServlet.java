
package poly.com.filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.persistence.*;
import poly.com.entity.User;
import poly.com.utils.JpaUtils;

import java.io.IOException;

@WebServlet("/loginbao")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        EntityManager em = JpaUtils.getEntityManager();
        try {
            // Tìm user theo Id (Id chính là username trong DB của bạn)
            User user = em.find(User.class, username);

            // So sánh mật khẩu thường (không mã hóa)
            if (user != null && password.equals(user.getPassword())) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/videos"); // vào trang chủ
            } else {
                req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                req.getRequestDispatcher("/account/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã có lỗi xảy ra!");
            req.getRequestDispatcher("/account/login.jsp").forward(req, resp);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/account/login.jsp").forward(req, resp);
    }
}