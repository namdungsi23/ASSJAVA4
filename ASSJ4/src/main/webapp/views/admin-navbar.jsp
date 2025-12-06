<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- ĐẢM BẢO UTF-8 TỪ ĐẦU ĐẾN CUỐI -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow">
    <div class="container-fluid">
        <!-- Logo -->
        <a class="navbar-brand fw-bold text-danger fs-4" href="${pageContext.request.contextPath}/admin">
            Admin MyVideo
        </a>

        <!-- Nút collapse cho mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav" aria-controls="adminNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menu chính -->
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${fn:endsWith(pageContext.request.requestURI, 'AdminData.jsp') ? 'active fw-bold' : ''}"
                       href="${pageContext.request.contextPath}/admin">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(pageContext.request.requestURI, 'manage-videos') ? 'active fw-bold' : ''}"
                       href="${pageContext.request.contextPath}/admin/manage-videos">Quản lý Video</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(pageContext.request.requestURI, 'manage-users') ? 'active fw-bold' : ''}"
                       href="${pageContext.request.contextPath}/admin/manage-users">Quản lý Người dùng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(pageContext.request.requestURI, 'manage-favorites') ? 'active fw-bold' : ''}"
                       href="${pageContext.request.contextPath}/admin/manage-favorites">Yêu thích</a>
                </li>
            </ul>

            <!-- Tài khoản admin -->
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-info d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://ui-avatars.com/api/?name=${fn:escapeXml(sessionScope.user.fullname)}&background=6366f1&color=fff&rounded=true&size=36&font-size=0.5&bold=true"
                             class="rounded-circle me-2" width="36" height="36" alt="Avatar">
                        <span class="d-none d-sm-inline">${sessionScope.user.fullname}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/videos">
                            Xem trang người dùng</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger fw-bold" href="${pageContext.request.contextPath}/logout"
                                onclick="return confirm('Đăng xuất khỏi trang quản trị?')">
                            Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>