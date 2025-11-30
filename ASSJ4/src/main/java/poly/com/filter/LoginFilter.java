package poly.com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})   // chặn hết mọi request
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        String path = request.getServletPath();   // ví dụ: /account/register.jsp

        // CÁC TRANG ĐƯỢC PHÉP TRUY CẬP KHI CHƯA ĐĂNG NHẬP
        if (path.equals("/loginbao") ||
            path.equals("/registerbao") ||
            path.equals("/logout") ||
            path.startsWith("/account/login.jsp") ||
            path.startsWith("/account/register.jsp") ||
            path.matches(".*\\.(css|js|png|jpg|jpeg|gif|woff2|woff|ttf|svg)$")) {

            chain.doFilter(req, resp);   // CHO QUA, KHÔNG CHẶN
            return;
        }

        // CÁC TRANG CÒN LẠI: BẮT BUỘC PHẢI LOGIN
        HttpSession session = request.getSession();
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(req, resp);   // đã login → cho vào
        } else {
            response.sendRedirect(request.getContextPath() + "/loginbao");
        }
    }
}