<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Phiếu - Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="app">
        <aside class="sidebar">
            <div class="brand">
                <h1>📚 Thư viện</h1>
                <p>Hệ thống quản lý</p>
            </div>

            <nav class="nav">
                <a href="Dashboard.jsp" class="nav-link">
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
                <a href="QuanLyPhieu.html" class="nav-link active">
                    <span class="nav-icon">📋</span>
                    Quản lý Phiếu
                </a>
                <a href="BaoCao.jsp" class="nav-link">
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
                    <h1>Quản lý Phiếu</h1>
                    <p>Tạo phiếu mượn, phiếu trả và quản lý giao dịch</p>
                </div>
                <div class="header-right">
                    <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm phiếu...">
                    <button class="btn btn-secondary" onclick="openBorrowModal()">
                        <span>📖</span>
                        Tạo phiếu mượn
                    </button>
                    <button class="btn btn-primary" onclick="openReturnModal()">
                        <span>✅</span>
                        Tạo phiếu trả
                    </button>
                </div>
            </div>

            <!-- Tab Navigation -->
            <div class="card mb-4">
                <div class="card-body" style="padding: 16px 24px;">
                    <div style="display: flex; gap: 24px; border-bottom: 1px solid var(--border-light);">
                        <button class="tab-btn active" onclick="switchTab('borrow')" id="borrowTab">
                            📖 Phiếu mượn
                        </button>
                        <button class="tab-btn" onclick="switchTab('return')" id="returnTab">
                            ✅ Phiếu trả
                        </button>
                    </div>
                </div>
            </div>

            <!-- Borrow Slips Table -->
            <div id="borrowSection" class="card">
                <div class="card-header">
                    <div>
                        <h3 class="card-title">Danh sách phiếu mượn</h3>
                        <p class="card-subtitle">Tổng cộng: <span id="totalBorrowCount">0</span> phiếu mượn</p>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <select id="statusFilter" class="form-select" style="width: 150px;">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Đang mượn">Đang mượn</option>
                            <option value="Quá hạn">Quá hạn</option>
                            <option value="Đã trả">Đã trả</option>
                        </select>
                        <button class="btn btn-outline" onclick="exportBorrowToCSV()">
                            <span>📄</span>
                            Xuất CSV
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Mã sinh viên</th>
                                    <th>Mã sách</th>
                                    <th>Ngày mượn</th>
                                    <th>Ngày hẹn trả</th>
                                    <th>Hạn trả</th>
                                    <th>Trạng thái</th>
                                    <th>Nhân viên</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="borrowTableBody">
                                <!-- Dữ liệu phiếu mượn sẽ được render ở đây -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Return Slips Table -->
            <div id="returnSection" class="card" style="display: none;">
                <div class="card-header">
                    <div>
                        <h3 class="card-title">Danh sách phiếu trả</h3>
                        <p class="card-subtitle">Tổng cộng: <span id="totalReturnCount">0</span> phiếu trả</p>
                    </div>
                    <div>
                        <button class="btn btn-outline" onclick="exportReturnToCSV()">
                            <span>📄</span>
                            Xuất CSV
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Mã phiếu trả</th>
                                    <th>Mã phiếu mượn</th>
                                    <th>Mã sách</th>
                                    <th>Ngày trả</th>
                                    <th>Số ngày trễ</th>
                                    <th>Nhân viên</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="returnTableBody">
                                <!-- Dữ liệu phiếu trả sẽ được render ở đây -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Tạo Phiếu Mượn -->
    <div class="modal-backdrop" id="borrowModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">Tạo phiếu mượn</h3>
                <button class="modal-close" onclick="closeBorrowModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="borrowForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mã phiếu mượn *</label>
                            <input type="text" id="maPhieuMuon" class="form-input" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nhân viên *</label>
                            <select id="maNV" class="form-select" required>
                                <option value="NV001">Admin - NV001</option>
                                <option value="NV002">Thủ thư A - NV002</option>
                                <option value="NV003">Thủ thư B - NV003</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mã sinh viên *</label>
                            <input type="text" id="maSV" class="form-input" required placeholder="Nhập mã sinh viên">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Mã sách *</label>
                            <input type="text" id="maSach" class="form-input" required placeholder="Nhập mã sách">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Ngày mượn *</label>
                            <input type="date" id="ngayMuon" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Ngày hẹn trả *</label>
                            <input type="date" id="ngayHenTra" class="form-input" required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" onclick="closeBorrowModal()">Hủy</button>
                <button class="btn btn-primary" onclick="saveBorrowSlip()">Tạo phiếu</button>
            </div>
        </div>
    </div>

    <!-- Modal Tạo Phiếu Trả -->
    <div class="modal-backdrop" id="returnModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">Tạo phiếu trả</h3>
                <button class="modal-close" onclick="closeReturnModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="returnForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mã phiếu trả *</label>
                            <input type="text" id="maPhieuTra" class="form-input" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Mã sách *</label>
                            <input type="text" id="maSachTra" class="form-input" required placeholder="Nhập mã sách để trả">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Ngày trả *</label>
                            <input type="date" id="ngayTra" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nhân viên *</label>
                            <select id="maNVTra" class="form-select" required>
                                <option value="NV001">Admin - NV001</option>
                                <option value="NV002">Thủ thư A - NV002</option>
                                <option value="NV003">Thủ thư B - NV003</option>
                            </select>
                        </div>
                    </div>
                    
                    <div id="borrowInfo" style="display: none; padding: 16px; background: var(--bg-primary); border-radius: var(--radius); margin-top: 16px;">
                        <!-- Thông tin phiếu mượn sẽ được hiển thị ở đây -->
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" onclick="closeReturnModal()">Hủy</button>
                <button class="btn btn-primary" onclick="saveReturnSlip()">Tạo phiếu</button>
            </div>
        </div>
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
    </style>

    <script>
        // Dữ liệu mẫu
        let borrowSlips = [
            {
                maPhieuMuon: 'PM2023001',
                maSV: 'SV2023001',
                maSach: 'SACH001',
                ngayMuon: '2023-09-15',
                ngayHenTra: '2023-09-29',
                trangThai: 'Đang mượn',
                maNV: 'NV001'
            },
            {
                maPhieuMuon: 'PM2023002',
                maSV: 'SV2023002',
                maSach: 'SACH002',
                ngayMuon: '2023-09-10',
                ngayHenTra: '2023-09-24',
                trangThai: 'Đã trả',
                maNV: 'NV002'
            },
            {
                maPhieuMuon: 'PM2023003',
                maSV: 'SV2023003',
                maSach: 'SACH003',
                ngayMuon: '2023-09-01',
                ngayHenTra: '2023-09-15',
                trangThai: 'Quá hạn',
                maNV: 'NV001'
            },
            {
                maPhieuMuon: 'PM2023004',
                maSV: 'SV2023001',
                maSach: 'SACH004',
                ngayMuon: '2023-09-20',
                ngayHenTra: '2023-10-04',
                trangThai: 'Đang mượn',
                maNV: 'NV003'
            }
        ];

        let returnSlips = [
            {
                maPhieuTra: 'PT2023001',
                maPhieuMuon: 'PM2023002',
                maSach: 'SACH002',
                ngayTra: '2023-09-23',
                soNgayTre: 0,
                maNV: 'NV002'
            },
            {
                maPhieuTra: 'PT2023002',
                maPhieuMuon: 'PM2023005',
                maSach: 'SACH005',
                ngayTra: '2023-09-18',
                soNgayTre: 2,
                maNV: 'NV001'
            }
        ];

        let currentTab = 'borrow';

        // Khởi tạo trang
        document.addEventListener('DOMContentLoaded', function() {
            setupDefaultDates();
            renderTables();
            setupEventListeners();
        });

        function setupEventListeners() {
            // Tìm kiếm
            document.getElementById('searchInput').addEventListener('input', filterSlips);
            
            // Lọc theo trạng thái
            document.getElementById('statusFilter').addEventListener('change', filterSlips);

            // Tự động tìm phiếu mượn khi nhập mã sách trả
            document.getElementById('maSachTra').addEventListener('input', findBorrowSlip);
        }

        function setupDefaultDates() {
            const today = new Date().toISOString().split('T')[0];
            const returnDate = new Date();
            returnDate.setDate(returnDate.getDate() + 14);
            const returnDateStr = returnDate.toISOString().split('T')[0];

            document.getElementById('ngayMuon').value = today;
            document.getElementById('ngayHenTra').value = returnDateStr;
            document.getElementById('ngayTra').value = today;
        }

        function switchTab(tab) {
            currentTab = tab;
            
            // Update tab buttons
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.getElementById(tab + 'Tab').classList.add('active');
            
            // Show/hide sections
            document.getElementById('borrowSection').style.display = tab === 'borrow' ? 'block' : 'none';
            document.getElementById('returnSection').style.display = tab === 'return' ? 'block' : 'none';
            
            filterSlips();
        }

        function renderTables() {
            renderBorrowTable();
            renderReturnTable();
        }

        function renderBorrowTable(slipsToRender = borrowSlips) {
            const tbody = document.getElementById('borrowTableBody');
            
            if (slipsToRender.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center">Không có dữ liệu</td></tr>';
                document.getElementById('totalBorrowCount').textContent = '0';
                return;
            }

            tbody.innerHTML = slipsToRender.map(slip => {
                const daysDiff = calculateDaysDifference(slip.ngayHenTra, new Date().toISOString().split('T')[0]);
                const isOverdue = daysDiff < 0 && slip.trangThai === 'Đang mượn';
                const status = isOverdue ? 'Quá hạn' : slip.trangThai;

                return `
                    <tr>
                        <td><strong>${slip.maPhieuMuon}</strong></td>
                        <td>${slip.maSV}</td>
                        <td>${slip.maSach}</td>
                        <td>${formatDate(slip.ngayMuon)}</td>
                        <td>${formatDate(slip.ngayHenTra)}</td>
                        <td>${daysDiff >= 0 ? daysDiff + ' ngày' : Math.abs(daysDiff) + ' ngày trễ'}</td>
                        <td>
                            <span class="badge ${getBadgeClass(status)}">
                                ${status}
                            </span>
                        </td>
                        <td>${slip.maNV}</td>
                        <td>
                            ${status === 'Đang mượn' || status === 'Quá hạn' ? 
                                `<button class="btn btn-success btn-sm" onclick="quickReturn('${slip.maPhieuMuon}')" title="Trả nhanh">
                                    ✅
                                </button>` : ''
                            }
                            <button class="btn btn-ghost btn-sm" onclick="viewBorrowDetails('${slip.maPhieuMuon}')" title="Chi tiết">
                                👁️
                            </button>
                            <button class="btn btn-ghost btn-sm" onclick="deleteBorrowSlip('${slip.maPhieuMuon}')" title="Xóa">
                                🗑️
                            </button>
                        </td>
                    </tr>
                `;
            }).join('');

            document.getElementById('totalBorrowCount').textContent = slipsToRender.length;
        }

        function renderReturnTable(slipsToRender = returnSlips) {
            const tbody = document.getElementById('returnTableBody');
            
            if (slipsToRender.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center">Không có dữ liệu</td></tr>';
                document.getElementById('totalReturnCount').textContent = '0';
                return;
            }

            tbody.innerHTML = slipsToRender.map(slip => `
                <tr>
                    <td><strong>${slip.maPhieuTra}</strong></td>
                    <td>${slip.maPhieuMuon}</td>
                    <td>${slip.maSach}</td>
                    <td>${formatDate(slip.ngayTra)}</td>
                    <td>
                        <span class="badge ${slip.soNgayTre > 0 ? 'badge-warning' : 'badge-success'}">
                            ${slip.soNgayTre} ngày
                        </span>
                    </td>
                    <td>${slip.maNV}</td>
                    <td>
                        <button class="btn btn-ghost btn-sm" onclick="viewReturnDetails('${slip.maPhieuTra}')" title="Chi tiết">
                            👁️
                        </button>
                        <button class="btn btn-ghost btn-sm" onclick="deleteReturnSlip('${slip.maPhieuTra}')" title="Xóa">
                            🗑️
                        </button>
                    </td>
                </tr>
            `).join('');

            document.getElementById('totalReturnCount').textContent = slipsToRender.length;
        }

        function filterSlips() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const statusFilter = document.getElementById('statusFilter').value;

    if (currentTab === 'borrow') {
        const filteredSlips = borrowSlips.filter(slip => {
            const daysDiff = calculateDaysDifference(slip.ngayHenTra, new Date().toISOString().split('T')[0]);
            const isOverdue = daysDiff < 0 && slip.trangThai === 'Đang mượn';
            const actualStatus = isOverdue ? 'Quá hạn' : slip.trangThai;

            // Chỉ tìm kiếm theo mã phiếu mượn
            const matchesSearch = slip.maPhieuMuon.toLowerCase().includes(searchTerm);
            const matchesStatus = !statusFilter || actualStatus === statusFilter;

            return matchesSearch && matchesStatus;
        });

        renderBorrowTable(filteredSlips);
    } else {
        const filteredSlips = returnSlips.filter(slip => {
            // Chỉ tìm kiếm theo mã phiếu trả
            return slip.maPhieuTra.toLowerCase().includes(searchTerm);
        });

        renderReturnTable(filteredSlips);
    }
}

        function openBorrowModal() {
            document.getElementById('maPhieuMuon').value = generateBorrowSlipId();
            document.getElementById('borrowModal').style.display = 'flex';
        }

        function openReturnModal() {
            document.getElementById('maPhieuTra').value = generateReturnSlipId();
            document.getElementById('returnModal').style.display = 'flex';
        }

        function closeBorrowModal() {
            document.getElementById('borrowModal').style.display = 'none';
            document.getElementById('borrowForm').reset();
            setupDefaultDates();
        }

        function closeReturnModal() {
            document.getElementById('returnModal').style.display = 'none';
            document.getElementById('returnForm').reset();
            document.getElementById('borrowInfo').style.display = 'none';
            setupDefaultDates();
        }

        function findBorrowSlip() {
            const maSach = document.getElementById('maSachTra').value.trim();
            if (!maSach) {
                document.getElementById('borrowInfo').style.display = 'none';
                return;
            }

            const activeBorrow = borrowSlips.find(slip => 
                slip.maSach === maSach && 
                (slip.trangThai === 'Đang mượn' || 
                 (slip.trangThai === 'Đang mượn' && calculateDaysDifference(slip.ngayHenTra, new Date().toISOString().split('T')[0]) < 0))
            );

            if (activeBorrow) {
                const daysDiff = calculateDaysDifference(activeBorrow.ngayHenTra, document.getElementById('ngayTra').value);
                const soNgayTre = Math.max(0, -daysDiff);

                document.getElementById('borrowInfo').innerHTML = `
                    <h4 style="margin-bottom: 12px; color: var(--primary);">Thông tin phiếu mượn</h4>
                    <div class="grid grid-2" style="gap: 12px;">
                        <div><strong>Mã phiếu mượn:</strong> ${activeBorrow.maPhieuMuon}</div>
                        <div><strong>Mã sinh viên:</strong> ${activeBorrow.maSV}</div>
                        <div><strong>Ngày mượn:</strong> ${formatDate(activeBorrow.ngayMuon)}</div>
                        <div><strong>Ngày hẹn trả:</strong> ${formatDate(activeBorrow.ngayHenTra)}</div>
                        <div><strong>Số ngày trễ:</strong> 
                            <span class="badge ${soNgayTre > 0 ? 'badge-warning' : 'badge-success'}">
                                ${soNgayTre} ngày
                            </span>
                        </div>
                        <div><strong>Nhân viên mượn:</strong> ${activeBorrow.maNV}</div>
                    </div>
                `;
                document.getElementById('borrowInfo').style.display = 'block';
            } else {
                document.getElementById('borrowInfo').innerHTML = `
                    <div style="text-align: center; color: var(--danger);">
                        <strong>⚠️ Không tìm thấy phiếu mượn đang hoạt động cho sách này</strong>
                    </div>
                `;
                document.getElementById('borrowInfo').style.display = 'block';
            }
        }

        function saveBorrowSlip() {
            const formData = {
                maPhieuMuon: document.getElementById('maPhieuMuon').value,
                maSV: document.getElementById('maSV').value.trim(),
                maSach: document.getElementById('maSach').value.trim(),
                ngayMuon: document.getElementById('ngayMuon').value,
                ngayHenTra: document.getElementById('ngayHenTra').value,
                maNV: document.getElementById('maNV').value,
                trangThai: 'Đang mượn'
            };

            // Validate
            if (!formData.maSV || !formData.maSach || !formData.ngayMuon || !formData.ngayHenTra) {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return;
            }

            // Check if return date is after borrow date
            if (new Date(formData.ngayHenTra) <= new Date(formData.ngayMuon)) {
                alert('Ngày hẹn trả phải sau ngày mượn!');
                return;
            }

            // Check if book is already borrowed
            const existingBorrow = borrowSlips.find(slip => 
                slip.maSach === formData.maSach && 
                (slip.trangThai === 'Đang mượn' || 
                 (slip.trangThai === 'Đang mượn' && calculateDaysDifference(slip.ngayHenTra, new Date().toISOString().split('T')[0]) < 0))
            );

            if (existingBorrow) {
                alert('Sách này đang được mượn bởi sinh viên khác!');
                return;
            }

            borrowSlips.push(formData);
            closeBorrowModal();
            renderBorrowTable();
            alert('Tạo phiếu mượn thành công!');
        }

        function saveReturnSlip() {
            const maSach = document.getElementById('maSachTra').value.trim();
            const ngayTra = document.getElementById('ngayTra').value;
            const maNV = document.getElementById('maNVTra').value;

            if (!maSach || !ngayTra || !maNV) {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return;
            }

            const activeBorrow = borrowSlips.find(slip => 
                slip.maSach === maSach && 
                (slip.trangThai === 'Đang mượn' || 
                 (slip.trangThai === 'Đang mượn' && calculateDaysDifference(slip.ngayHenTra, new Date().toISOString().split('T')[0]) < 0))
            );

            if (!activeBorrow) {
                alert('Không tìm thấy phiếu mượn đang hoạt động cho sách này!');
                return;
            }

            const daysDiff = calculateDaysDifference(activeBorrow.ngayHenTra, ngayTra);
            const soNgayTre = Math.max(0, -daysDiff);

            const returnSlip = {
                maPhieuTra: document.getElementById('maPhieuTra').value,
                maPhieuMuon: activeBorrow.maPhieuMuon,
                maSach: maSach,
                ngayTra: ngayTra,
                soNgayTre: soNgayTre,
                maNV: maNV
            };

            // Update borrow slip status
            activeBorrow.trangThai = 'Đã trả';

            returnSlips.push(returnSlip);
            closeReturnModal();
            renderTables();
            alert(`Tạo phiếu trả thành công! ${soNgayTre > 0 ? `Trễ ${soNgayTre} ngày` : 'Trả đúng hạn'}`);
        }

        function quickReturn(maPhieuMuon) {
            const borrowSlip = borrowSlips.find(slip => slip.maPhieuMuon === maPhieuMuon);
            if (!borrowSlip) return;

            if (!confirm(`Xác nhận trả sách ${borrowSlip.maSach}?`)) return;

            const today = new Date().toISOString().split('T')[0];
            const daysDiff = calculateDaysDifference(borrowSlip.ngayHenTra, today);
            const soNgayTre = Math.max(0, -daysDiff);

            const returnSlip = {
                maPhieuTra: generateReturnSlipId(),
                maPhieuMuon: maPhieuMuon,
                maSach: borrowSlip.maSach,
                ngayTra: today,
                soNgayTre: soNgayTre,
                maNV: 'NV001' // Default current user
            };

            borrowSlip.trangThai = 'Đã trả';
            returnSlips.push(returnSlip);
            renderTables();
            alert(`Trả sách thành công! ${soNgayTre > 0 ? `Trễ ${soNgayTre} ngày` : 'Trả đúng hạn'}`);
        }

        function viewBorrowDetails(maPhieuMuon) {
            const slip = borrowSlips.find(s => s.maPhieuMuon === maPhieuMuon);
            if (!slip) return;

            const daysDiff = calculateDaysDifference(slip.ngayHenTra, new Date().toISOString().split('T')[0]);
            const status = daysDiff < 0 && slip.trangThai === 'Đang mượn' ? 'Quá hạn' : slip.trangThai;

            alert(`Chi tiết phiếu mượn:
Mã phiếu: ${slip.maPhieuMuon}
Mã sinh viên: ${slip.maSV}
Mã sách: ${slip.maSach}
Ngày mượn: ${formatDate(slip.ngayMuon)}
Ngày hẹn trả: ${formatDate(slip.ngayHenTra)}
Trạng thái: ${status}
Nhân viên: ${slip.maNV}
${daysDiff < 0 ? `Số ngày trễ: ${Math.abs(daysDiff)}` : `Còn lại: ${daysDiff} ngày`}`);
        }

        function viewReturnDetails(maPhieuTra) {
            const slip = returnSlips.find(s => s.maPhieuTra === maPhieuTra);
            if (!slip) return;

            alert(`Chi tiết phiếu trả:
Mã phiếu trả: ${slip.maPhieuTra}
Mã phiếu mượn: ${slip.maPhieuMuon}
Mã sách: ${slip.maSach}
Ngày trả: ${formatDate(slip.ngayTra)}
Số ngày trễ: ${slip.soNgayTre}
Nhân viên: ${slip.maNV}`);
        }

        function deleteBorrowSlip(maPhieuMuon) {
            if (!confirm('Bạn có chắc chắn muốn xóa phiếu mượn này?')) return;

            const index = borrowSlips.findIndex(s => s.maPhieuMuon === maPhieuMuon);
            if (index !== -1) {
                borrowSlips.splice(index, 1);
                renderBorrowTable();
                alert('Đã xóa phiếu mượn thành công!');
            }
        }

        function deleteReturnSlip(maPhieuTra) {
            if (!confirm('Bạn có chắc chắn muốn xóa phiếu trả này?')) return;

            const index = returnSlips.findIndex(s => s.maPhieuTra === maPhieuTra);
            if (index !== -1) {
                returnSlips.splice(index, 1);
                renderReturnTable();
                alert('Đã xóa phiếu trả thành công!');
            }
        }

        // Utility functions
        function generateBorrowSlipId() {
            const year = new Date().getFullYear();
            const existingIds = borrowSlips.map(s => s.maPhieuMuon);
            let counter = 1;
            let newId;
            
            do {
                newId = `PM${year}${String(counter).padStart(3, '0')}`;
                counter++;
            } while (existingIds.includes(newId));
            
            return newId;
        }

        function generateReturnSlipId() {
            const year = new Date().getFullYear();
            const existingIds = returnSlips.map(s => s.maPhieuTra);
            let counter = 1;
            let newId;
            
            do {
                newId = `PT${year}${String(counter).padStart(3, '0')}`;
                counter++;
            } while (existingIds.includes(newId));
            
            return newId;
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        function calculateDaysDifference(date1, date2) {
            const d1 = new Date(date1);
            const d2 = new Date(date2);
            const diffTime = d1 - d2;
            return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        }

        function getBadgeClass(status) {
            switch(status) {
                case 'Đang mượn': return 'badge-info';
                case 'Đã trả': return 'badge-success';
                case 'Quá hạn': return 'badge-danger';
                default: return 'badge-secondary';
            }
        }

        function exportBorrowToCSV() {
            const headers = ['Mã phiếu', 'Mã SV', 'Mã sách', 'Ngày mượn', 'Ngày hẹn trả', 'Trạng thái', 'Nhân viên'];
            const csvContent = [
                headers.join(','),
                ...borrowSlips.map(slip => [
                    slip.maPhieuMuon,
                    slip.maSV,
                    slip.maSach,
                    slip.ngayMuon,
                    slip.ngayHenTra,
                    slip.trangThai,
                    slip.maNV
                ].join(','))
            ].join('\n');

            downloadCSV(csvContent, 'danh_sach_phieu_muon.csv');
        }

        function exportReturnToCSV() {
            const headers = ['Mã phiếu trả', 'Mã phiếu mượn', 'Mã sách', 'Ngày trả', 'Số ngày trễ', 'Nhân viên'];
            const csvContent = [
                headers.join(','),
                ...returnSlips.map(slip => [
                    slip.maPhieuTra,
                    slip.maPhieuMuon,
                    slip.maSach,
                    slip.ngayTra,
                    slip.soNgayTre,
                    slip.maNV
                ].join(','))
            ].join('\n');

            downloadCSV(csvContent, 'danh_sach_phieu_tra.csv');
        }

        function downloadCSV(csvContent, filename) {
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', filename);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        // Close modals when clicking outside
        document.getElementById('borrowModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeBorrowModal();
            }
        });

        document.getElementById('returnModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeReturnModal();
            }
        });
    </script>
</body>
</html>