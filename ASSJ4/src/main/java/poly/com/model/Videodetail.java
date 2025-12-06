package poly.com.model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import poly.com.dao.FavoriteDao;
import poly.com.dao.HistoryDao;
import poly.com.dao.VideoDao;
import poly.com.entity.User;
import poly.com.entity.Video;

import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@WebServlet("/detail")
public class Videodetail extends HttpServlet {

    private VideoDao videoDao = new VideoDao();
    private HistoryDao historyDao = new HistoryDao();
    private FavoriteDao favoriteDao = new FavoriteDao();

    private String extractYouTubeId(String url) {
        if (url == null || url.isEmpty()) return null;
        String[] patterns = {"v=([^&]+)", "youtu\\.be/([^?&/]+)", "embed/([^?&/]+)"};
        for (String p : patterns) {
            Matcher m = Pattern.compile(p).matcher(url);
            if (m.find()) return m.group(1);
        }
        return null;
    }

    private void handleCookieHistory(HttpServletRequest request, HttpServletResponse response, String videoId) {
        Cookie[] cookies = request.getCookies();
        String watchedHistory = "";
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("watchedVideos".equals(c.getName())) {
                    watchedHistory = c.getValue();
                    break;
                }
            }
        }

        List<String> ids = watchedHistory.isEmpty() ? new ArrayList<>() : new ArrayList<>(Arrays.asList(watchedHistory.split(",")));
        ids.remove(videoId);
        ids.add(0, videoId);

        while (ids.size() > 5) ids.remove(ids.size() - 1);

        Cookie newCookie = new Cookie("watchedVideos", String.join(",", ids));
        newCookie.setMaxAge(60 * 60 * 24 * 7);
        newCookie.setPath("/");
        response.addCookie(newCookie);
    }

    private List<Video> getWatchedVideosFromCookie(HttpServletRequest request, String currentVideoId) {
        Cookie[] cookies = request.getCookies();
        String watchedHistory = "";
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("watchedVideos".equals(c.getName())) {
                    watchedHistory = c.getValue();
                    break;
                }
            }
        }

        if (watchedHistory.isEmpty()) return List.of();

        List<String> ids = Arrays.stream(watchedHistory.split(","))
                .filter(id -> !id.equals(currentVideoId))
                .collect(Collectors.toList());
        return videoDao.findByVideoIds(ids);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String videoId = request.getParameter("id");
        if (videoId == null || videoId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Thiếu ID video.");
            return;
        }

        User user = (User) request.getSession().getAttribute("user");

        try {
            Video mainVideo = videoDao.findById(videoId);
            if (mainVideo == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Video không tồn tại.");
                return;
            }

            // 1. Tăng lượt xem
            videoDao.incrementViewCount(videoId);

            // 2. Lấy video liên quan
            List<Video> related = videoDao.findRelatedVideos(videoId);

            // 3. Lưu lịch sử xem
            if (user != null) {
                try {
                    historyDao.create(user.getId(), videoId);
                } catch (Exception e) {
                    System.err.println("Lỗi ghi lịch sử xem: " + e.getMessage());
                }
            } else {
                handleCookieHistory(request, response, videoId);
            }

            // 4. Lấy video đã xem từ cookie (nếu chưa login)
            List<Video> watchedVideos = getWatchedVideosFromCookie(request, videoId);

            // 5. Chuẩn bị dữ liệu sang JSP
            request.setAttribute("video", mainVideo);
            request.setAttribute("relatedVideos", related);
            request.setAttribute("watchedVideos", watchedVideos);

            String youtubeId = extractYouTubeId(mainVideo.getLink());
            request.setAttribute("youtubeId", youtubeId);

            request.getRequestDispatcher("/views/Videodetail.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi truy vấn video.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
