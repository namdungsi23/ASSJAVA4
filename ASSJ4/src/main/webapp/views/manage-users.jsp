<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý Người dùng - Admin MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg, #0f172a, #1e293b); color: #e2e8f0; min-height: 100vh; padding-top: 90px; }
        .card { background: #1e293b; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        .table th { background: #0f172a; color: #60a5fa; }
    </style>
</head>
<body>
    <jsp:include page="admin-navbar.jsp" />

    <div class="container py-5">
        <h2 class="text-center mb-5 text-white fw-bold">QUẢN LÝ NGƯỜI DÙNG (${totalUsers} người)</h2>

        <div class="card">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Avatar</th>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Quyền</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>
                                        <img src="https://ui-avatars.com/api/?name=${u.fullname}&background=6366f1&color=fff&rounded=true&size=64"
                                             class="rounded-circle" width="50" height="50" alt="${u.fullname}">
                                    </td>
                                    <td><strong>${u.id}</strong></td>
                                    <td>${u.fullname}</td>
                                    <td>${u.email}</td>
                                    <td>
                                        <span class="badge ${u.admin ? 'bg-danger' : 'bg-success'} fs-6">
                                            ${u.admin ? 'Admin' : 'User'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/toggle-admin?id=${u.id}"
                                           class="btn btn-warning btn-sm">
                                            ${u.admin ? 'Hạ Admin' : 'Nâng Admin'}
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/delete-user?id=${u.id}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Xóa người dùng này vĩnh viễn?')">Xóa</a>
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