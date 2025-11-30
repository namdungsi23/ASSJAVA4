// poly.com.model.HomeVideoServlet.java
package poly.com.model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.com.controller.VideoController;
import poly.com.entity.Video;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/videos")
public class HomeVideoServlet extends HttpServlet {
    private final VideoController controller = new VideoController();
    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Video> allVideos = controller.getAllVideos();

        // TỰ ĐỘNG TẠO POSTER
        for (Video v : allVideos) {
            String youtubeId = extractYouTubeId(v.getLink());
            v.setPoster(youtubeId != null
                ? "https://img.youtube.com/vi/" + youtubeId + "/maxresdefault.jpg"
                : "https://via.placeholder.com/480x360/e9ecef/6c757d?text=No+Image");
        }

        // PHÂN TRANG
        int page = 1;
        try {
            page = Integer.parseInt(req.getParameter("page"));
            if (page < 1) page = 1;
        } catch (Exception ignored) {}

        int from = (page - 1) * PAGE_SIZE;
        int to = Math.min(from + PAGE_SIZE, allVideos.size());
        List<Video> pageVideos = from < allVideos.size()
            ? allVideos.subList(from, to)
            : List.of();

        int totalPages = (int) Math.ceil(allVideos.size() / (double) PAGE_SIZE);

        req.setAttribute("videos", pageVideos);
        req.setAttribute("page", page);
        req.setAttribute("total", totalPages);

        req.getRequestDispatcher("/views/Home.jsp").forward(req, resp);
    }

    private String extractYouTubeId(String url) {
        if (url == null || url.isEmpty()) return null;
        String[] patterns = {
            "v=([^&]+)",
            "youtu\\.be/([^?&]+)",
            "embed/([^?&]+)"
        };
        for (String p : patterns) {
            Matcher m = Pattern.compile(p).matcher(url);
            if (m.find()) return m.group(1);
        }
        return null;
    }
}