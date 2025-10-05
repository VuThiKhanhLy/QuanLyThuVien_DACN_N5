<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sinh viên - Thư viện</title>
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
                <a href="QuanLySach.jsp" class="nav-link">
                    <span class="nav-icon">📖</span>
                    Quản lý Sách
                </a>
                <a href="QuanLySinhVien.html" class="nav-link active">
                    <span class="nav-icon">🎓</span>
                    Quản lý Sinh viên
                </a>
                <a href="QuanLyPhieu.jsp" class="nav-link">
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
                    <h1>Quản lý Sinh viên</h1>
                    <p>Thông tin thẻ thư viện và quản lý sinh viên</p>
                </div>
                <div class="header-right">
                    <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm sinh viên...">
                    <button class="btn btn-primary" onclick="openAddStudentModal()">
                        <span>➕</span>
                        Thêm sinh viên
                    </button>
                </div>
            </div>

            <!-- Students Table -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <h3 class="card-title">Danh sách sinh viên</h3>
                        <p class="card-subtitle">Tổng cộng: <span id="totalStudentsCount">0</span> sinh viên</p>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <select id="statusFilter" class="form-select" style="width: 150px;">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Đang hoạt động">Đang hoạt động</option>
                            <option value="Đã hết hạn">Đã hết hạn</option>
                        </select>
                        <button class="btn btn-outline" onclick="exportToCSV()">
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
                                    <th>Mã SV</th>
                                    <th>Họ tên</th>
                                    <th>Ngày sinh</th>
                                    <th>Giới tính</th>
                                    <th>Điện thoại</th>
                                    <th>Email</th>
                                    <th>Địa chỉ</th>
                                    <th>Ngày đăng ký</th>
                                    <th>Ngày hết hạn</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="studentsTableBody">
                                <!-- Dữ liệu sinh viên sẽ được render ở đây -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Thêm/Sửa Sinh viên -->
    <div class="modal-backdrop" id="studentModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Thêm sinh viên mới</h3>
                <button class="modal-close" onclick="closeStudentModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="studentForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mã sinh viên *</label>
                            <input type="text" id="maSV" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giới tính</label>
                            <select id="gioiTinh" class="form-select">
                                <option value="">Chọn giới tính</option>
                                <option value="Nam">Nam</option>
                                <option value="Nữ">Nữ</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Họ và tên *</label>
                        <input type="text" id="hoTen" class="form-input" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Ngày sinh *</label>
                            <input type="date" id="ngaySinh" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại *</label>
                            <input type="tel" id="dienThoai" class="form-input" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" id="email" class="form-input">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Địa chỉ *</label>
                        <textarea id="diaChi" class="form-textarea" rows="2" placeholder="Địa chỉ liên hệ..." required></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ngày đăng ký thẻ *</label>
                        <input type="date" id="ngayDangKy" class="form-input" required>
                        <small style="color: var(--text-secondary);">Thẻ có hiệu lực 4 năm từ ngày đăng ký</small>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" onclick="closeStudentModal()">Hủy</button>
                <button class="btn btn-primary" onclick="saveStudent()">Lưu</button>
            </div>
        </div>
    </div>
    

    <script>
        // Dữ liệu mẫu sinh viên
        let students = [
            {
                maSV: 'SV2023001',
                tenSV: 'Nguyễn Văn An',
                ngaySinh: '2003-05-15',
                gioiTinh: 'Nam',
                dienThoai: '0912345678',
                email: 'anvn@email.com',
                diaChi: '123 Đường ABC, Quận 1, TP.HCM',
                ngayDangKy: '2023-09-01'
            },
            {
                maSV: 'SV2023002',
                tenSV: 'Trần Thị Bình',
                ngaySinh: '2003-08-22',
                gioiTinh: 'Nữ',
                dienThoai: '0987654321',
                email: 'binhtt@email.com',
                diaChi: '456 Đường XYZ, Quận 2, TP.HCM',
                ngayDangKy: '2023-09-02'
            },
            {
                maSV: 'SV2023003',
                tenSV: 'Lê Văn Cường',
                ngaySinh: '2003-12-10',
                gioiTinh: 'Nam',
                dienThoai: '0901234567',
                email: 'cuonglv@email.com',
                diaChi: '789 Đường DEF, Quận 3, TP.HCM',
                ngayDangKy: '2023-09-03'
            },
            {
                maSV: 'SV2023004',
                tenSV: 'Phạm Thị Dung',
                ngaySinh: '2003-03-18',
                gioiTinh: 'Nữ',
                dienThoai: '0976543210',
                email: 'dungpt@email.com',
                diaChi: '321 Đường GHI, Quận 4, TP.HCM',
                ngayDangKy: '2020-09-04' // Thẻ đã hết hạn
            },
            {
                maSV: 'SV2023005',
                tenSV: 'Hoàng Văn Em',
                ngaySinh: '2003-07-25',
                gioiTinh: 'Nam',
                dienThoai: '0965432109',
                email: 'emhv@email.com',
                diaChi: '654 Đường JKL, Quận 5, TP.HCM',
                ngayDangKy: '2019-09-05' // Thẻ đã hết hạn
            }
        ];

        let currentEditId = null;
        let currentDetailStudent = null;

        // Khởi tạo trang
        document.addEventListener('DOMContentLoaded', function() {
            setupDefaultDates();
            renderStudentsTable();
            setupEventListeners();
        });

        function setupEventListeners() {
            // Tìm kiếm
            document.getElementById('searchInput').addEventListener('input', filterStudents);
            
            // Lọc theo trạng thái
            document.getElementById('statusFilter').addEventListener('change', filterStudents);
        }

        function setupDefaultDates() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('ngayDangKy').value = today;
        }

        // Tính ngày hết hạn thẻ (4 năm từ ngày đăng ký)
        function calculateExpiryDate(registrationDate) {
            const regDate = new Date(registrationDate);
            const expiryDate = new Date(regDate);
            expiryDate.setFullYear(regDate.getFullYear() + 4);
            return expiryDate.toISOString().split('T')[0];
        }

        // Kiểm tra trạng thái thẻ
        function getCardStatus(registrationDate) {
            const today = new Date();
            const expiryDate = new Date(calculateExpiryDate(registrationDate));
            
            return today > expiryDate ? 'Đã hết hạn' : 'Đang hoạt động';
        }

        // Tính số ngày còn lại hoặc quá hạn
        function getDaysUntilExpiry(registrationDate) {
            const today = new Date();
            const expiryDate = new Date(calculateExpiryDate(registrationDate));
            const diffTime = expiryDate - today;
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            return diffDays;
        }

        function renderStudentsTable(studentsToRender = students) {
            const tbody = document.getElementById('studentsTableBody');
            
            if (studentsToRender.length === 0) {
                tbody.innerHTML = '<tr><td colspan="11" class="text-center">Không có dữ liệu</td></tr>';
                document.getElementById('totalStudentsCount').textContent = '0';
                return;
            }

            tbody.innerHTML = studentsToRender.map(student => {
                const expiryDate = calculateExpiryDate(student.ngayDangKy);
                const status = getCardStatus(student.ngayDangKy);
                const daysUntilExpiry = getDaysUntilExpiry(student.ngayDangKy);
                
                return `
                    <tr>
                        <td><strong>${student.maSV}</strong></td>
                        <td>${student.tenSV}</td>
                        <td>${formatDate(student.ngaySinh)}</td>
                        <td>${student.gioiTinh || 'N/A'}</td>
                        <td>${student.dienThoai}</td>
                        <td>${student.email || 'N/A'}</td>
                        <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${student.diaChi}">
                            ${student.diaChi}
                        </td>
                        <td>${formatDate(student.ngayDangKy)}</td>
                        <td>${formatDate(expiryDate)}</td>
                        <td>
                            <span class="badge ${status === 'Đang hoạt động' ? 'badge-success' : 'badge-danger'}">
                                ${status}
                            </span>
                            ${status === 'Đang hoạt động' && daysUntilExpiry <= 30 ? 
                                `<br><small style="color: var(--warning);">Còn ${daysUntilExpiry} ngày</small>` : ''
                        }
                    </td>
                    <td>
                        <div style="display: flex; gap: 4px; align-items: center; justify-content: center;">
                            <button class="btn btn-ghost btn-sm" onclick="editStudent('${student.maSV}')" title="Sửa">
                                ✏️
                            </button>
                            <button class="btn btn-ghost btn-sm" onclick="deleteStudent('${student.maSV}')" title="Xóa">
                                🗑️
                            </button>
                        </div>
                    </td>
                </tr>
            `;
            }).join('');

            document.getElementById('totalStudentsCount').textContent = studentsToRender.length;
        }

        function filterStudents() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;

            const filteredStudents = students.filter(student => {
                const status = getCardStatus(student.ngayDangKy);
                
                const matchesSearch = student.tenSV.toLowerCase().includes(searchTerm) ||
                                    student.maSV.toLowerCase().includes(searchTerm) ||
                                    student.dienThoai.includes(searchTerm) ||
                                    (student.email && student.email.toLowerCase().includes(searchTerm)) ||
                                    student.diaChi.toLowerCase().includes(searchTerm);
                
                const matchesStatus = !statusFilter || status === statusFilter;

                return matchesSearch && matchesStatus;
            });

            renderStudentsTable(filteredStudents);
        }

        function openAddStudentModal() {
            currentEditId = null;
            document.getElementById('modalTitle').textContent = 'Thêm sinh viên mới';
            clearStudentForm();
            // Generate new student ID
            const newId = generateStudentId();
            document.getElementById('maSV').value = newId;
            setupDefaultDates();
            document.getElementById('studentModal').style.display = 'flex';
        }

        function editStudent(maSV) {
            const student = students.find(s => s.maSV === maSV);
            if (!student) return;

            currentEditId = maSV;
            document.getElementById('modalTitle').textContent = 'Chỉnh sửa thông tin sinh viên';
            
            // Fill form with student data
            document.getElementById('maSV').value = student.maSV;
            document.getElementById('hoTen').value = student.tenSV;
            document.getElementById('ngaySinh').value = student.ngaySinh;
            document.getElementById('gioiTinh').value = student.gioiTinh || '';
            document.getElementById('dienThoai').value = student.dienThoai;
            document.getElementById('email').value = student.email || '';
            document.getElementById('diaChi').value = student.diaChi;
            document.getElementById('ngayDangKy').value = student.ngayDangKy;

            document.getElementById('studentModal').style.display = 'flex';
        }

        function deleteStudent(maSV) {
            if (!confirm('Bạn có chắc chắn muốn xóa sinh viên này?')) return;

            const index = students.findIndex(s => s.maSV === maSV);
            if (index !== -1) {
                students.splice(index, 1);
                renderStudentsTable();
                alert('Đã xóa sinh viên thành công!');
            }
        }

        function viewStudentDetails(maSV) {
            const student = students.find(s => s.maSV === maSV);
            if (!student) return;

            currentDetailStudent = student;
            const expiryDate = calculateExpiryDate(student.ngayDangKy);
            const status = getCardStatus(student.ngayDangKy);
            const daysUntilExpiry = getDaysUntilExpiry(student.ngayDangKy);

            const detailsHtml = `
                <div class="grid grid-2" style="gap: 16px;">
                    <div>
                        <h4 style="margin-bottom: 16px; color: var(--primary);">Thông tin cá nhân</h4>
                        <div class="form-group">
                            <strong>Mã sinh viên:</strong> ${student.maSV}
                        </div>
                        <div class="form-group">
                            <strong>Họ và tên:</strong> ${student.tenSV}
                        </div>
                        <div class="form-group">
                            <strong>Ngày sinh:</strong> ${formatDate(student.ngaySinh)}
                        </div>
                        <div class="form-group">
                            <strong>Giới tính:</strong> ${student.gioiTinh || 'Chưa cập nhật'}
                        </div>
                        <div class="form-group">
                            <strong>Số điện thoại:</strong> ${student.dienThoai}
                        </div>
                        <div class="form-group">
                            <strong>Email:</strong> ${student.email || 'Chưa cập nhật'}
                        </div>
                    </div>
                    <div>
                        <h4 style="margin-bottom: 16px; color: var(--primary);">Thông tin thẻ thư viện</h4>
                        <div class="form-group">
                            <strong>Ngày đăng ký:</strong> ${formatDate(student.ngayDangKy)}
                        </div>
                        <div class="form-group">
                            <strong>Ngày hết hạn:</strong> ${formatDate(expiryDate)}
                        </div>
                        <div class="form-group">
                            <strong>Trạng thái:</strong> 
                            <span class="badge ${status === 'Đang hoạt động' ? 'badge-success' : 'badge-danger'}">
                                ${status}
                            </span>
                        </div>
                        ${status === 'Đang hoạt động' ? 
                            `<div class="form-group">
                                <strong>Thời gian còn lại:</strong> 
                                <span style="color: ${daysUntilExpiry <= 30 ? 'var(--warning)' : 'var(--success)'};">
                                    ${daysUntilExpiry} ngày
                                </span>
                            </div>` : 
                            `<div class="form-group">
                                <strong>Đã hết hạn:</strong> 
                                <span style="color: var(--danger);">
                                    ${Math.abs(daysUntilExpiry)} ngày trước
                                </span>
                            </div>`
                        }
                        <div class="form-group">
                            <strong>Địa chỉ:</strong> ${student.diaChi}
                        </div>
                    </div>
                </div>
            `;

            document.getElementById('studentDetails').innerHTML = detailsHtml;
            
            // Show/hide renew card button
            const renewBtn = document.getElementById('renewCardBtn');
            if (status === 'Đã hết hạn') {
                renewBtn.style.display = 'inline-flex';
            } else {
                renewBtn.style.display = 'none';
            }

            document.getElementById('detailModal').style.display = 'flex';
        }

        function saveStudent() {
            const formData = {
                maSV: document.getElementById('maSV').value.trim(),
                tenSV: document.getElementById('hoTen').value.trim(),
                ngaySinh: document.getElementById('ngaySinh').value,
                gioiTinh: document.getElementById('gioiTinh').value,
                dienThoai: document.getElementById('dienThoai').value.trim(),
                email: document.getElementById('email').value.trim(),
                diaChi: document.getElementById('diaChi').value.trim(),
                ngayDangKy: document.getElementById('ngayDangKy').value
            };

            // Validate required fields
            if (!formData.maSV || !formData.tenSV || !formData.ngaySinh || !formData.dienThoai || !formData.diaChi || !formData.ngayDangKy) {
                alert('Vui lòng điền đầy đủ các trường bắt buộc (*)');
                return;
            }

            // Validate phone number
            if (!isValidPhoneNumber(formData.dienThoai)) {
                alert('Số điện thoại không hợp lệ');
                return;
            }

            // Validate email if provided
            if (formData.email && !isValidEmail(formData.email)) {
                alert('Email không hợp lệ');
                return;
            }

            // Validate birth date (must be at least 16 years old)
            const birthDate = new Date(formData.ngaySinh);
            const today = new Date();
            const age = today.getFullYear() - birthDate.getFullYear();
            if (age < 16) {
                alert('Sinh viên phải từ 16 tuổi trở lên');
                return;
            }

            // Check if student ID already exists (when adding new)
            if (!currentEditId && students.some(s => s.maSV === formData.maSV)) {
                alert('Mã sinh viên đã tồn tại. Vui lòng chọn mã khác.');
                return;
            }

            if (currentEditId) {
                // Update existing student
                const index = students.findIndex(s => s.maSV === currentEditId);
                if (index !== -1) {
                    students[index] = formData;
                    alert('Cập nhật thông tin sinh viên thành công!');
                }
            } else {
                // Add new student
                students.push(formData);
                alert('Thêm sinh viên mới thành công!');
            }

            closeStudentModal();
            renderStudentsTable();
        }

        function quickRenewCard(maSV) {
            if (!confirm('Gia hạn thẻ thư viện cho sinh viên này thêm 4 năm?')) return;

            const student = students.find(s => s.maSV === maSV);
            if (student) {
                const today = new Date().toISOString().split('T')[0];
                student.ngayDangKy = today;
                renderStudentsTable();
                alert('Gia hạn thẻ thành công! Thẻ có hiệu lực đến ' + formatDate(calculateExpiryDate(today)));
            }
        }

        function renewCard() {
            if (currentDetailStudent) {
                quickRenewCard(currentDetailStudent.maSV);
                closeDetailModal();
            }
        }

        function closeStudentModal() {
            document.getElementById('studentModal').style.display = 'none';
            clearStudentForm();
        }

        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
            currentDetailStudent = null;
        }

        function clearStudentForm() {
            document.getElementById('studentForm').reset();
        }

        function generateStudentId() {
            const currentYear = new Date().getFullYear();
            const existingIds = students.map(s => s.maSV);
            let counter = 1;
            let newId;
            
            do {
                newId = `SV${currentYear}${String(counter).padStart(3, '0')}`;
                counter++;
            } while (existingIds.includes(newId));
            
            return newId;
        }

        function formatDate(dateString) {
            if (!dateString) return 'N/A';
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        function isValidPhoneNumber(phone) {
            const phoneRegex = /^[0-9]{10,11}$/;
            return phoneRegex.test(phone);
        }

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function exportToCSV() {
            const headers = ['Mã SV', 'Họ tên', 'Ngày sinh', 'Giới tính', 'Điện thoại', 'Email', 'Địa chỉ', 'Ngày đăng ký', 'Ngày hết hạn', 'Trạng thái'];
            const csvContent = [
                headers.join(','),
                ...students.map(student => {
                    const expiryDate = calculateExpiryDate(student.ngayDangKy);
                    const status = getCardStatus(student.ngayDangKy);
                    
                    return [
                        student.maSV,
                        `"${student.tenSV}"`,
                        student.ngaySinh,
                        student.gioiTinh || '',
                        student.dienThoai,
                        student.email || '',
                        `"${student.diaChi}"`,
                        student.ngayDangKy,
                        expiryDate,
                        status
                    ].join(',');
                })
            ].join('\n');

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', `danh_sach_sinh_vien_${new Date().toISOString().split('T')[0]}.csv`);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        // Close modals when clicking outside
        document.getElementById('studentModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeStudentModal();
            }
        });

        document.getElementById('detailModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeDetailModal();
            }
        });

        // Auto-check for expiring cards on page load
        function checkExpiringCards() {
            const expiringStudents = students.filter(student => {
                const status = getCardStatus(student.ngayDangKy);
                const daysUntilExpiry = getDaysUntilExpiry(student.ngayDangKy);
                return status === 'Đang hoạt động' && daysUntilExpiry <= 30;
            });

            if (expiringStudents.length > 0) {
                const message = `Có ${expiringStudents.length} thẻ thư viện sắp hết hạn trong 30 ngày tới:\n\n` +
                    expiringStudents.map(s => `- ${s.tenSV} (${s.maSV}): còn ${getDaysUntilExpiry(s.ngayDangKy)} ngày`).join('\n');
                
                setTimeout(() => {
                    if (confirm(message + '\n\nBạn có muốn xem danh sách chi tiết không?')) {
                        document.getElementById('statusFilter').value = 'Đang hoạt động';
                        filterStudents();
                    }
                }, 1000);
            }
        }

        // Initialize page with expiry check
        window.addEventListener('load', function() {
            checkExpiringCards();
        });
    </script>
</body>
</html>