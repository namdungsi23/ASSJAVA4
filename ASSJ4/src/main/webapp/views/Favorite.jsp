<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Video Yêu Thích</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .video-card { border-radius:10px; overflow:hidden; background:white; transition:0.25s; }
        .video-card:hover { transform: translateY(-5px); box-shadow:0px 6px 20px rgba(0,0,0,0.1);}
        .video-thumb { width:100%; height:200px; object-fit:cover; }
        .btn-unlike { background:#dc3545; color:white; }
        .btn-unlike:hover { background:#b52a37; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold fs-4 text-primary" href="${pageContext.request.contextPath}/videos">Play MyVideo</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/videos">Trang chủ</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/favorite">Yêu thích</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <c:choose>
        <c:when test="${empty videos}">
            <div class="text-center py-5">
                <i class="bi bi-heart fs-1 text-muted"></i>
                <h5 class="mt-3 text-muted">Bạn chưa thích video nào</h5>
                <p>Hãy bấm Like ở các video để thêm vào danh sách yêu thích!</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="v" items="${videos}">
                    <div class="col-md-3 col-sm-6">
                        <div class="video-card shadow-sm">
                            <a href="${pageContext.request.contextPath}/detail?id=${v.id}">
                                <img src="${v.poster}" class="video-thumb"
                                     onerror="this.src='https://via.placeholder.com/480x360/111/fff?text=No+Image'">
                            </a>
                            <div class="p-3">
                                <a href="${pageContext.request.contextPath}/detail?id=${v.id}" class="text-dark text-decoration-none">
                                    <h6 class="fw-bold">${v.title}</h6>
                                </a>
                                <p class="text-muted small mb-2"><i class="bi bi-eye"></i> 
                                    <fmt:formatNumber value="${v.views}" pattern="#,##0"/> lượt xem
                                </p>
                                <button class="btn btn-unlike btn-sm w-100 btn-unlike-action" data-id="${v.id}">
                                    <i class="bi bi-heartbreak-fill"></i> Bỏ thích
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
document.querySelectorAll(".btn-unlike-action").forEach(btn=>{
    btn.addEventListener("click", e=>{
        e.preventDefault(); e.stopPropagation();
        const id = btn.dataset.id;
        fetch("${pageContext.request.contextPath}/favorite",{
            method:"POST",
            headers:{"Content-Type":"application/x-www-form-urlencoded"},
            body:`action=unlike&videoId=${id}`
        }).then(res=>res.text()).then(txt=>{
            if(txt==="success") location.reload();
        });
    });
});
</script>
</body>
</html>
