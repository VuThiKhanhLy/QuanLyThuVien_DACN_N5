<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo - Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
                <a href="Dashboard.html" class="nav-link">
                    <span class="nav-icon">🏠</span>
                    Dashboard
                </a>
                <a href="QuanLySach.html" class="nav-link">
                    <span class="nav-icon">📖</span>
                    Quản lý Sách
                </a>
                <a href="QuanLySinhVien.html" class="nav-link">
                    <span class="nav-icon">🎓</span>
                    Quản lý Sinh viên
                </a>
                <a href="QuanLyPhieu.html" class="nav-link">
                    <span class="nav-icon">📋</span>
                    Quản lý Phiếu
                </a>
                <a href="BaoCao.html" class="nav-link active">
                    <span class="nav-icon">📊</span>
                    Báo cáo và Thống kê
                </a>
            </nav>

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
                                <option value="borrow-stats">Thống kê mượn sách</option>
                                <option value="return-stats">Thống kê trả sách</option>
                                <option value="monthly-stats">Thống kê theo tháng</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Từ ngày</label>
                            <input type="date" id="startDate" class="form-input" onchange="updateReport()">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Đến ngày</label>
                            <input type="date" id="endDate" class="form-input" onchange="updateReport()">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Report Content -->
            <div id="reportContent">
                <!-- Summary Stats -->
                <div class="grid grid-4 mb-4">
                    <div class="card stat-card">
                        <div class="stat-number" id="totalBorrowsReport">0</div>
                        <div class="stat-label">Tổng phiếu mượn</div>
                    </div>
                    <div class="card stat-card">
                        <div class="stat-number" id="totalReturnsReport">0</div>
                        <div class="stat-label">Tổng phiếu trả</div>
                    </div>
                    <div class="card stat-card">
                        <div class="stat-number" id="activeBooks">0</div>
                        <div class="stat-label">Sách đang được mượn</div>
                    </div>
                    <div class="card stat-card">
                        <div class="stat-number" id="overdueCount">0</div>
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

                    <!-- Borrow vs Return Chart -->
                    <div class="card">
                        <div class="card-header">
                            <div>
                                <h3 class="card-title">Thống kê mượn trả theo tháng</h3>
                                <p class="card-subtitle">So sánh số lượng mượn và trả</p>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="borrowReturnChart"></canvas>
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
                        <div
                            style="display: flex; gap: 24px; border-bottom: 1px solid var(--border-light); margin-bottom: 20px;">
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
                                            <th>Tỷ lệ</th>
                                        </tr>
                                    </thead>
                                    <tbody id="booksDetailTableBody">
                                        <!-- Data will be populated here -->
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
                                        <!-- Data will be populated here -->
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
                                        <!-- Data will be populated here -->
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
        // Sample data - integrate with existing data from other pages
        const reportData = {
            books: [
                { maSach: 'SACH001', tenSach: 'Lập trình C# từ cơ bản đến nâng cao', theLoai: 'CNTT', soLanMuon: 45, dangMuon: 8 },
                { maSach: 'SACH002', tenSach: 'Cấu trúc dữ liệu và giải thuật', theLoai: 'CNTT', soLanMuon: 38, dangMuon: 5 },
                { maSach: 'SACH003', tenSach: 'Kinh tế học vi mô', theLoai: 'Kinh tế', soLanMuon: 32, dangMuon: 3 },
                { maSach: 'SACH004', tenSach: 'Lịch sử Việt Nam', theLoai: 'Lịch sử', soLanMuon: 28, dangMuon: 4 },
                { maSach: 'SACH005', tenSach: 'Truyện Kiều', theLoai: 'Văn học', soLanMuon: 24, dangMuon: 2 },
                { maSach: 'SACH006', tenSach: 'Toán cao cấp', theLoai: 'Khoa học', soLanMuon: 22, dangMuon: 6 },
                { maSach: 'SACH007', tenSach: 'Vật lý đại cương', theLoai: 'Khoa học', soLanMuon: 18, dangMuon: 3 },
                { maSach: 'SACH008', tenSach: 'Marketing căn bản', theLoai: 'Kinh tế', soLanMuon: 15, dangMuon: 1 }
            ],
            students: [
                { maSV: 'SV2023001', tenSV: 'Nguyễn Văn An', tongMuon: 12, daTra: 10, dangMuon: 2, quaHan: 0 },
                { maSV: 'SV2023002', tenSV: 'Trần Thị Bình', tongMuon: 10, daTra: 8, dangMuon: 2, quaHan: 0 },
                { maSV: 'SV2023003', tenSV: 'Lê Văn Cường', tongMuon: 8, daTra: 7, dangMuon: 1, quaHan: 0 },
                { maSV: 'SV2023004', tenSV: 'Phạm Thị Dung', tongMuon: 7, daTra: 5, dangMuon: 1, quaHan: 1 },
                { maSV: 'SV2023005', tenSV: 'Hoàng Văn Em', tongMuon: 6, daTra: 6, dangMuon: 0, quaHan: 0 }
            ],
            overdue: [
                { maPhieu: 'PM2023001', maSV: 'SV2023004', tenSV: 'Phạm Thị Dung', maSach: 'SACH001', tenSach: 'Lập trình C# từ cơ bản đến nâng cao', ngayMuon: '2023-08-15', ngayHenTra: '2023-08-29', soNgayTre: 25 }
            ],
            monthlyStats: {
                labels: ['Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9'],
                borrowed: [120, 145, 165, 180, 156, 234],
                returned: [115, 140, 160, 175, 150, 220]
            },
            genreStats: {
                labels: ['CNTT', 'Kinh tế', 'Văn học', 'Lịch sử', 'Khoa học'],
                data: [
                    45 + 38, // CNTT
                    32 + 15, // Kinh tế
                    24,      // Văn học
                    28,      // Lịch sử
                    22 + 18  // Khoa học
                ]
            }
        };

        let currentDetailTab = 'books';

        // Đảm bảo gọi hàm khi trang vừa tải
        document.addEventListener('DOMContentLoaded', function () {
            setupDefaultDates();
            updateReport();
            switchDetailTab('books');
        });

        // Đảm bảo khi chuyển tab thì cập nhật lại bảng chi tiết
        window.switchDetailTab = function (tab) {
            currentDetailTab = tab;
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.getElementById(tab + 'DetailTab').classList.add('active');
            document.getElementById('booksDetailSection').style.display = tab === 'books' ? 'block' : 'none';
            document.getElementById('studentsDetailSection').style.display = tab === 'students' ? 'block' : 'none';
            document.getElementById('overdueDetailSection').style.display = tab === 'overdue' ? 'block' : 'none';
            renderDetailTables();
        };

        window.updateReport = function () {
            updateSummaryStats();
            renderCharts();
            renderDetailTables();
        };

        function setupDefaultDates() {
            const today = new Date();
            const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
            document.getElementById('startDate').value = startOfMonth.toISOString().split('T')[0];
            document.getElementById('endDate').value = today.toISOString().split('T')[0];
        }

        function updateSummaryStats() {
            const totalBorrows = reportData.books.reduce((sum, book) => sum + book.soLanMuon, 0);
            const totalReturns = reportData.books.reduce((sum, book) => sum + (book.soLanMuon - book.dangMuon), 0);
            const activeBooks = reportData.books.reduce((sum, book) => sum + book.dangMuon, 0);
            const overdueCount = reportData.overdue.length;

            document.getElementById('totalBorrowsReport').textContent = totalBorrows;
            document.getElementById('totalReturnsReport').textContent = totalReturns;
            document.getElementById('activeBooks').textContent = activeBooks;
            document.getElementById('overdueCount').textContent = overdueCount;
        }

        function renderCharts() {
            renderTopBooksChart();
            renderBorrowReturnChart();
            renderGenreChart();
            renderStudentActivityChart();
        }

        function renderTopBooksChart() {
            const ctx = document.getElementById('topBooksChart').getContext('2d');
            const sortedBooks = [...reportData.books].sort((a, b) => b.soLanMuon - a.soLanMuon).slice(0, 10);

            if (window.topBooksChartInstance) window.topBooksChartInstance.destroy();

            window.topBooksChartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: sortedBooks.map(book => book.tenSach.length > 20 ? book.tenSach.substring(0, 20) + '...' : book.tenSach),
                    datasets: [{
                        label: 'Số lần mượn',
                        data: sortedBooks.map(book => book.soLanMuon),
                        backgroundColor: '#6366f1',
                        borderRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 5 } },
                        x: { ticks: { maxRotation: 45 } }
                    }
                }
            });
        }

        function renderBorrowReturnChart() {
            const ctx = document.getElementById('borrowReturnChart').getContext('2d');
            if (window.borrowReturnChartInstance) window.borrowReturnChartInstance.destroy();

            window.borrowReturnChartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: reportData.monthlyStats.labels,
                    datasets: [
                        {
                            label: 'Mượn',
                            data: reportData.monthlyStats.borrowed,
                            borderColor: '#6366f1',
                            backgroundColor: 'rgba(99, 102, 241, 0.1)',
                            fill: true,
                            tension: 0.4
                        },
                        {
                            label: 'Trả',
                            data: reportData.monthlyStats.returned,
                            borderColor: '#10b981',
                            backgroundColor: 'rgba(16, 185, 129, 0.1)',
                            fill: true,
                            tension: 0.4
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'top' } },
                    scales: { y: { beginAtZero: true } }
                }
            });
        }

        function renderGenreChart() {
            const ctx = document.getElementById('genreChart').getContext('2d');
            if (window.genreChartInstance) window.genreChartInstance.destroy();

            window.genreChartInstance = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: reportData.genreStats.labels,
                    datasets: [{
                        data: reportData.genreStats.data,
                        backgroundColor: [
                            '#6366f1', '#06b6d4', '#10b981', '#f59e0b', '#ef4444'
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
            const ctx = document.getElementById('studentActivityChart').getContext('2d');
            const sortedStudents = [...reportData.students].sort((a, b) => b.tongMuon - a.tongMuon).slice(0, 5);

            if (window.studentActivityChartInstance) window.studentActivityChartInstance.destroy();

            window.studentActivityChartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: sortedStudents.map(student => student.tenSV),
                    datasets: [{
                        label: 'Tổng mượn',
                        data: sortedStudents.map(student => student.tongMuon),
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

        function renderDetailTables() {
            renderBooksDetailTable();
            renderStudentsDetailTable();
            renderOverdueDetailTable();
        }

        function renderBooksDetailTable() {
            const tbody = document.getElementById('booksDetailTableBody');
            const sortedBooks = [...reportData.books].sort((a, b) => b.soLanMuon - a.soLanMuon);
            const totalBorrows = sortedBooks.reduce((sum, book) => sum + book.soLanMuon, 0);

            tbody.innerHTML = sortedBooks.map((book, index) => `
        <tr>
            <td><strong>${index + 1}</strong></td>
            <td>${book.maSach}</td>
            <td>${book.tenSach}</td>
            <td><span class="badge badge-info">${book.theLoai}</span></td>
            <td><strong>${book.soLanMuon}</strong></td>
            <td>${book.dangMuon}</td>
            <td>${((book.soLanMuon / totalBorrows) * 100).toFixed(1)}%</td>
        </tr>
    `).join('');
        }

        function renderStudentsDetailTable() {
            const tbody = document.getElementById('studentsDetailTableBody');
            const sortedStudents = [...reportData.students].sort((a, b) => b.tongMuon - a.tongMuon);

            tbody.innerHTML = sortedStudents.map((student, index) => `
        <tr>
            <td><strong>${index + 1}</strong></td>
            <td>${student.maSV}</td>
            <td>${student.tenSV}</td>
            <td><strong>${student.tongMuon}</strong></td>
            <td>${student.daTra}</td>
            <td>${student.dangMuon}</td>
            <td>
                <span class="badge ${student.quaHan > 0 ? 'badge-danger' : 'badge-success'}">
                    ${student.quaHan}
                </span>
            </td>
        </tr>
    `).join('');
        }

        function renderOverdueDetailTable() {
            const tbody = document.getElementById('overdueDetailTableBody');
            if (reportData.overdue.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có sách quá hạn</td></tr>';
                return;
            }
            tbody.innerHTML = reportData.overdue.map(item => `
        <tr>
            <td><strong>${item.maPhieu}</strong></td>
            <td>${item.maSV}</td>
            <td>${item.tenSV}</td>
            <td>${item.maSach}</td>
            <td>${item.tenSach}</td>
            <td>${formatDate(item.ngayMuon)}</td>
            <td>${formatDate(item.ngayHenTra)}</td>
            <td>
                <span class="badge badge-danger">
                    ${item.soNgayTre} ngày
                </span>
            </td>
        </tr>
    `).join('');
        }

        function exportToPDF() {
            window.print();
        }

        function exportToWord() {
            const reportContent = document.getElementById('reportContent').innerHTML;
            const reportType = document.getElementById('reportType').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;

            const wordContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Báo cáo Thư viện</title>
            <style>
                body { font-family: 'Times New Roman', serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .stats { display: flex; justify-content: space-around; margin: 20px 0; }
                .stat-item { text-align: center; }
                table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
                th { background-color: #f5f5f5; }
                .badge { padding: 3px 8px; border-radius: 4px; font-size: 12px; }
                .badge-info { background-color: #e3f2fd; color: #0277bd; }
                .badge-success { background-color: #e8f5e8; color: #2e7d32; }
                .badge-danger { background-color: #ffebee; color: #c62828; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>BÁO CÁO THƯ VIỆN</h1>
                <p>Thời gian: ${formatDate(startDate)} - ${formatDate(endDate)}</p>
                <p>Ngày tạo: ${new Date().toLocaleDateString('vi-VN')}</p>
            </div>
            ${generateWordContent()}
        </body>
        </html>
    `;

            const blob = new Blob([wordContent], { type: 'application/msword' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            link.href = url;
            link.download = `bao_cao_thu_vien_${new Date().toISOString().split('T')[0]}.doc`;
            link.click();
            URL.revokeObjectURL(url);
        }

        function generateWordContent() {
            const totalBorrows = reportData.books.reduce((sum, book) => sum + book.soLanMuon, 0);
            const totalReturns = reportData.books.reduce((sum, book) => sum + (book.soLanMuon - book.dangMuon), 0);
            const activeBooks = reportData.books.reduce((sum, book) => sum + book.dangMuon, 0);
            const overdueCount = reportData.overdue.length;

            const sortedBooks = [...reportData.books].sort((a, b) => b.soLanMuon - a.soLanMuon);
            const sortedStudents = [...reportData.students].sort((a, b) => b.tongMuon - a.tongMuon);

            return `
        <div class="stats">
            <div class="stat-item">
                <h3>${totalBorrows}</h3>
                <p>Tổng phiếu mượn</p>
            </div>
            <div class="stat-item">
                <h3>${totalReturns}</h3>
                <p>Tổng phiếu trả</p>
            </div>
            <div class="stat-item">
                <h3>${activeBooks}</h3>
                <p>Sách đang được mượn</p>
            </div>
            <div class="stat-item">
                <h3>${overdueCount}</h3>
                <p>Sách quá hạn</p>
            </div>
        </div>

        <h2>1. TOP SÁCH ĐƯỢC MƯỢN NHIỀU NHẤT</h2>
        <table>
            <thead>
                <tr>
                    <th>Hạng</th>
                    <th>Mã sách</th>
                    <th>Tên sách</th>
                    <th>Thể loại</th>
                    <th>Số lần mượn</th>
                    <th>Tỷ lệ %</th>
                </tr>
            </thead>
            <tbody>
                ${sortedBooks.slice(0, 10).map((book, index) => `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${book.maSach}</td>
                        <td>${book.tenSach}</td>
                        <td><span class="badge badge-info">${book.theLoai}</span></td>
                        <td>${book.soLanMuon}</td>
                        <td>${((book.soLanMuon / totalBorrows) * 100).toFixed(1)}%</td>
                    </tr>
                `).join('')}
            </tbody>
        </table>

        <h2>2. TOP SINH VIÊN HOẠT ĐỘNG NHIỀU NHẤT</h2>
        <table>
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
            <tbody>
                ${sortedStudents.map((student, index) => `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${student.maSV}</td>
                        <td>${student.tenSV}</td>
                        <td>${student.tongMuon}</td>
                        <td>${student.daTra}</td>
                        <td>${student.dangMuon}</td>
                        <td><span class="badge ${student.quaHan > 0 ? 'badge-danger' : 'badge-success'}">${student.quaHan}</span></td>
                    </tr>
                `).join('')}
            </tbody>
        </table>

        ${overdueCount > 0 ? `
            <h2>3. DANH SÁCH SÁCH QUÁ HẠN</h2>
            <table>
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
                <tbody>
                    ${reportData.overdue.map(item => `
                        <tr>
                            <td>${item.maPhieu}</td>
                            <td>${item.maSV}</td>
                            <td>${item.tenSV}</td>
                            <td>${item.maSach}</td>
                            <td>${item.tenSach}</td>
                            <td>${formatDate(item.ngayMuon)}</td>
                            <td>${formatDate(item.ngayHenTra)}</td>
                            <td><span class="badge badge-danger">${item.soNgayTre} ngày</span></td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        ` : '<h2>3. DANH SÁCH SÁCH QUÁ HẠN</h2><p>Hiện tại không có sách quá hạn.</p>'}

        <h2>4. THỐNG KÊ THEO THỂ LOẠI</h2>
        <table>
            <thead>
                <tr>
                    <th>Thể loại</th>
                    <th>Số lượt mượn</th>
                    <th>Tỷ lệ %</th>
                </tr>
            </thead>
            <tbody>
                ${reportData.genreStats.labels.map((genre, index) => `
                    <tr>
                        <td><span class="badge badge-info">${genre}</span></td>
                        <td>${reportData.genreStats.data[index]}</td>
                        <td>${((reportData.genreStats.data[index] / reportData.genreStats.data.reduce((a, b) => a + b, 0)) * 100).toFixed(1)}%</td>
                    </tr>
                `).join('')}
            </tbody>
        </table>

        <div style="margin-top: 40px; text-align: center;">
            <p><strong>--- HẾT BÁO CÁO ---</strong></p>
            <p style="font-size: 12px; color: #666;">
                Báo cáo được tạo tự động từ Hệ thống quản lý Thư viện<br>
                Thời gian tạo: ${new Date().toLocaleString('vi-VN')}
            </p>
        </div>
    `;
        }

        function formatDate(dateString) {
            if (!dateString) return 'N/A';
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount);
        }

        // Tự động cập nhật lại dữ liệu mỗi 5 phút
        setInterval(function () {
            updateReport();
        }, 300000);
        function exportDetailTableToWord() {
            let tableHtml = '';
            let title = '';

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

            const wordContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Báo cáo chi tiết - Thư viện</title>
            <style>
                body { font-family: 'Times New Roman', serif; margin: 20px; }
                h2 { text-align: center; }
                table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
                th { background-color: #f5f5f5; }
                .badge { padding: 3px 8px; border-radius: 4px; font-size: 12px; }
                .badge-info { background-color: #e3f2fd; color: #0277bd; }
                .badge-success { background-color: #e8f5e8; color: #2e7d32; }
                .badge-danger { background-color: #ffebee; color: #c62828; }
            </style>
        </head>
        <body>
            <h2>BÁO CÁO ${title.toUpperCase()}</h2>
            ${tableHtml}
            <div style="margin-top: 40px; text-align: center;">
                <p><strong>--- HẾT BÁO CÁO ---</strong></p>
                <p style="font-size: 12px; color: #666;">
                    Báo cáo được tạo tự động từ Hệ thống quản lý Thư viện<br>
                    Thời gian tạo: ${new Date().toLocaleString('vi-VN')}
                </p>
            </div>
        </body>
        </html>
    `;

            const blob = new Blob([wordContent], { type: 'application/msword' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            link.href = url;
            link.download = `bao_cao_chi_tiet_${title.replace(/\s/g, '_').toLowerCase()}_${new Date().toISOString().split('T')[0]}.doc`;
            link.click();
            URL.revokeObjectURL(url);
        }
    </script>
</body>

</html>