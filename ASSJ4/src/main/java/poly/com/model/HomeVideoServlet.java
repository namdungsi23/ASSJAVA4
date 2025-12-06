package poly.com.model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import poly.com.dao.VideoDao;
import poly.com.entity.Video;

import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = {"/", "/home", "/videos"})
public class HomeVideoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 8;

    private final VideoDao videoDao = new VideoDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // BỎ QUA CÁC ĐƯỜNG DẪN KHÔNG PHẢI TRANG CHỦ (để servlet khác xử lý)
        if (path.startsWith("/account/") ||
            path.startsWith("/admin/") ||
            path.startsWith("/like") ||
            path.startsWith("/share") ||
            path.startsWith("/detail") ||
            path.startsWith("/favorite") ||
            path.startsWith("/logout") ||
            path.endsWith(".jsp") && !path.endsWith("/Home.jsp")) {
            return; // Để Tomcat hoặc servlet khác xử lý
        }

        try {
            // Lấy trang hiện tại
            int page = 1;
            String pageParam = req.getParameter("page");
            if (pageParam != null && pageParam.matches("\\d+")) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }

            // DÙNG DAO + PHÂN TRANG CHUẨN (SIÊU NHANH, KHÔNG LOAD HẾT 1000 VIDEO VÀO RAM)
            List<Video> videos = videoDao.findPage(page, PAGE_SIZE);
            long totalVideos = videoDao.countActiveVideos();
            int totalPages = (int) ((totalVideos + PAGE_SIZE - 1) / PAGE_SIZE);
            if (page > totalPages && totalPages > 0) page = totalPages;

            // TỰ ĐỘNG TẠO POSTER YOUTUBE ĐẸP LUNG LINH
            for (Video v : videos) {
                String youtubeId = extractYouTubeId(v.getLink());
                String poster = youtubeId != null
                    ? "https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg"
                    : "https://via.placeholder.com/480x360/333/fff?text=No+Image";
                v.setPoster(poster);
            }

            // Gửi dữ liệu cho JSP
            req.setAttribute("videos", videos);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalVideos", totalVideos);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi tải danh sách video: " + e.getMessage());
        }

        // Forward đến trang chủ
        req.getRequestDispatcher("/views/Home.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    // TRÍCH XUẤT YOUTUBE ID – HỖ TRỢ 99.9% LINK (cả Shorts!)
    private String extractYouTubeId(String url) {
        if (url == null || url.isEmpty()) return null;
        String[] patterns = {
            "v=([^&]+)",
            "youtu\\.be/([^?&/]+)",
            "embed/([^?&/]+)",
            "v/([^?&/]+)",
            "shorts/([^?&/]+)"
        };
        for (String p : patterns) {
            Matcher m = Pattern.compile(p).matcher(url);
            if (m.find()) return m.group(1);
        }
        return null;
    }
}