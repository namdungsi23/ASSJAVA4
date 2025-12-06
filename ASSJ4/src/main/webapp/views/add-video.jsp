<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("path", request.getPathInfo() == null ? "/" : request.getPathInfo()); %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${action == 'edit' ? 'Sửa Video' : 'Thêm Video Mới'} - Admin MyVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #e2e8f0;
            min-height: 100vh;
            padding-top: 90px;
            font-family: 'Segoe UI', sans-serif;
        }
        .card-form {
            max-width: 800px;
            margin: 0 auto;
            background: #1e293b;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.6);
            overflow: hidden;
        }
        .card-header-custom {
            background: linear-gradient(135deg, #7c3aed, #a855f7);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .form-control, .form-check-input {
            background: #334155 !important;
            border: 1px solid #475569;
            color: #e2e8f0 !important;
        }
        .form-control:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 0.25rem rgba(124, 58, 237, 0.25);
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #7c3aed, #a855f7);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            font-weight: 600;
        }
        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #6d28d9, #9333ea);
            transform: translateY(-2px);
        }
        .preview-poster {
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            max-height: 300px;
            object-fit: cover;
        }
        .form-label {
            font-weight: 600;
            color: #94a3b8;
        }
        .alert-custom {
            border-radius: 16px;
            border: none;
        }
    </style>
</head>
<body>
    <jsp:include page="admin-navbar.jsp" />

    <div class="container py-5">
        <!-- Thông báo -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show alert-custom" role="alert">
                <i class="bi bi-check-circle-fill"></i> ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show alert-custom" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>

        <div class="card-form shadow-lg">
            <div class="card-header-custom">
                <h1 class="mb-0 display-5 fw-bold">
                    <i class="bi ${action == 'edit' ? 'bi-pencil-square' : 'bi-plus-circle'}"></i>
                    ${action == 'edit' ? 'SỬA VIDEO' : 'THÊM VIDEO MỚI'}
                </h1>
            </div>
            <div class="card-body p-5">
                <div class="row">
                    <!-- Form bên trái -->
                    <div class="col-lg-7">
                        <form action="${pageContext.request.contextPath}/admin/${action == 'edit' ? 'edit-video' : 'add-video'}" method="post">
                            <c:if test="${action == 'edit'}">
                                <input type="hidden" name="id" value="${video.id}">
                            </c:if>

                            <div class="mb-4">
                                <label class="form-label">ID Video ${action == 'edit' ? '<span class="text-warning">(không thể sửa)</span>' : ''}</label>
                                <input type="text" name="id" class="form-control form-control-lg" 
                                       value="${video.id}" ${action == 'edit' ? 'readonly' : 'required'} placeholder="VD: dQw4w9WgXcQ">
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Tiêu đề video</label>
                                <input type="text" name="title" class="form-control form-control-lg" 
                                       value="${fn:escapeXml(video.title)}" required placeholder="Nhập tiêu đề hấp dẫn...">
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Link YouTube</label>
                                <input type="url" name="link" id="youtubeLink" class="form-control form-control-lg" 
                                       value="${video.link}" required placeholder="https://www.youtube.com/watch?v=...">
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" rows="5" class="form-control" 
                                          placeholder="Viết mô tả chi tiết để thu hút người xem...">${fn:escapeXml(video.description)}</textarea>
                            </div>

                            <div class="mb-4 form-check form-switch">
                                <input type="checkbox" name="active" value="true" class="form-check-input" id="activeSwitch"
                                       ${video.active != false ? 'checked' : ''}>
                                <label class="form-check-label fw-bold" for="activeSwitch">
                                    Hiển thị video ngay
                                </label>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary-custom btn-lg shadow">
                                    <i class="bi ${action == 'edit' ? 'bi-check2-circle' : 'bi-cloud-upload'}"></i>
                                    ${action == 'edit' ? 'CẬP NHẬT VIDEO' : 'THÊM VIDEO NGAY'}
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Preview bên phải -->
                    <div class="col-lg-5 mt-4 mt-lg-0">
                        <div class="sticky-top" style="top: 100px;">
                            <h4 class="text-center mb-4 text-info">
                                <i class="bi bi-eye"></i> Xem trước
                            </h4>
                            <div class="text-center">
                                <c:choose>
                                    <c:when test="${not empty video.poster}">
                                        <img src="${video.poster}" alt="Poster" class="img-fluid preview-poster mb-3">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-secondary rounded-4 d-flex align-items-center justify-content-center mb-3" 
                                             style="height: 300px;">
                                            <h5 class="text-muted">Poster sẽ hiện khi nhập link YouTube</h5>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <h5 class="text-white mt-3">${not empty video.title ? video.title : 'Tiêu đề sẽ hiện ở đây...'}</h5>
                                <p class="text-muted small">
                                    ${not empty video.description ? fn:substring(video.description, 0, 100) : 'Mô tả sẽ hiện ở đây...'}
                                    ${fn:length(video.description) > 100 ? '...' : ''}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Auto update preview khi nhập link YouTube -->
    <script>
        document.getElementById('youtubeLink')?.addEventListener('input', function() {
            const url = this.value.trim();
            const videoId = url.match(/(?:v=|youtu\.be\/|embed\/|shorts\/)([^?&"'>]+)/);
            if (videoId) {
                const poster = `https://img.youtube.com/vi/${videoId[1]}/maxresdefault.jpg`;
                const img = document.querySelector('.preview-poster');
                if (img) img.src = poster;
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>