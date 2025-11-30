<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
  background:#A8FFEB;
  font-family: Arial, Helvetica, sans-serif;
}

/* Center container */
.vh-center {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* Login card */
.login-card {
  width: 900px;
  max-width: 95%;
  height: 500px;
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 8px 28px rgba(0,0,0,0.18);
  display: flex;
}

/* Left image */
.login-left {
  flex: 1 1 50%;

  background-size: cover;
  background-position: center;
}

/* Form on the right */
.login-right {
  flex: 1 1 50%;
  padding: 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.login-right h2 {
  font-size: 28px;
  font-weight: 700;
  color: #1877F2; 
  text-align: center;
  margin-bottom: 22px;
}

/* Input fields */
.form-control {
  border-radius: 10px;
  padding: 14px;
  border: 1px solid #c8d6f0;
  font-size: 15px;
}

.form-control:focus {
  border-color: #1877F2;
  box-shadow: 0 0 6px rgba(24, 119, 242, 0.4);
}

/* Login button */
.btn-login {
  background: #1877F2; 
  color: white;
  padding: 12px;
  border-radius: 10px;
  font-size: 17px;
  border: none;
  font-weight: bold;
}

.btn-login:hover {
  background: #0f65d4;
}

/* Links */
.links {
  margin-top: 16px;
  text-align: center;
}

.links a {
  color: #1877F2;
  font-size: 15px;
  text-decoration: none;
}

.links a:hover {
  text-decoration: underline;
}

/* Mobile */
@media (max-width: 768px) {
  .login-card {
    flex-direction: column;
    height: auto;
  }
  .login-left {
    height: 180px;
  }
}


</style>
</head>
<body>
  <div class="vh-center">
    <div class="login-card">

      <!-- Left image -->
      <div class="login-left d-none d-md-block" aria-hidden="true"></div>

      <!-- Right form -->
      <div class="login-right">
        <h2>Đăng nhập</h2>

        <form action="${pageContext.request.contextPath}/loginbao" method="post" novalidate>
          <div class="mb-3">
            <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập / Email / SĐT" required>
          </div>

          <div class="mb-3">
            <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
          </div>

          <div class="d-grid">
            <button type="submit" class="btn btn-login">Đăng nhập</button>
          </div>
        </form>

        <div class="links">
          <a href="${pageContext.request.contextPath}/account/register.jsp">Đăng ký</a>
         
        </div>
      </div>
    </div>
  </div>

  <!-- Optional: Bootstrap JS (Popper + JS) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
