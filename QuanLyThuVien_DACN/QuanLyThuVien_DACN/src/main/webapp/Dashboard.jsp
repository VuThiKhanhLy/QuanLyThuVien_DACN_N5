<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.quanlythuvien.model.TaiKhoan" %>
<%
    // ========================== BẢO VỆ TRANG (SESSION CHECK) ==========================
    // 1. Lấy đối tượng TaiKhoan từ Session
    TaiKhoan currentAccount = (TaiKhoan) session.getAttribute("loggedInAccount");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

    // 2. Kiểm tra: Nếu không có tài khoản HOẶC không có cờ isAdmin, chuyển hướng về trang đăng nhập
    if (currentAccount == null || isAdmin == null || !isAdmin) {
        response.sendRedirect(request.getContextPath() + "/Signinforadmin.jsp");
        return;
    }

    // 3. Đặt đối tượng TaiKhoan vào request scope để có thể dùng EL
    request.setAttribute("userAccount", currentAccount);
%>
<!DOCTYPE html>
<html lang="vi">

<head>
     <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Quản lý Thư viện</title>
     <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css"> <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
 <div class="app">
     <aside class="sidebar">
     <div class="brand">
    <h1>📚 Thư viện</h1>
    <p>Hệ thống quản lý</p>
     </div>

     <nav class="nav">
     <a href="Dashboard.jsp" class="nav-link active">
     <span class="nav-icon">🏠</span> Dashboard
     </a>
     <a href="QuanLySach.html" class="nav-link">
     <span class="nav-icon">📖</span> Quản lý Sách
     </a>
     <a href="QuanLySinhVien.html" class="nav-link">
     <span class="nav-icon">🎓</span> Quản lý Sinh viên
     </a>
    <a href="QuanLyPhieu.html" class="nav-link">
     <span class="nav-icon">📋</span> Quản lý Phiếu
   </a>
     <a href="BaoCao.jsp" class="nav-link">
     <span class="nav-icon">📊</span> Báo cáo và Thống kê
     </a>
    <a href="${pageContext.request.contextPath}/home"
   class="nav-link"
   style="
       margin-top: 20px;
       display: flex;
       align-items: center;
       font-family: 'Inter', sans-serif;
       font-size: 16px;
       font-weight: 500;
       color: #ef4444;
       background: transparent;
       border-radius: 8px;
       padding: 10px 18px;
       transition: background 0.2s, color 0.2s;
   "
   onmouseover="this.style.background='#fee2e2'; this.style.color='#b91c1c';"
   onmouseout="this.style.background='transparent'; this.style.color='#ef4444';"
>
    <span class="nav-icon" style="margin-right: 8px;">🚪</span> Đăng xuất
</a>
     </nav>

    <div style="margin-top: auto; text-align: center; opacity: 0.8; font-size: 12px;">
   Người dùng: <strong style="font-size: 14px;">${userAccount.tenDangNhap}</strong> (${userAccount.vaiTro})
     </div>
     </aside>

     <main class="main">
    <div class="header">
    <div class="header-left">
     <h1>Dashboard</h1>
     <p>Tổng quan hoạt động thư viện - <span id="currentDate"></span></p>
     </div>
    </div>

     <div class="grid grid-4 mb-4">
     <div class="card stat-card"> <div class="stat-number" id="totalBooks">0</div> <div class="stat-label">Tổng số sách</div> </div>
     <div class="card stat-card"> <div class="stat-number" id="totalStudents">0</div> <div class="stat-label">Sinh viên đã đăng ký</div> </div>
     <div class="card stat-card"> <div class="stat-number" id="activeBorrows">0</div> <div class="stat-label">Phiếu mượn đang hoạt động</div> </div>
     <div class="card stat-card"> <div class="stat-number" id="overdueBooks">0</div> <div class="stat-label">Sách quá hạn</div> </div>
     </div>

    <div class="grid grid-2">
     <div class="card"><div class="card-header"><div><h3 class="card-title">Thống kê mượn trả theo tháng</h3><p class="card-subtitle">Biểu đồ xu hướng 6 tháng gần đây</p></div></div><div class="card-body"><div class="chart-container"><canvas id="borrowTrendChart"></canvas></div></div></div>
     <div class="card"><div class="card-header"><div><h3 class="card-title">Phân bố thể loại sách</h3><p class="card-subtitle">Thống kê theo thể loại</p></div></div><div class="card-body"><div class="chart-container"><canvas id="genreChart"></canvas></div></div></div>
     <div class="card"><div class="card-header"><div><h3 class="card-title">Top sách được mượn nhiều</h3><p class="card-subtitle">10 đầu sách phổ biến nhất</p></div></div><div class="card-body"><div class="chart-container"><canvas id="topBooksChart"></canvas></div></div></div>
   <div class="card"><div class="card-header"><div><h3 class="card-title">Hoạt động gần đây</h3><p class="card-subtitle">Các giao dịch mới nhất</p></div></div><div class="card-body"><div id="recentActivities"></div></div></div>
     </div>
     </main>
     </div>

<script>
    // (Phần JavaScript xử lý Chart và dữ liệu mẫu giữ nguyên)
    const dashboardData = { /* ... */ };
    function initializeDashboard() { /* ... */ }
    function updateStats() { /* ... */ }
    function initializeCharts() { /* ... */ }
    function updateRecentActivities() { /* ... */ }
    // ...
    document.addEventListener('DOMContentLoaded', function () {
        initializeDashboard();
    });
</script>
</body>

</html>