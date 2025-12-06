<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng ký</title>

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

/* Register card giống login-card */
.register-card {
  width: 900px;
  max-width: 95%;
  height: 560px;
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 8px 28px rgba(0,0,0,0.18);
  display: flex;
}

/* Left image */
.register-left {
  flex: 1 1 50%;
  background-size: cover;
  background-position: center;
}

/* Right form */
.register-right {
  flex: 1 1 50%;
  padding: 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.register-right h2 {
  font-size: 28px;
  font-weight: 700;
  color: #1877F2;
  text-align: center;
  margin-bottom: 22px;
}

/* Input box */
.input-box input {
  width: 100%;
  border-radius: 10px;
  padding: 14px;
  border: 1px solid #c8d6f0;
  font-size: 15px;
  margin-bottom: 15px;
}

.input-box input:focus {
  border-color: #1877F2;
  box-shadow: 0 0 6px rgba(24, 119, 242, 0.4);
}

/* Register button */
.register-btn {
  width: 100%;
  background: #1877F2;
  color: white;
  padding: 12px;
  border-radius: 10px;
  font-size: 17px;
  border: none;
  font-weight: bold;
  margin-top: 5px;
}

.register-btn:hover {
  background: #0f65d4;
}

/* Links */
.links {
  text-align: center;
  margin-top: 16px;
}

.links a {
  color: #1877F2;
  text-decoration: none;
  font-size: 15px;
}

.links a:hover {
  text-decoration: underline;
}

/* Mobile responsive */
@media (max-width: 768px) {
  .register-card {
    flex-direction: column;
    height: auto;
  }

  .register-left {
    height: 180px;
  }
}
</style>
</head>

<body>

<div class="vh-center">
  <div class="register-card">

      <!-- Left side -->
      <div class="register-left d-none d-md-block"></div>

      <!-- Right side -->
      <div class="register-right">
          <h2>Tạo tài khoản</h2>

          <form action="${pageContext.request.contextPath}/registerbao" method="post">

              <div class="input-box">
                  <input type="text" name="fullname" placeholder="Họ và tên" required>
              </div>

              <div class="input-box">
                  <input type="text" name="username" placeholder="Tên đăng nhập" required>
              </div>

              <div class="input-box">
                  <input type="email" name="email" placeholder="Email" required>
              </div>

              <div class="input-box">
                  <input type="password" name="password" placeholder="Mật khẩu" required>
              </div>

              <div class="input-box">
                  <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
              </div>

              <button type="submit" class="register-btn">Đăng ký</button>
          </form>

          <div class="links">
              <span>Đã có tài khoản?</span>
              <a href="login.jsp">Đăng nhập</a>
          </div>

          <p class="text-danger text-center mt-2">${error }</p>
      </div>

  </div>
</div>

</body>
</html>



