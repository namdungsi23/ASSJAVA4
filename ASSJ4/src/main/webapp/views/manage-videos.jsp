<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý Video - Admin MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg, #0f172a, #1e293b); color: #e2e8f0; min-height: 100vh; padding-top: 90px; }
        .card { background: #1e293b; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        .table th { background: #0f172a; color: #60a5fa; }
        .lazy-img { background: #334155; min-height: 80px; border-radius: 10px; object-fit: cover; }
    </style>
</head>
<body>
    <jsp:include page="admin-navbar.jsp" />

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white fw-bold">QUẢN LÝ VIDEO</h2>
            <a href="${pageContext.request.contextPath}/admin/add-video" class="btn btn-success btn-lg">
                Thêm Video Mới
            </a>
        </div>

        <div class="card">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Poster</th>
                                <th>Tiêu đề</th>
                                <th>Lượt xem</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="v" items="${videos}">
                                <tr>
                                    <td><strong>${v.id}</strong></td>
                                    <td>
                                        <img data-src="${v.poster}" 
                                             src="https://via.placeholder.com/120x80/334155/94a3b8?text=Loading..."
                                             alt="${v.title}" width="120" height="80" 
                                             class="rounded lazy-img"
                                             onerror="this.src='https://via.placeholder.com/120x80?text=No+Image'">
                                    </td>
                                    <td class="text-info fw-semibold">${v.title}</td>
                                    <td><fmt:formatNumber value="${v.views}" pattern="#,##0"/></td>
                                    <td>
                                        <span class="badge ${v.active ? 'bg-success' : 'bg-secondary'}">
                                            ${v.active ? 'Hiển thị' : 'Ẩn'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/edit-video?id=${v.id}" 
                                           class="btn btn-warning btn-sm">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin/delete-video?id=${v.id}" 
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Xóa video này vĩnh viễn?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=1">Đầu</a>
                            </li>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage-1}">Trước</a>
                            </li>
                            <c:forEach begin="${currentPage-2 > 1 ? currentPage-2 : 1}" 
                                       end="${currentPage+2 < totalPages ? currentPage+2 : totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage+1}">Sau</a>
                            </li>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${totalPages}">Cuối</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const images = document.querySelectorAll(".lazy-img");
            const observer = new IntersectionObserver(e => e.forEach(en => {
                if (en.isIntersecting) {
                    const img = en.target;
                    img.src = img.dataset.src;
                    observer.unobserve(img);
                }
            }), { rootMargin: "100px" });
            images.forEach(img => observer.observe(img));
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>