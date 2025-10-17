<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    LocalDate today = LocalDate.now();
    LocalDate startOfMonth = today.withDayOfMonth(1);
    String todayStr = today.format(formatter);
    String startStr = startOfMonth.format(formatter);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo - Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Anh/logo.png" sizes="512x512">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
</head>
<body>
<div class="app">
    <aside class="sidebar">
        <div class="brand">
            <h1>📚 Thư viện</h1>
            <p>Hệ thống quản lý</p>
        </div>

        <nav class="nav">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <span class="nav-icon">🏠</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/BookServlet" class="nav-link">
                <span class="nav-icon">📖</span> Quản lý Sách
            </a>
            <a href="${pageContext.request.contextPath}/StudentServlet" class="nav-link">
                <span class="nav-icon">🎓</span> Quản lý Sinh viên
            </a>
            <a href="${pageContext.request.contextPath}/BorrowSlipServlet" class="nav-link">
                <span class="nav-icon">📋</span> Quản lý Phiếu
            </a>
            <a href="${pageContext.request.contextPath}/ReportServlet" class="nav-link active">
                <span class="nav-icon">📊</span> Báo cáo và Thống kê
            </a>
            <a href="${pageContext.request.contextPath}/loginSelection"
               class="nav-link"
               style="
                       margin-top:
                       20px;
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
               onmouseout="this.style.background='transparent';
                           this.style.color='#ef4444';"
            >
                <span class="nav-icon" style="margin-right: 8px;">🚪</span> Đăng xuất
            </a>
        </nav>

        </a>
        <div style="margin-top: auto; text-align: center; opacity: 0.8; font-size: 12px;">
            Người dùng: Admin
        </div>
    </aside>

    <main class="main">
        <div class="header">
            <div class="header-left">
                <h1>Báo cáo và Thống kê</h1>
                <p>Tạo và xuất các báo cáo chi tiết về hoạt động thư viện</p>
            </div>
            <div class="header-right">
                <button class="btn btn-secondary" onclick="exportToPDF()">
                    <span>📄</span>
                    Xuất PDF
                </button>
                <button class="btn btn-primary" onclick="exportToWord()">
                    <span>📝</span>
                    Xuất Word
                </button>
            </div>
        </div>

        <!-- Report Controls -->
        <div class="card mb-4">
            <div class="card-header">
                <h3 class="card-title">Tùy chọn báo cáo</h3>
            </div>
            <div class="card-body">
                <div class="grid grid-3">
                    <div class="form-group">
                        <label class="form-label">Loại báo cáo</label>
                        <select id="reportType" class="form-select" onchange="updateReport()">
                            <option value="all">Tất cả báo cáo</option>
                            <option value="top-books">Top sách được mượn nhiều</option>
                            <option value="top-students">Top sinh viên hoạt động</option>
                            <option value="overdue">Sách quá hạn</option>
                            <option value="genre">Thống kê theo thể loại</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" id="startDate" class="form-input" value="<%= startStr %>" onchange="updateReport()">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" id="endDate" class="form-input" value="<%= todayStr %>" onchange="updateReport()">
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Content -->
        <div id="reportContent">
            <!-- Summary Stats -->
            <div class="grid grid-4 mb-4">
                <div class="card stat-card">
                    <div class="stat-number" id="totalBorrowsReport">-</div>
                    <div class="stat-label">Tổng phiếu mượn</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-number" id="totalReturnsReport">-</div>
                    <div class="stat-label">Tổng phiếu trả</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-number" id="activeBooks">-</div>
                    <div class="stat-label">Sách đang được mượn</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-number" id="overdueCount">-</div>
                    <div class="stat-label">Sách quá hạn</div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="grid grid-2">
                <!-- Top Books Chart -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h3 class="card-title">Top sách được mượn nhiều nhất</h3>
                            <p class="card-subtitle">Xếp hạng theo số lượt mượn</p>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="topBooksChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Genre Distribution -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h3 class="card-title">Phân bố theo thể loại</h3>
                            <p class="card-subtitle">Tỷ lệ mượn theo thể loại sách</p>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="genreChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Student Activity -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h3 class="card-title">Top sinh viên hoạt động</h3>
                            <p class="card-subtitle">Sinh viên mượn sách nhiều nhất</p>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="studentActivityChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Overdue Books -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h3 class="card-title">Sách quá hạn</h3>
                            <p class="card-subtitle">Danh sách sách chưa trả đúng hạn</p>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Sinh viên</th>
                                    <th>Sách</th>
                                    <th>Trễ (ngày)</th>
                                </tr>
                                </thead>
                                <tbody id="overdueTableBody">
                                <tr><td colspan="4" class="text-center">Đang tải dữ liệu...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detailed Tables -->
            <div class="card mt-4">
                <div class="card-header">
                    <h3 class="card-title">Bảng thống kê chi tiết</h3>
                    <button class="btn btn-primary" onclick="exportDetailTableToWord()">
                        <span>📝</span>
                        Xuất bảng chi tiết (Word)
                    </button>
                </div>
                <div class="card-body">
                    <!-- Tab Navigation -->
                    <div style="display: flex; gap: 24px; border-bottom: 1px solid var(--border-light); margin-bottom: 20px;">
                        <button class="tab-btn active" onclick="switchDetailTab('books')" id="booksDetailTab">
                            📚 Thống kê sách
                        </button>
                        <button class="tab-btn" onclick="switchDetailTab('students')" id="studentsDetailTab">
                            🎓 Thống kê sinh viên
                        </button>
                        <button class="tab-btn" onclick="switchDetailTab('overdue')" id="overdueDetailTab">
                            ⚠️ Sách quá hạn
                        </button>
                    </div>

                    <!-- Books Detail Table -->
                    <div id="booksDetailSection">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hạng</th>
                                    <th>Mã sách</th>
                                    <th>Tên sách</th>
                                    <th>Thể loại</th>
                                    <th>Số lần mượn</th>
                                    <th>Đang mượn</th>
                                </tr>
                                </thead>
                                <tbody id="booksDetailTableBody">
                                <tr><td colspan="6" class="text-center">Đang tải dữ liệu...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Students Detail Table -->
                    <div id="studentsDetailSection" style="display: none;">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hạng</th>
                                    <th>Mã SV</th>
                                    <th>Họ tên</th>
                                    <th>Tổng mượn</th>
                                    <th>Đã trả</th>
                                    <th>Đang mượn</th>
                                    <th>Quá hạn</th>
                                </tr>
                                </thead>
                                <tbody id="studentsDetailTableBody">
                                <tr><td colspan="7" class="text-center">Đang tải dữ liệu...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Overdue Detail Table -->
                    <div id="overdueDetailSection" style="display: none;">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Mã SV</th>
                                    <th>Tên sinh viên</th>
                                    <th>Mã sách</th>
                                    <th>Tên sách</th>
                                    <th>Ngày mượn</th>
                                    <th>Ngày hẹn trả</th>
                                    <th>Số ngày trễ</th>
                                </tr>
                                </thead>
                                <tbody id="overdueDetailTableBody">
                                <tr><td colspan="8" class="text-center">Đang tải dữ liệu...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<style>
    .tab-btn {
        background: none;
        border: none;
        padding: 12px 0;
        font-weight: 500;
        color: var(--text-secondary);
        cursor: pointer;
        border-bottom: 2px solid transparent;
        transition: all 0.2s ease;
    }

    .tab-btn.active {
        color: var(--primary);
        border-bottom-color: var(--primary);
    }

    .tab-btn:hover {
        color: var(--primary);
    }

    .chart-container {
        position: relative;
        height: 300px;
        width: 100%;
    }

    .text-center {
        text-align: center;
    }

    .badge {
        display: inline-block;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 500;
    }

    .badge-info {
        background-color: #e3f2fd;
        color: #0277bd;
    }

    .badge-success {
        background-color: #e8f5e8;
        color: #2e7d32;
    }

    .badge-danger {
        background-color: #ffebee;
        color: #c62828;
    }

    @media print {
        .sidebar,
        .header-right {
            display: none !important;
        }

        .main {
            margin-left: 0 !important;
            width: 100% !important;
        }
    }
