<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý Yêu thích - Admin MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f172a, #1e293b); color: #e2e8f0; min-height: 100vh; padding-top: 90px; }
        .card { background: #1e293b; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        .table th { background: #0f172a; color: #60a5fa; }
    </style>
</head>
<body>
    <jsp:include page="admin-navbar.jsp" />

    <div class="container py-5">
        <h2 class="text-center mb-5 text-white fw-bold">QUẢN LÝ YÊU THÍCH (${totalFavorites} lượt)</h2>

        <div class="card">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-dark table-hover">
                        <thead>
                            <tr>
                                <th>Người dùng</th>
                                <th>Video ID</th>
                                <th>Ngày thích</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="f" items="${favorites}">
                                <tr>
                                    <td>${f.userId}</td>
                                    <td>${f.videoId}</td>
                                    <td>${f.likeDate}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/delete-favorite?userId=${f.userId}&videoId=${f.videoId}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Xóa lượt thích này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>