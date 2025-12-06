package poly.com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class LoginFilter implements Filter {

    // Các đường dẫn được truy cập mà KHÔNG cần đăng nhập
    private static final String[] PUBLIC_PATHS = {
        "/", "/home", "/videos",                    // Trang chủ (bắt cả 3)
        "/account/login.jsp", "/account/register.jsp", // Trang login & register
        "/loginbao", "/registerbao", "/logout",    // Các servlet đăng nhập/đăng ký/đăng xuất
        "/like", "/share", "/favorite"             // Các chức năng sẽ tự kiểm tra login bên trong
    };

    // Tài nguyên tĩnh (css, js, hình ảnh, font...)
    private static final String[] STATIC_EXT = {
        ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", 
        ".svg", ".woff", ".woff2", ".ttf", ".ico", ".webp"
    };

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        // Ví dụ: /ASSJ4/videos → path = "/videos"
        //         /ASSJ4/account/login.jsp → path = "/account/login.jsp"

        // 1. Cho qua các trang công khai (trang chủ, login, register, logout...)
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || path.startsWith(publicPath + "/") || 
                path.equals(publicPath + ".jsp")) {   // hỗ trợ thêm /account/login.jsp
                chain.doFilter(request, response);
                return;
            }
        }

        // 2. Cho qua tất cả tài nguyên tĩnh
        for (String ext : STATIC_EXT) {
            if (path.endsWith(ext) || path.contains(ext + "?")) {
                chain.doFilter(request, response);
                return;
            }
        }

        // 3. Cho qua các file JSP tĩnh (trừ Home.jsp vì nó được load bằng Servlet)
        if (path.endsWith(".jsp") && !path.endsWith("Home.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // 4. Các request còn lại → bắt buộc phải đăng nhập
        HttpSession session = request.getSession();
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response); // Đã login → cho đi tiếp
        } else {
            // Chưa login → lưu thông báo + chuyển về trang chủ
            session.setAttribute("message", "Vui lòng đăng nhập để thực hiện chức năng này!");
            response.sendRedirect(request.getContextPath() + "/videos"); // hoặc "/home" nếu bạn muốn
        }
    }
}