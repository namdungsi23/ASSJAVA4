<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MyVideo - Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
  <style>
    /* Định nghĩa màu sắc cơ bản cho Giao diện Sáng (Light Mode): 
       - Background: #F8F8F8 (Xám rất nhạt)
       - Text: #333333 (Xám tối)
       - Accent/Nhấn: #007BFF (Xanh Dương Sáng)
    */
    body { 
        background-color: #F8F8F8; /* Nền xám rất nhạt */
        color: #333333; /* Màu chữ xám tối */
    }

    /* Navbar */
    .navbar-yt { 
        background-color: #FFFFFF !important; /* Nền navbar trắng */
        border-bottom: 1px solid #E0E0E0; /* Đường viền xám nhạt */
    }
    .navbar-yt .nav-link, .navbar-yt .navbar-brand { 
        color: #333333 !important; 
        font-weight: 500; 
    }
    .navbar-yt .navbar-brand {
         color: #007BFF !important; /* Màu nhấn Xanh Dương cho logo */
    }
    .navbar-yt .nav-link:hover { 
        color: #007BFF !important; /* Màu nhấn Xanh Dương khi hover */
    }

    /* Dropdown Menu */
    .dropdown-menu { 
        background-color: #FFFFFF; /* Nền dropdown trắng */
        border: 1px solid #E0E0E0; 
    }
    .dropdown-item { 
        color: #333333; 
    }
    .dropdown-item:hover { 
        background-color: #F0F0F0; /* Nền xám rất nhạt khi hover */
        color: #007BFF; /* Màu nhấn Xanh Dương khi hover */
    }

    /* Video Card */
    .video-card { 
        background-color: #FFFFFF; /* Nền card trắng tinh */
        border: 1px solid #E0E0E0; /* Thêm viền nhẹ */
        border-radius: 10px; 
        overflow: hidden; 
        transition: all 0.3s; 
    }
    .video-card:hover { 
        transform: translateY(-5px); /* Lift nhẹ */
        /* Box shadow sử dụng màu nhấn Xanh Dương mờ */
        box-shadow: 0 8px 15px rgba(0, 123, 255, 0.2); 
    }
    .video-thumbnail { 
        height: 200px; 
        object-fit: cover; 
        width: 100%; 
    }
    .video-title { 
        font-size: 1rem; 
        font-weight: 600; 
        color: #000000; /* Màu đen cho tiêu đề */
        display: -webkit-box; 
        -webkit-line-clamp: 2; 
        -webkit-box-orient: vertical; 
        overflow: hidden; 
    }
    .video-meta { 
        font-size: 0.85rem; 
        color: #666666; /* Màu xám đậm hơn cho meta */
    }

    /* Nút Like (Sử dụng màu nhấn Xanh Dương) */
    .btn-like { 
        background: rgba(0, 123, 255, 0.1); /* Màu nhấn tint */
        border: 1px solid #007BFF; 
        color: #007BFF; 
    }
    .btn-like:hover { 
        background: #007BFF; 
        color: white; 
    }

    /* Nút Share (Giữ màu Xanh Dương với sắc thái khác hoặc đơn giản hóa) */
    .btn-share { 
        background: rgba(40, 167, 69, 0.1); /* Xanh lá nhạt (Success color) */
        border: 1px solid #28a745; /* Xanh lá */
        color: #28a745; 
    }
    .btn-share:hover { 
        background: #28a745; 
        color: white; 
    }

    /* Phân trang (Sử dụng màu nhấn Xanh Dương) */
    .page-item.active .page-link { 
        background-color: #007BFF; 
        border-color: #007BFF; 
        color: white;
    }
    
    .pagination .page-link {
        color: #333333;
        background-color: #FFFFFF;
        border: 1px solid #E0E0E0;
    }
    .pagination .page-link:hover {
        color: #007BFF;
        background-color: #F0F0F0;
        border-color: #E0E0E0;
    }
    
    /* Cập nhật màu cho link đăng nhập */
    .text-danger {
        color: #DC3545 !important; /* Đỏ tiêu chuẩn cho các hành động quan trọng/cảnh báo */
    }
</style>
</head>
<body>

<!-- Thông báo -->
<c:if test="${not empty sessionScope.message || not empty sessionScope.success}">
    <div class="container mt-3">
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-warning alert-dismissible fade show">
                <strong>Thông báo:</strong> ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show">
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>
    </div>
