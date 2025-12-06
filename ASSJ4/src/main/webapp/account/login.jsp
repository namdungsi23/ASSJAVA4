<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-card {
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
            overflow: hidden;
            background: white;
        }
        .card-header {
            background: linear-gradient(45deg, #e63946, #f77f00);
            padding: 2rem;
        }
        .btn-login {
            background: linear-gradient(45deg, #e63946, #f77f00);
            border: none;
            border-radius: 50px;
            padding: 12px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(230,57,70,0.4);
        }
        .form-control:focus {
            border-color: #e63946;
            box-shadow: 0 0 0 0.2rem rgba(230,57,70,0.25);
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="login-card">
                <div class="card-header text-white text-center">
                    <h2 class="mb-0 fw-bold">MyVideo</h2>
                    <p class="mb-0 fs-5">Chào mừng trở lại!</p>
                </div>
                
                <div class="card-body p-5">
                    <!-- Thông báo lỗi -->
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            ${sessionScope.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("message"); %>
                    </c:if>

                    <!-- Form đăng nhập -->
                    <form action="${pageContext.request.contextPath}/loginbao" method="post">
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Tên đăng nhập</label>
                            <input type="text" name="id" class="form-control form-control-lg" 
                                   value="${not empty cookie.user ? cookie.user.value : ''}"
                                   placeholder="Nhập tên đăng nhập" required autofocus>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Mật khẩu</label>
                            <input type="password" name="password" class="form-control form-control-lg" 
                                   placeholder="Nhập mật khẩu" required>
                        </div>
                        
                        <div class="mb-4 form-check">
                            <input type="checkbox" name="remember" class="form-check-input" id="remember"
                                   ${not empty cookie.user ? 'checked' : ''}>
                            <label class="form-check-label" for="remember">
                                Ghi nhớ tài khoản (30 ngày)
                            </label>
                        </div>
                        
                        <div class="d-grid">
                            <button type="submit" class="btn btn-login text-white fw-bold fs-5">
                                ĐĂNG NHẬP
                            </button>
                        </div>
                    </form>

                    <div class="text-center mt-4">
                        <p class="mb-2">
                            Chưa có tài khoản? 
                            <a href="<c:url value='/account/register.jsp'/>" class="text-danger fw-bold text-decoration-none">
                                Đăng ký ngay
                            </a>
                        </p>
                        <a href="${pageContext.request.contextPath}/videos" class="text-muted text-decoration-none">
                            Quay lại trang chủ
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>