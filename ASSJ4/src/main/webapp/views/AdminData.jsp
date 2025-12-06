<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard - MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg, #0f172a, #1e293b); color: #e2e8f0; min-height: 100vh; padding-top: 90px; font-family: 'Segoe UI', sans-serif; }
        .navbar { box-shadow: 0 4px 20px rgba(0,0,0,0.6); }
        .card-stat { border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); transition: 0.3s; }
        .card-stat:hover { transform: translateY(-10px); }
        .table { background: #1e293b; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.4); }
        .table th { background: #0f172a; color: #60a5fa; }
        .lazy-img { background: #334155; min-height: 80px; border-radius: 10px; object-fit: cover; }
        .pagination .page-link { color: #60a5fa; background: #1e293b; border: none; }
        .pagination .page-item.active .page-link { background: #3b82f6; border-color: #3b82f6; }
        .btn-add { background: linear-gradient(45deg, #10b981, #34d399); border: none; }
        .btn-add:hover { background: linear-gradient(45deg, #059669, #10b981); }
    </style>
</head>
<body>

<!-- Thông báo -->
<c:if test="${not empty sessionScope.message}">
    <div class="container mt-3">
        <div class="alert alert-info alert-dismissible fade show">
            ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("message"); %>
    </c:if>

<!-- Navbar Admin ĐẸP NHƯ YOUTUBE STUDIO -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold fs-4 text-danger" href="${pageContext.request.contextPath}/admin">
            Admin MyVideo
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-videos">Quản lý Video</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-users">Quản lý Người dùng</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-favorites">Yêu thích</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-info d-flex align-items-center" href="#" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullname}&background=6366f1&color=fff&rounded=true&size=40"
                             class="rounded-circle me-2" width="40">
                        <span class="d-none d-md-inline">${sessionScope.user.fullname}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/videos">Xem trang người dùng</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger fw-bold" href="${pageContext.request.contextPath}/logout"
                                onclick="return confirm('Đăng xuất khỏi trang quản trị?')">Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-5">
    <h2 class="text-center mb-5 text-white fw-bold">TRANG QUẢN TRỊ HỆ THỐNG MYVIDEO</h2>

    <!-- Thống kê 3 ô lớn -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card-stat text-white text-center p-5" style="background: linear-gradient(45deg, #7c3aed, #a855f7);">
                <i class="bi bi-film fs-1"></i>
                <h4 class="mt-3">Tổng Video</h4>
                <h1 class="display-4 fw-bold">${totalVideos}</h1>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-stat text-white text-center p-5" style="background: linear-gradient(45deg, #06b6d4, #0ea5e9);">
                <i class="bi bi-people-fill fs-1"></i>
                <h4 class="mt-3">Người dùng</h4>
                <h1 class="display-4 fw-bold">${totalUsers}</h1>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-stat text-white text-center p-5" style="background: linear-gradient(45deg, #ef4444, #f97316);">
                <i class="bi bi-heart-fill fs-1"></i>
                <h4 class="mt-3">Lượt yêu thích</h4>
                <h1 class="display-4 fw-bold">${totalFavorites}</h1>
            </div>
        </div>
    </div>

    <!-- Bảng Video + Nút Thêm + Phân trang -->
    <div class="card shadow-lg bg-dark">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">DANH SÁCH VIDEO (Trang ${currentPage} / ${totalPages})</h4>
            <a href="${pageContext.request.contextPath}/views/add-video.jsp" class="btn btn-success btn-add">
                Thêm Video Mới
            </a>
        </div>
        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-dark table-hover align-middle">
                    <thead>
                        <tr>
                            <th width="10%">ID</th>
                            <th width="20%">Poster</th>
                            <th>Tiêu đề</th>
                            <th width="15%">Lượt xem</th>
                            <th width="20%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${videos}">
                            <tr>
                                <td><strong>${v.id}</strong></td>
                                <td>
                                    <img data-src="${v.poster}"
                                         src="https://via.placeholder.com/120x80/1e293b/64748b?text=Loading..."
                                         alt="${v.title}" width="120" height="80"
                                         class="rounded shadow lazy-img"
                                         onerror="this.src='https://via.placeholder.com/120x80/334155/94a3b8?text=No+Image'">
                                </td>
                                <td class="text-info fw-semibold">${v.title}</td>
                                <td><fmt:formatNumber value="${v.views}" pattern="#,##0"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/views/edit-video.jsp?id=${v.id}" 
                                       class="btn btn-warning btn-sm">Sửa</a>
                                    <a href="${pageContext.request.contextPath}/admin/delete-video?id=${v.id}" 
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Xóa video này vĩnh viễn?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty videos}">
                            <tr><td colspan="5" class="text-center py-5 text-muted">Chưa có video nào</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang đẹp -->
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

<!-- Lazy Load ảnh mượt như YouTube -->
<script>
document.addEventListener("DOMContentLoaded", () => {
    const images = document.querySelectorAll(".lazy-img");
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.onload = () => img.style.opacity = 1;
                observer.unobserve(img);
            }
        });
    }, { rootMargin: "100px" });
    images.forEach(img => observer.observe(img));
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>