</c:if>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-yt shadow-sm sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold fs-4 text-danger" href="${pageContext.request.contextPath}/videos">
            Play MyVideo
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/videos">Trang chủ</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/favorite">Yêu thích</a></li>
                </c:if>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" data-bs-toggle="dropdown">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullname}&background=ff0000&color=fff&rounded=true&size=32"
                                     alt="Avatar" class="rounded-circle me-2" width="32">
                                ${sessionScope.user.fullname}
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-circle fs-3"></i>
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/favorite">
                                    Heart Video yêu thích</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger fw-bold" href="${pageContext.request.contextPath}/logout"
                                       onclick="return confirm('Bạn có chắc muốn đăng xuất không?')">
                                    Exit Đăng xuất</a></li>
                            </c:when>
                            <c:otherwise>
                                <!-- ĐÃ SỬA: DÙNG c:url ĐỂ TRÁNH 404 -->
                                <li><a class="dropdown-item" href="<c:url value='/account/login.jsp'/>">
                                    Login Đăng nhập</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/account/register.jsp'/>">
                                    Register Đăng ký</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Danh sách video -->
<div class="container mt-4 pb-5">
    <c:choose>
        <c:when test="${empty videos}">
            <div class="text-center py-5">
                <i class="bi bi-film fs-1 text-muted"></i>
                <h4 class="mt-3 text-muted">Chưa có video nào</h4>
                <p>Hãy quay lại sau nhé!</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row g-4">

                <c:forEach var="v" items="${videos}">
                    <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12">

                        <div class="card video-card h-100">

                            <!-- ẢNH BẤM → CHI TIẾT -->
                            <a href="${pageContext.request.contextPath}/detail?id=${v.id}">
                                <img src="${v.poster}" class="card-img-top video-thumbnail"
                                     alt="${v.title}"
                                     onerror="this.src='https://via.placeholder.com/480x360/111/fff?text=No+Image'">
                            </a>

                            <div class="card-body d-flex flex-column">

                                <!-- TIÊU ĐỀ BẤM → CHI TIẾT -->
                                <a href="${pageContext.request.contextPath}/detail?id=${v.id}"
                                   class="text-decoration-none">
                                    <h6 class="video-title">${v.title}</h6>
                                </a>

                                <p class="video-meta mt-auto">
                                    Eye <fmt:formatNumber value="${v.views}" pattern="#,##0"/> lượt xem
                                </p>

                                <!-- LIKE & SHARE -->
                                <div class="d-flex gap-2 mt-2">
                                    <c:choose>

                                        <c:when test="${not empty sessionScope.user}">
                                            <button class="btn btn-like btn-sm flex-fill btn-like-home"
                                                    data-id="${v.id}">
                                                Like
                                            </button>

                                            <!-- Share vẫn dẫn sang trang share -->
                                            <a href="${pageContext.request.contextPath}/share?id=${v.id}"
                                               class="btn btn-share btn-sm flex-fill">
                                                Share
                                            </a>
                                        </c:when>

                                        <c:otherwise>
                                            <button class="btn btn-outline-secondary btn-sm flex-fill" disabled>
                                                Like
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm flex-fill" disabled>
                                                Share
                                            </button>
                                            <small class="text-center d-block mt-2 text-muted">
                                                <a href="<c:url value='/account/login.jsp'/>"
                                                   class="text-danger text-decoration-underline">
                                                    Đăng nhập để tương tác
                                                </a>
                                            </small>
                                        </c:otherwise>

                                    </c:choose>
                                </div>

                            </div>
                        </div>

                    </div>
                </c:forEach>

            </div>

            <!-- Phân trang giữ nguyên -->
            <c:if test="${total > 1}">
                <nav class="mt-5 d-flex justify-content-center">
                    <ul class="pagination">
                        <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=1">First</a>
                        </li>
                        <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${page-1}">Previous</a>
                        </li>

                        <c:forEach begin="${page-2 > 1 ? page-2 : 1}" end="${page+2 < total ? page+2 : total}" var="i">
                            <li class="page-item ${i == page ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${page >= total ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${page+1}">Next</a>
                        </li>
                        <li class="page-item ${page >= total ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${total}">Last</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

        </c:otherwise>

    </c:choose>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".btn-like-home").forEach(btn => {

        btn.addEventListener("click", () => {

            const id = btn.dataset.id;
            const isUnlike = btn.innerText.includes("Unlike");

            fetch("favorite", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: `videoId=${id}&action=${isUnlike ? "unlike" : "like"}`
            })
            .then(res => res.text())
            .then(data => {
                if (data === "NOT_LOGIN") {
                    alert("Bạn phải đăng nhập!");
                    location.href = "account/login.jsp";
                    return;
                }

                btn.innerText = isUnlike ? "Like" : "Unlike";
            });
        });
    });
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>