</style>

<script>
    // Khai báo dữ liệu ở ngoài hàm
    var reportData = {
        books: [],
        students: [],
        overdue: [],
        genreStats: {}
    };

    var currentDetailTab = 'books';

    // Lấy API base từ context path
    var contextPath = '<%=request.getContextPath()%>';
    var apiBase = contextPath + '/ReportServlet';

    // Gọi API và cập nhật dữ liệu
    async function fetchAllData() {
        console.log('Bắt đầu tải dữ liệu từ server...');

        try {
            await fetchSummaryStats();
            await fetchTopBooks();
            await fetchTopStudents();
            await fetchOverdueBooks();
            await fetchGenreDistribution();

            console.log('Dữ liệu đã tải xong');
            updateReport();
        } catch (error) {
            console.error('Lỗi khi tải dữ liệu:', error);
            showError('Lỗi khi tải dữ liệu từ server');
        }
    }

    async function fetchSummaryStats() {
        try {
            var response = await fetch(apiBase + '?action=getSummaryStats');
            if (!response.ok) throw new Error('HTTP ' + response.status);

            var data = await response.json();
            console.log('Summary Stats:', data);

            document.getElementById('totalBorrowsReport').textContent = data.totalBorrows || 0;
            document.getElementById('totalReturnsReport').textContent = data.totalReturns || 0;
            document.getElementById('activeBooks').textContent = data.activeBooks || 0;
            document.getElementById('overdueCount').textContent = data.overdueCount || 0;
        } catch (error) {
            console.error('Lỗi getSummaryStats:', error);
        }
    }

    async function fetchTopBooks() {
        try {
            var response = await fetch(apiBase + '?action=getTopBooks&limit=10');
            if (!response.ok) throw new Error('HTTP ' + response.status);

            reportData.books = await response.json();
            console.log('Top Books:', reportData.books);
        } catch (error) {
            console.error('Lỗi getTopBooks:', error);
            reportData.books = [];
        }
    }

    async function fetchTopStudents() {
        try {
            var response = await fetch(apiBase + '?action=getTopStudents&limit=10');
            if (!response.ok) throw new Error('HTTP ' + response.status);

            reportData.students = await response.json();
            console.log('Top Students:', reportData.students);
        } catch (error) {
            console.error('Lỗi getTopStudents:', error);
            reportData.students = [];
        }
    }

    async function fetchOverdueBooks() {
        try {
            var response = await fetch(apiBase + '?action=getOverdueBooks');
            if (!response.ok) throw new Error('HTTP ' + response.status);

            reportData.overdue = await response.json();
            console.log('Overdue Books:', reportData.overdue);
        } catch (error) {
            console.error('Lỗi getOverdueBooks:', error);
            reportData.overdue = [];
        }
    }

    async function fetchGenreDistribution() {
        try {
            var response = await fetch(apiBase + '?action=getGenreDistribution');
            if (!response.ok) throw new Error('HTTP ' + response.status);

            reportData.genreStats = await response.json();
            console.log('Genre Distribution:', reportData.genreStats);
        } catch (error) {
            console.error('Lỗi getGenreDistribution:', error);
            reportData.genreStats = {};
        }
    }

    function showError(message) {
        console.error(message);
        alert('Lỗi: ' + message);
    }

    document.addEventListener('DOMContentLoaded', function () {
        fetchAllData();
    });

    window.switchDetailTab = function (tab) {
        currentDetailTab = tab;
        document.querySelectorAll('.tab-btn').forEach(function(btn) {
            btn.classList.remove('active');
        });
        document.getElementById(tab + 'DetailTab').classList.add('active');
        document.getElementById('booksDetailSection').style.display = tab === 'books' ? 'block' : 'none';
        document.getElementById('studentsDetailSection').style.display = tab === 'students' ? 'block' : 'none';
        document.getElementById('overdueDetailSection').style.display = tab === 'overdue' ? 'block' : 'none';
        renderDetailTables();
    };

    window.updateReport = function () {
        renderCharts();
        renderDetailTables();
    };

    function renderCharts() {
        renderTopBooksChart();
        renderGenreChart();
        renderStudentActivityChart();
        renderOverdueTable();
    }

    function renderTopBooksChart() {
        var ctx = document.getElementById('topBooksChart').getContext('2d');
        var books = reportData.books.slice(0, 10);

        if (window.topBooksChartInstance) window.topBooksChartInstance.destroy();

        window.topBooksChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: books.map(function(book) {
                    return book.tenSach.length > 20 ? book.tenSach.substring(0, 20) + '...' : book.tenSach;
                }),
                datasets: [{
                    label: 'Số lần mượn',
                    data: books.map(function(book) { return book.soLanMuon; }),
                    backgroundColor: '#6366f1',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true },
                    x: { ticks: { maxRotation: 45 } }
                }
            }
        });
    }

    function renderGenreChart() {
        var ctx = document.getElementById('genreChart').getContext('2d');
        var labels = Object.keys(reportData.genreStats);
        var data = Object.values(reportData.genreStats);

        if (window.genreChartInstance) window.genreChartInstance.destroy();

        window.genreChartInstance = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: [
                        '#6366f1', '#06b6d4', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } }
            }
        });
    }

    function renderStudentActivityChart() {
        var ctx = document.getElementById('studentActivityChart').getContext('2d');
        var students = reportData.students.slice(0, 5);

        if (window.studentActivityChartInstance) window.studentActivityChartInstance.destroy();

        window.studentActivityChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: students.map(function(student) { return student.tenSV; }),
                datasets: [{
                    label: 'Tổng mượn',
                    data: students.map(function(student) { return student.tongMuon; }),
                    backgroundColor: '#10b981',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });
    }

    function renderOverdueTable() {
        var tbody = document.getElementById('overdueTableBody');

        if (reportData.overdue.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center">Không có sách quá hạn</td></tr>';
            return;
        }

        tbody.innerHTML = reportData.overdue.slice(0, 5).map(function(item) {
            return '<tr><td>' + item.maPhieu + '</td><td>' + item.tenSV + '</td><td>' + item.tenSach + '</td><td><span class="badge badge-danger">' + item.soNgayTre + ' ngày</span></td></tr>';
        }).join('');
    }

    function renderDetailTables() {
        renderBooksDetailTable();
        renderStudentsDetailTable();
        renderOverdueDetailTable();
    }

    function renderBooksDetailTable() {
        var tbody = document.getElementById('booksDetailTableBody');

        if (reportData.books.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" class="text-center">Không có dữ liệu</td></tr>';
            return;
        }

        tbody.innerHTML = reportData.books.map(function(book, index) {
            return '<tr><td><strong>' + (index + 1) + '</strong></td><td>' + book.maSach + '</td><td>' + book.tenSach + '</td><td><span class="badge badge-info">' + book.theLoai + '</span></td><td><strong>' + book.soLanMuon + '</strong></td><td>' + book.dangMuon + '</td></tr>';
        }).join('');
    }

    function renderStudentsDetailTable() {
        var tbody = document.getElementById('studentsDetailTableBody');

        if (reportData.students.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center">Không có dữ liệu</td></tr>';
            return;
        }

        tbody.innerHTML = reportData.students.map(function(student, index) {
            var badgeClass = student.quaHan > 0 ? 'badge-danger' : 'badge-success';
            return '<tr><td><strong>' + (index + 1) + '</strong></td><td>' + student.maSV + '</td><td>' + student.tenSV + '</td><td><strong>' + student.tongMuon + '</strong></td><td>' + student.daTra + '</td><td>' + student.dangMuon + '</td><td><span class="badge ' + badgeClass + '">' + student.quaHan + '</span></td></tr>';
        }).join('');
    }

    function renderOverdueDetailTable() {
        var tbody = document.getElementById('overdueDetailTableBody');

        if (reportData.overdue.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có sách quá hạn</td></tr>';
            return;
        }

        tbody.innerHTML = reportData.overdue.map(function(item) {
            return '<tr><td><strong>' + item.maPhieu + '</strong></td><td>' + item.maSV + '</td><td>' + item.tenSV + '</td><td>' + item.maSach + '</td><td>' + item.tenSach + '</td><td>' + formatDate(item.ngayMuon) + '</td><td>' + formatDate(item.ngayHenTra) + '</td><td><span class="badge badge-danger">' + item.soNgayTre + ' ngày</span></td></tr>';
        }).join('');
    }

    function formatDate(dateString) {
        if (!dateString) return 'N/A';
        var date = new Date(dateString);
        return date.toLocaleDateString('vi-VN');
    }

    function exportToPDF() {
        window.print();
    }

    function exportToWord() {
        var startDate = document.getElementById('startDate').value;
        var endDate = document.getElementById('endDate').value;

        var wordContent = '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Báo cáo Thư viện</title><style>body { font-family: "Times New Roman", serif; margin: 20px; } .header { text-align: center; margin-bottom: 30px; } .stats { display: flex; justify-content: space-around; margin: 20px 0; } .stat-item { text-align: center; } table { width: 100%; border-collapse: collapse; margin: 20px 0; } th, td { border: 1px solid #ccc; padding: 8px; text-align: left; } th { background-color: #f5f5f5; } .badge { padding: 3px 8px; border-radius: 4px; font-size: 12px; } .badge-info { background-color: #e3f2fd; color: #0277bd; } .badge-success { background-color: #e8f5e8; color: #2e7d32; } .badge-danger { background-color: #ffebee; color: #c62828; }</style></head><body><div class="header"><h1>BÁO CÁO THƯ VIỆN</h1><p>Thời gian: ' + formatDate(startDate) + ' - ' + formatDate(endDate) + '</p><p>Ngày tạo: ' + new Date().toLocaleDateString('vi-VN') + '</p></div>' + generateWordContent() + '</body></html>';

        var blob = new Blob([wordContent], { type: 'application/msword' });
        var link = document.createElement('a');
        var url = URL.createObjectURL(blob);
        link.href = url;
        link.download = 'bao_cao_thu_vien_' + new Date().toISOString().split('T')[0] + '.doc';
        link.click();
        URL.revokeObjectURL(url);
    }

    function generateWordContent() {
        var totalBorrows = reportData.books.reduce(function(sum, book) { return sum + book.soLanMuon; }, 0);
        var totalReturns = reportData.books.reduce(function(sum, book) { return sum + (book.soLanMuon - book.dangMuon); }, 0);
        var activeBooks = document.getElementById('activeBooks').textContent;
        var overdueCount = reportData.overdue.length;

        var booksHtml = reportData.books.slice(0, 10).map(function(book, index) {
            return '<tr><td>' + (index + 1) + '</td><td>' + book.maSach + '</td><td>' + book.tenSach + '</td><td><span class="badge badge-info">' + book.theLoai + '</span></td><td>' + book.soLanMuon + '</td></tr>';
        }).join('');

        var studentsHtml = reportData.students.map(function(student, index) {
            var badgeClass = student.quaHan > 0 ? 'badge-danger' : 'badge-success';
            return '<tr><td>' + (index + 1) + '</td><td>' + student.maSV + '</td><td>' + student.tenSV + '</td><td>' + student.tongMuon + '</td><td>' + student.daTra + '</td><td>' + student.dangMuon + '</td><td><span class="badge ' + badgeClass + '">' + student.quaHan + '</span></td></tr>';
        }).join('');

        var overdueHtml = reportData.overdue.map(function(item) {
            return '<tr><td>' + item.maPhieu + '</td><td>' + item.maSV + '</td><td>' + item.tenSV + '</td><td>' + item.maSach + '</td><td>' + item.tenSach + '</td><td>' + formatDate(item.ngayMuon) + '</td><td>' + formatDate(item.ngayHenTra) + '</td><td><span class="badge badge-danger">' + item.soNgayTre + ' ngày</span></td></tr>';
        }).join('');

        var genreHtml = Object.entries(reportData.genreStats).map(function(entry) {
            return '<tr><td><span class="badge badge-info">' + entry[0] + '</span></td><td>' + entry[1] + '</td></tr>';
        }).join('');

        return '<div class="stats"><div class="stat-item"><h3>' + totalBorrows + '</h3><p>Tổng phiếu mượn</p></div><div class="stat-item"><h3>' + totalReturns + '</h3><p>Tổng phiếu trả</p></div><div class="stat-item"><h3>' + activeBooks + '</h3><p>Sách đang được mượn</p></div><div class="stat-item"><h3>' + overdueCount + '</h3><p>Sách quá hạn</p></div></div><h2>1. TOP SÁCH ĐƯỢC MƯỢN NHIỀU NHẤT</h2><table><thead><tr><th>Hạng</th><th>Mã sách</th><th>Tên sách</th><th>Thể loại</th><th>Số lần mượn</th></tr></thead><tbody>' + booksHtml + '</tbody></table><h2>2. TOP SINH VIÊN HOẠT ĐỘNG NHIỀU NHẤT</h2><table><thead><tr><th>Hạng</th><th>Mã SV</th><th>Họ tên</th><th>Tổng mượn</th><th>Đã trả</th><th>Đang mượn</th><th>Quá hạn</th></tr></thead><tbody>' + studentsHtml + '</tbody></table>' + (overdueCount > 0 ? '<h2>3. DANH SÁCH SÁCH QUÁ HẠN</h2><table><thead><tr><th>Mã phiếu</th><th>Mã SV</th><th>Tên sinh viên</th><th>Mã sách</th><th>Tên sách</th><th>Ngày mượn</th><th>Ngày hẹn trả</th><th>Số ngày trễ</th></tr></thead><tbody>' + overdueHtml + '</tbody></table>' : '<h2>3. DANH SÁCH SÁCH QUÁ HẠN</h2><p>Hiện tại không có sách quá hạn.</p>') + '<h2>4. THỐNG KÊ THEO THỂ LOẠI</h2><table><thead><tr><th>Thể loại</th><th>Số lượt mượn</th></tr></thead><tbody>' + genreHtml + '</tbody></table><div style="margin-top: 40px; text-align: center;"><p><strong>--- HẾT BÁO CÁO ---</strong></p><p style="font-size: 12px; color: #666;">Báo cáo được tạo tự động từ Hệ thống quản lý Thư viện<br>Thời gian tạo: ' + new Date().toLocaleString('vi-VN') + '</p></div>';
    }

    function exportDetailTableToWord() {
        var tableHtml = '';
        var title = '';

        if (currentDetailTab === 'books') {
            title = 'Thống kê sách';
            tableHtml = document.getElementById('booksDetailSection').innerHTML;
        } else if (currentDetailTab === 'students') {
            title = 'Thống kê sinh viên';
            tableHtml = document.getElementById('studentsDetailSection').innerHTML;
        } else if (currentDetailTab === 'overdue') {
            title = 'Sách quá hạn';
            tableHtml = document.getElementById('overdueDetailSection').innerHTML;
        }

        var wordContent = '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Báo cáo chi tiết - Thư viện</title><style>body { font-family: "Times New Roman", serif; margin: 20px; } h2 { text-align: center; } table { width: 100%; border-collapse: collapse; margin: 20px 0; } th, td { border: 1px solid #ccc; padding: 8px; text-align: left; } th { background-color: #f5f5f5; } .badge { padding: 3px 8px; border-radius: 4px; font-size: 12px; } .badge-info { background-color: #e3f2fd; color: #0277bd; } .badge-success { background-color: #e8f5e8; color: #2e7d32; } .badge-danger { background-color: #ffebee; color: #c62828; }</style></head><body><h2>BÁO CÁO ' + title.toUpperCase() + '</h2>' + tableHtml + '<div style="margin-top: 40px; text-align: center;"><p><strong>--- HẾT BÁO CÁO ---</strong></p><p style="font-size: 12px; color: #666;">Báo cáo được tạo tự động từ Hệ thống quản lý Thư viện<br>Thời gian tạo: ' + new Date().toLocaleString('vi-VN') + '</p></div></body></html>';

        var blob = new Blob([wordContent], { type: 'application/msword' });
        var link = document.createElement('a');
        var url = URL.createObjectURL(blob);
        link.href = url;
        link.download = 'bao_cao_chi_tiet_' + title.replace(/\s/g, '_').toLowerCase() + '_' + new Date().toISOString().split('T')[0] + '.doc';
        link.click();
        URL.revokeObjectURL(url);
    }

    // Tự động cập nhật dữ liệu mỗi 5 phút
    setInterval(function () {
        fetchAllData();
    }, 300000);
</script>
</body>
</html>