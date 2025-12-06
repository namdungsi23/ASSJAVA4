<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${video.title} - Video Player</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: #f9f9f9; font-family: Arial, sans-serif; }
        .container { display: flex; max-width: 1300px; margin: 20px auto; gap:24px; }
        .main-content { flex:3; }
        .sidebar { flex:1; }
        .video-player { width:100%; aspect-ratio:16/9; background:#000; margin-bottom:16px; }
        .video-title { font-size:24px; font-weight:bold; margin-bottom:8px; }
        .video-stats { padding-bottom:10px; border-bottom:1px solid #ccc; margin-bottom:16px; font-size:14px; color:#606060; }
        .sidebar-section { margin-bottom:30px; }
        .sidebar h3 { margin:0 0 15px 0; border-bottom:2px solid #ddd; padding-bottom:5px; }
        .related-video-item { display:flex; margin-bottom:12px; cursor:pointer; }
        .related-thumbnail { width:160px; height:90px; background-size:cover; background-position:center; margin-right:8px; flex-shrink:0; }
        .related-details { display:flex; flex-direction:column; }
        .related-title { font-size:14px; font-weight:500; line-height:1.2; overflow:hidden; max-height:2.4em; margin-bottom:4px; color:#1a1a1a; }
        .related-stats { font-size:12px; color:#606060; }
        .btn-like { background:#0d6efd; color:white; border:none; padding:6px 12px; margin-right:5px; border-radius:5px; }
        .btn-like:hover { background:#0b5ed7; }
    </style>
</head>
<body>

<div class="container">
    <div class="main-content">
        <div class="video-player">
            <c:if test="${not empty youtubeId}">
                <iframe width="100%" height="500" src="https://www.youtube.com/embed/${youtubeId}" frameborder="0" allowfullscreen></iframe>
            </c:if>
        </div>

        <h1 class="video-title">${video.title}</h1>
        <div class="video-stats">
            <i class="bi bi-eye"></i> <strong><fmt:formatNumber value="${video.views}" pattern="#,##0"/></strong> lượt xem
        </div>
        <div class="video-description">${video.description}</div>

        <div class="video-actions mt-2">
            <button class="btn-like" id="btn-like" data-id="${video.id}"><i class="bi bi-hand-thumbs-up"></i> Like</button>
            <a href="${pageContext.request.contextPath}/favorite" class="btn btn-outline-primary"><i class="bi bi-heart"></i> Yêu thích</a>
        </div>
    </div>

    <div class="sidebar">
        <div class="sidebar-section">
            <h3><i class="bi bi-clock-history"></i> Video Đã Xem</h3>
            <c:choose>
                <c:when test="${not empty watchedVideos}">
                    <c:forEach var="w" items="${watchedVideos}">
                        <div class="related-video-item">
                            <a href="${pageContext.request.contextPath}/detail?id=${w.id}">
                                <div class="related-thumbnail" style="background-image:url('${w.poster}');"></div>
                                <div class="related-details">
                                    <div class="related-title">${w.title}</div>
                                    <div class="related-stats"><fmt:formatNumber value="${w.views}" pattern="#,##0"/> lượt xem</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">Hãy xem thêm video để tạo lịch sử.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="sidebar-section">
            <h3><i class="bi bi-list-stars"></i> Video Liên Quan</h3>
            <c:forEach var="watched" items="${watchedVideos}">
    <div class="related-video-item">
        <a href="${pageContext.request.contextPath}/detail?id=${watched.id}">
            <img src="${watched.poster}" class="related-thumbnail"
                 onerror="this.src='https://via.placeholder.com/160x90?text=No+Image'"/>
            <div class="related-details">
                <div class="related-title">${watched.title}</div>
                <div class="related-stats">
                    <fmt:formatNumber value="${watched.views}" pattern="#,##0"/> lượt xem
                </div>
            </div>
        </a>
    </div>
</c:forEach>

<c:forEach var="rel" items="${relatedVideos}">
    <div class="related-video-item">
        <a href="${pageContext.request.contextPath}/detail?id=${rel.id}">
            <img src="${rel.poster}" class="related-thumbnail"
                 onerror="this.src='https://via.placeholder.com/160x90?text=No+Image'"/>
            <div class="related-details">
                <div class="related-title">${rel.title}</div>
                <div class="related-stats">
                    <fmt:formatNumber value="${rel.views}" pattern="#,##0"/> lượt xem
                </div>
            </div>
        </a>
    </div>
</c:forEach>

        </div>
    </div>
</div>

<script>
document.getElementById("btn-like").addEventListener("click", function(){
    const videoId = this.dataset.id;
    fetch("${pageContext.request.contextPath}/favorite", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "action=like&videoId=" + videoId
    })
    .then(resp => resp.text())
    .then(data => {
        if(data === "success") {
            alert("Đã thêm vào danh sách yêu thích!");
        } else if(data === "login_required") {
            alert("Vui lòng đăng nhập để Like video.");
        } else {
            alert("Có lỗi xảy ra, thử lại.");
        }
    });
});
</script>

</body>
</html>
