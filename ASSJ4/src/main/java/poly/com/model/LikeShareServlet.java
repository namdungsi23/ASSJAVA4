package poly.com.model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import poly.com.dao.FavoriteDao;
import poly.com.dao.VideoDao;
import poly.com.entity.User;
import poly.com.entity.Video;
import poly.com.utils.JavaMailUtil;

import java.io.IOException;

@WebServlet({"/like", "/share", "/favorite"})
public class LikeShareServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final FavoriteDao favoriteDao = new FavoriteDao();
    private final VideoDao videoDao = new VideoDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp); // GET và POST đều xử lý giống nhau
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        String action = req.getParameter("action");
        String videoId = req.getParameter("videoId");
        String fromPage = req.getParameter("from"); // trang hiện tại (home/favorite)
        if (fromPage == null || fromPage.isEmpty()) fromPage = "home";

        // Kiểm tra video tồn tại
        if (videoId == null || videoDao.findById(videoId) == null) {
            session.setAttribute("error", "Video không tồn tại!");
            redirectBack(req, resp, fromPage);
            return;
        }

        // === XỬ LÝ LIKE / UNLIKE ===
        if ("like".equals(action) || "unlike".equals(action)) {
            if (user == null) {
                session.setAttribute("error", "Vui lòng đăng nhập để thích video!");
                redirectBack(req, resp, fromPage);
                return;
            }

            boolean isLiked = favoriteDao.isLiked(user.getId(), videoId);

            if ("like".equals(action) && !isLiked) {
                favoriteDao.create(user.getId(), videoId);
                session.setAttribute("success", "Đã thích video!");
            } else if ("unlike".equals(action) && isLiked) {
                favoriteDao.delete(user.getId(), videoId);
                session.setAttribute("success", "Đã bỏ thích video!");
            }
        }

        // === XỬ LÝ SHARE ===
        else if ("share".equals(action)) {
            if (user == null) {
                session.setAttribute("error", "Vui lòng đăng nhập để chia sẻ!");
                redirectBack(req, resp, fromPage);
                return;
            }

            String email = req.getParameter("email");
            if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                session.setAttribute("error", "Email không hợp lệ!");
                redirectBack(req, resp, fromPage);
                return;
            }

            Video video = videoDao.findById(videoId);
            String link = req.getRequestURL().toString().replace(req.getRequestURI(), "")
                    + req.getContextPath() + "/detail?id=" + videoId;

            String subject = user.getFullname() + " đã chia sẻ một video với bạn!";
            String body = String.format("""
                Chào bạn,

                %s đã chia sẻ một video rất hay với bạn:

                Tiêu đề: %s
                Link xem: %s

                Hãy xem ngay nhé!

                Trân trọng,
                MyVideo - Nền tảng xem video miễn phí
                """, user.getFullname(), video.getTitle(), link);

            try {
                JavaMailUtil.sendMail(email, subject, body);
                session.setAttribute("success", "Đã gửi video đến " + email + " thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Gửi email thất bại: " + e.getMessage());
            }
        }

        // === TRANG YÊU THÍCH (GET danh sách) ===
        else if (req.getServletPath().equals("/favorite") && req.getMethod().equalsIgnoreCase("GET")) {
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login.jsp");
                return;
            }
            req.setAttribute("videos", videoDao.findByFavoriteUser(user.getId()));
            req.getRequestDispatcher("/views/favorite.jsp").forward(req, resp);
            return;
        }

        redirectBack(req, resp, fromPage);
    }

    // Chuyển hướng về trang hiện tại
    private void redirectBack(HttpServletRequest req, HttpServletResponse resp, String fromPage) throws IOException {
        String redirectUrl = req.getContextPath() + "/videos";
        if ("favorite".equals(fromPage)) {
            redirectUrl = req.getContextPath() + "/favorite";
        }
        resp.sendRedirect(redirectUrl);
    }
}