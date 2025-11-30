<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MyVideo - Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f9f9f9; }

        /* Navbar style YouTube */
        .navbar-yt { background-color: #ffffff; border-bottom: 1px solid #e6e6e6; }
        .navbar-yt .nav-link { color: #333 !important; font-weight: 500; }
        .navbar-yt .nav-link:hover { color: #1a73e8 !important; }

        /* Video cards */
        .video-card {
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .video-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }
        .video-thumbnail { height: 180px; object-fit: cover; width: 100%; }

        /* Title and meta */
        .video-title { font-size: 1rem; font-weight: 600; color: #111; }
        .video-meta { font-size: 0.85rem; color: #555; }
    </style>
</head>
<body>

<!-- Navbar giống YouTube -->
<nav class="navbar navbar-expand-lg navbar-yt shadow-sm sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-danger fs-4" href="/videos">MyVideo</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="/videos">Trang chủ</a></li>
                <li class="nav-item"><a class="nav-link" href="/favorites">Yêu thích</a></li>
            </ul>
            <ul class="navbar-nav"> <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle nav-leaf-link" href="#" data-bs-toggle="dropdown"> My Account </a> <ul class="dropdown-menu dropdown-menu-end shadow"> 
            <li><a class="dropdown-item" href="Re">Login</a></li>
             <li><a class="dropdown-item" href="/account/register.jsp">Registration</a></li> 
             <li><hr class="dropdown-divider"></li> <li> <a class="dropdown-item text-danger fw-bold" href="logoff" onclick="return confirm('Đăng xuất?')">Logoff</a> </li> </ul> </li> </ul>
        </div>
    </div>
</nav>

<!-- Video Grid -->
<div class="container mt-4">
    <div class="row g-4">
        <c:forEach var="v" items="${videos}">
            <div class="col-lg-3 col-md-4 col-sm-6">
                <div class="card video-card" onclick="window.open('${v.link}', '_blank')">
                    <img src="${v.poster}" alt="${v.title}" class="video-thumbnail"
                         onerror="this.src='https://via.placeholder.com/480x360?text=No+Image'">
                    <div class="card-body p-2">
                        <h6 class="video-title">${v.title}</h6>
                        <p class="video-meta mb-1">Lượt xem: ${v.views}</p>
                        <div class="d-flex gap-2">
                            <a href="like?id=${v.id}" class="btn btn-outline-danger btn-sm flex-fill">Like</a>
                            <a href="share?id=${v.id}" class="btn btn-outline-primary btn-sm flex-fill">Share</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Pagination -->
    <div class="text-center mt-4">
        <a class="btn btn-outline-primary ${page <= 1 ? 'disabled' : ''}" href="?page=1">First</a>
        <a class="btn btn-outline-primary ${page <= 1 ? 'disabled' : ''}" href="?page=${page-1}">Previous</a>
        <span class="mx-3 fw-bold">Trang ${page} / ${total}</span>
        <a class="btn btn-outline-primary ${page >= total ? 'disabled' : ''}" href="?page=${page+1}">Next</a>
        <a class="btn btn-outline-primary ${page >= total ? 'disabled' : ''}" href="?page=${total}">Last</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
