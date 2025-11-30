<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; padding-top: 70px; }
        .navbar-nav .nav-link { font-weight: 500; }
        .table th, .table td { vertical-align: middle; }
    </style>
</head>
<body>

<!-- Navbar ngang -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand text-danger fw-bold" href="admin-dashboard.jsp">Admin MyVideo</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="admin-dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="manage-videos.jsp">Quản lý Video</a></li>
                <li class="nav-item"><a class="nav-link" href="manage-users.jsp">Quản lý Người dùng</a></li>
                <li class="nav-item"><a class="nav-link" href="manage-favorites.jsp">Quản lý Yêu thích</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link text-danger" href="logoff" onclick="return confirm('Đăng xuất?')">Đăng xuất</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container mt-4">

    <!-- Thống kê cơ bản -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-white bg-primary mb-3">
                <div class="card-body">
                    <h5 class="card-title">Tổng Video</h5>
                    <p class="card-text fs-4">${totalVideos}</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-success mb-3">
                <div class="card-body">
                    <h5 class="card-title">Người dùng</h5>
                    <p class="card-text fs-4">${totalUsers}</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-warning mb-3">
                <div class="card-body">
                    <h5 class="card-title">Video Yêu thích</h5>
                    <p class="card-text fs-4">${totalFavorites}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bảng quản lý video -->
    <h3>Danh sách Video</h3>
    <a href="add-video.jsp" class="btn btn-success mb-3">Thêm Video</a>
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Poster</th>
                    <th>Tiêu đề</th>
                    <th>Lượt xem</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${videos}">
                    <tr>
                        <td>${v.id}</td>
                        <td>
                            <img src="${v.poster}" alt="${v.title}" width="100"
                                 onerror="this.src='https://via.placeholder.com/120x90?text=No+Image'">
                        </td>
                        <td>${v.title}</td>
                        <td>${v.views}</td>
                        <td>
                            <a href="edit-video.jsp?id=${v.id}" class="btn btn-sm btn-primary">Sửa</a>
                            <a href="delete-video?id=${v.id}" class="btn btn-sm btn-danger"
                               onclick="return confirm('Xác nhận xóa video này?')">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
