package poly.com.model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import poly.com.dao.*;
import poly.com.entity.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*") // BẮT TẤT CẢ CÁC ĐƯỜNG DẪN /admin/...
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 10;

    private final VideoDao videoDao = new VideoDao();
    private final UserDao userDao = new UserDao();
    private final FavoriteDao favoriteDao = new FavoriteDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.isEmpty()) {
            path = "/";
        }

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Bảo mật admin
        if (currentUser == null || !Boolean.TRUE.equals(currentUser.getAdmin())) {
            session.setAttribute("message", "Bạn không có quyền truy cập trang quản trị!");
            resp.sendRedirect(req.getContextPath() + "/account/login.jsp");
            return;
        }

        try {
            // DÙNG SWITCH CỔ ĐIỂN → CHẠY ĐƯỢC TRÊN JAVA 8, 11, 17, 21
            switch (path) {
                case "/":
                    showDashboard(req);
                    break;
                case "/manage-videos":
                    manageVideos(req);
                    break;
                case "/manage-users":
                    manageUsers(req);
                    break;
                case "/manage-favorites":
                    manageFavorites(req);
                    break;
                case "/add-video":
                    showAddVideoForm(req);
                    break;
                case "/edit-video":
                    showEditVideoForm(req);
                    break;
                case "/delete-video":
                    deleteVideo(req, resp);
                    return;
                case "/toggle-admin":
                    toggleAdmin(req, resp);
                    return;
                case "/delete-user":
                    deleteUser(req, resp);
                    return;
                case "/delete-favorite":
                    deleteFavorite(req, resp);
                    return;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin");
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Forward đến trang JSP đúng
        String jspPage;
        switch (path) {
            case "/":
                jspPage = "/views/AdminData.jsp";
                break;
            case "/manage-videos":
                jspPage = "/views/manage-videos.jsp";
                break;
            case "/manage-users":
                jspPage = "/views/manage-users.jsp";
                break;
            case "/manage-favorites":
                jspPage = "/views/manage-favorites.jsp";
                break;
            case "/add-video":
            case "/edit-video":
                jspPage = "/views/add-video.jsp";
                break;
            default:
                jspPage = "/views/AdminData.jsp";
                break;
        }
        req.getRequestDispatcher(jspPage).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        try {
            switch (path) {
                case "/add-video":
                    addVideo(req, resp);
                    break;
                case "/edit-video":
                    updateVideo(req, resp);
                    break;
                default:
                    doGet(req, resp);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Thao tác thất bại: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin");
        }
    }

    // ==================== TẤT CẢ CÁC HÀM ĐÃ CÓ ĐỦ ====================

    private void showDashboard(HttpServletRequest req) throws Exception {
        int page = getPage(req);
        List<Video> videos = videoDao.findPage(page, PAGE_SIZE);
        long totalVideos = videoDao.countActiveVideos();
        long totalUsers = userDao.countAll();
        long totalFavorites = favoriteDao.countAll();
        int totalPages = (int) ((totalVideos + PAGE_SIZE - 1) / PAGE_SIZE);

        setPosterForVideos(videos);

        req.setAttribute("totalVideos", totalVideos);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalFavorites", totalFavorites);
        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
    }

    private void manageVideos(HttpServletRequest req) throws Exception {
        int page = getPage(req);
        List<Video> videos = videoDao.findPage(page, PAGE_SIZE);
        long total = videoDao.countActiveVideos();
        int totalPages = (int) ((total + PAGE_SIZE - 1) / PAGE_SIZE);

        setPosterForVideos(videos);

        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
    }

    private void manageUsers(HttpServletRequest req) throws Exception {
        List<User> users = userDao.findAll();
        req.setAttribute("users", users);
        req.setAttribute("totalUsers", users.size());
    }

    private void manageFavorites(HttpServletRequest req) throws Exception {
        List<Favorite> favorites = favoriteDao.findAll();
        req.setAttribute("favorites", favorites);
        req.setAttribute("totalFavorites", favorites.size());
    }

    private void showAddVideoForm(HttpServletRequest req) {
        req.setAttribute("action", "add");
    }

    private void showEditVideoForm(HttpServletRequest req) {
        String id = req.getParameter("id");
        Video video = videoDao.findById(id);
        if (video != null) {
            req.setAttribute("video", video);
            req.setAttribute("action", "edit");
        }
    }

    private void addVideo(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Video v = new Video();
        fillVideoFromRequest(v, req);
        videoDao.insert(v);
        req.getSession().setAttribute("success", "Thêm video thành công!");
        resp.sendRedirect(req.getContextPath() + "/admin/manage-videos");
    }

    private void updateVideo(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String id = req.getParameter("id");
        Video v = videoDao.findById(id);
        if (v != null) {
            fillVideoFromRequest(v, req);
            videoDao.update(v);
            req.getSession().setAttribute("success", "Cập nhật video thành công!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/manage-videos");
    }

    private void deleteVideo(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String id = req.getParameter("id");
        favoriteDao.deleteByVideoId(id);
        videoDao.delete(id);
        req.getSession().setAttribute("success", "Xóa video thành công!");
        resp.sendRedirect(req.getContextPath() + "/admin/manage-videos");
    }

    private void toggleAdmin(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String id = req.getParameter("id");
        User current = (User) req.getSession().getAttribute("user");
        if (!id.equals(current.getId())) {
            User u = userDao.findById(id);
            if (u != null) {
                u.setAdmin(!u.getAdmin());
                userDao.update(u);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/manage-users");
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String id = req.getParameter("id");
        User current = (User) req.getSession().getAttribute("user");
        if (!id.equals(current.getId())) {
            userDao.delete(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/manage-users");
    }

    private void deleteFavorite(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String userId = req.getParameter("userId");
        String videoId = req.getParameter("videoId");
        favoriteDao.delete(userId, videoId);
        resp.sendRedirect(req.getContextPath() + "/admin/manage-favorites");
    }

    // ==================== HÀM HỖ TRỢ ====================
    private int getPage(HttpServletRequest req) {
        int page = 1;
        String p = req.getParameter("page");
        if (p != null && p.matches("\\d+")) {
            page = Integer.parseInt(p);
            if (page < 1) page = 1;
        }
        return page;
    }

    private void setPosterForVideos(List<Video> videos) {
        for (Video v : videos) {
            String youtubeId = extractYouTubeId(v.getLink());
            v.setPoster(youtubeId != null
                ? "https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg"
                : "https://via.placeholder.com/120x80/333/fff?text=No+Image");
        }
    }

    private void fillVideoFromRequest(Video v, HttpServletRequest req) {
        v.setId(req.getParameter("id"));
        v.setTitle(req.getParameter("title"));
        v.setLink(req.getParameter("link"));
        v.setDescription(req.getParameter("description"));
        v.setActive("true".equals(req.getParameter("active")));
    }

    private String extractYouTubeId(String url) {
        if (url == null || url.isEmpty()) return null;
        String[] patterns = {"v=([^&]+)", "youtu\\.be/([^?&/]+)", "embed/([^?&/]+)", "v/([^?&/]+)", "shorts/([^?&/]+)"};
        for (String p : patterns) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile(p).matcher(url);
            if (m.find()) return m.group(1);
        }
        return null;
    }
}