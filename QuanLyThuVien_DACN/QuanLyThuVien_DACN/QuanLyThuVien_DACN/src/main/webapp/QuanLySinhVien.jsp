<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%-- BẮT BUỘC PHẢI CÓ THẺ NÀY --%>
<%@ page import="com.quanlythuvien.model.TaiKhoan" %>
<%
    // ========================== 1. BẢO VỆ TRANG VÀ KHAI BÁO BIẾN ==========================

    // Lấy đối tượng TaiKhoan từ Session
    TaiKhoan currentAccount = (TaiKhoan) session.getAttribute("loggedInAccount");

    // Kiểm tra: Nếu không có tài khoản HOẶC không phải là vai trò được phép, chuyển hướng
    // Dùng "Nhân viên" như bạn đã định nghĩa
    if (currentAccount == null || !"Nhân viên".equalsIgnoreCase(currentAccount.getVaiTro())) {
        response.sendRedirect(request.getContextPath() + "/Signinforadmin.jsp");
        return;
    }

    // Đặt đối tượng TaiKhoan vào request scope để có thể dùng EL ${userAccount.tenDangNhap}
    if (request.getAttribute("userAccount") == null) {
        request.setAttribute("userAccount", currentAccount);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sinh viên - Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Anh/logo.png" sizes="512x512">
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
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <span class="nav-icon">🏠</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/BookServlet" class="nav-link">
                <span class="nav-icon">📖</span> Quản lý Sách
            </a>
            <a href="${pageContext.request.contextPath}/StudentServlet" class="nav-link active">
                <span class="nav-icon">🎓</span> Quản lý Sinh viên
            </a>
            <a href="${pageContext.request.contextPath}/BorrowSlipServlet" class="nav-link">
                <span class="nav-icon">📋</span> Quản lý Phiếu
            </a>
            <a href="${pageContext.request.contextPath}/ReportServlet" class="nav-link">
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

        <div style="margin-top: auto;
                    text-align: center; opacity: 0.8; font-size: 12px;">
            Người dùng: <strong style="font-size: 14px;">${userAccount.tenDangNhap}</strong> (${userAccount.vaiTro})
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
                        <tr><td colspan="11" class="text-center">Đang tải dữ liệu...</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal-backdrop" id="studentModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title" id="modalTitle">Thêm sinh viên mới</h3>
            <button class="modal-close" onclick="closeStudentModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="studentForm">
                <input type="hidden" id="maSV">

                <div class="form-group">
                    <label class="form-label">Họ và tên *</label>
                    <input type="text" id="tenSV" class="form-input" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Ngày sinh *</label>
                        <input type="date" id="ngaySinh" class="form-input" required>
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

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Số điện thoại *</label>
                        <input type="tel" id="soDienThoai" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" id="email" class="form-input">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Địa chỉ *</label>
                    <textarea id="diaChi" class="form-textarea" rows="2" placeholder="Địa chỉ liên hệ..." required></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Ngày đăng ký thẻ *</label>
                    <input type="date" id="ngayDKThe" class="form-input" required>
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

<script type="text/javascript">
    var students = [];
    var currentEditId = null;

    document.addEventListener('DOMContentLoaded', function() {
        setupDefaultDates();
        loadAllStudents();
        setupEventListeners();
    });

    function setupEventListeners() {
        var searchTimeout;
        document.getElementById('searchInput').addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(function() {
                var keyword = document.getElementById('searchInput').value.trim();
                if (keyword) {
                    searchStudents(keyword);
                } else {
                    loadAllStudents();
                }
            }, 500);
        });

        document.getElementById('statusFilter').addEventListener('change', function() {
            var status = this.value;
            if (status) {
                filterByStatus(status);
            } else {
                loadAllStudents();
            }
        });
    }

    function setupDefaultDates() {
        var today = new Date().toISOString().split('T')[0];
        document.getElementById('ngayDKThe').value = today;
    }

    function loadAllStudents() {
        fetch('StudentServlet?action=getAll')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                students = data;
                renderStudentsTable(students);
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Không thể tải danh sách sinh viên');
            });
    }

    function searchStudents(keyword) {
        fetch('StudentServlet?action=search&keyword=' + encodeURIComponent(keyword))
            .then(function(response) { return response.json(); })
            .then(function(data) {
                renderStudentsTable(data);
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Lỗi khi tìm kiếm');
            });
    }

    function filterByStatus(status) {
        fetch('StudentServlet?action=filterByStatus&status=' + encodeURIComponent(status))
            .then(function(response) { return response.json(); })
            .then(function(data) {
                renderStudentsTable(data);
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Lỗi khi lọc dữ liệu');
            });
    }

    function getCardStatus(ngayHHThe) {
        var today = new Date();
        var expiryDate = new Date(ngayHHThe);
        return today > expiryDate ? 'Đã hết hạn' : 'Đang hoạt động';
    }

    function getDaysUntilExpiry(ngayHHThe) {
        var today = new Date();
        var expiryDate = new Date(ngayHHThe);
        var diffTime = expiryDate - today;
        var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays;
    }

    function renderStudentsTable(studentsToRender) {
        var tbody = document.getElementById('studentsTableBody');

        if (!studentsToRender || studentsToRender.length === 0) {
            tbody.innerHTML = '<tr><td colspan="11" class="text-center">Không có dữ liệu</td></tr>';
            document.getElementById('totalStudentsCount').textContent = '0';
            return;
        }

        var html = '';
        for (var i = 0; i < studentsToRender.length; i++) {
            var student = studentsToRender[i];
            var status = getCardStatus(student.ngayHHThe);
            var daysUntilExpiry = getDaysUntilExpiry(student.ngayHHThe);
            var badgeClass = status === 'Đang hoạt động' ? 'badge-success' : 'badge-danger';

            html += '<tr>';
            html += '<td><strong>' + student.maSV + '</strong></td>';
            html += '<td>' + student.tenSV + '</td>';
            html += '<td>' + formatDate(student.ngaySinh) + '</td>';
            html += '<td>' + (student.gioiTinh || 'N/A') + '</td>';
            html += '<td>' + student.soDienThoai + '</td>';
            html += '<td>' + (student.email || 'N/A') + '</td>';
            html += '<td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="' + student.diaChi + '">';
            html += student.diaChi + '</td>';
            html += '<td>' + formatDate(student.ngayDKThe) + '</td>';
            html += '<td>' + formatDate(student.ngayHHThe) + '</td>';
            html += '<td>';
            html += '<span class="badge ' + badgeClass + '">' + status + '</span>';
            if (status === 'Đang hoạt động' && daysUntilExpiry <= 30) {
                html += '<br><small style="color: var(--warning);">Còn ' + daysUntilExpiry + ' ngày</small>';
            }
            html += '</td>';
            html += '<td>';
            html += '<div style="display: flex; gap: 4px; align-items: center; justify-content: center;">';
            if (status === 'Đã hết hạn') {
                html += '<button class="btn btn-ghost btn-sm" onclick="renewCard(' + student.maSV + ')" title="Gia hạn">🔄</button>';
            }
            html += '<button class="btn btn-ghost btn-sm" onclick="editStudent(' + student.maSV + ')" title="Sửa">✏️</button>';
            html += '<button class="btn btn-ghost btn-sm" onclick="deleteStudent(' + student.maSV + ')" title="Xóa">🗑️</button>';
            html += '</div>';
            html += '</td>';
            html += '</tr>';
        }

        tbody.innerHTML = html;
        document.getElementById('totalStudentsCount').textContent = studentsToRender.length;
    }

    function openAddStudentModal() {
        currentEditId = null;
        document.getElementById('modalTitle').textContent = 'Thêm sinh viên mới';
        clearStudentForm();
        setupDefaultDates();
        document.getElementById('studentModal').style.display = 'flex';
    }

    function editStudent(maSV) {
        fetch('StudentServlet?action=getById&maSV=' + maSV)
            .then(function(response) { return response.json(); })
            .then(function(student) {
                if (!student) {
                    showError('Không tìm thấy sinh viên');
                    return;
                }

                currentEditId = maSV;
                document.getElementById('modalTitle').textContent = 'Chỉnh sửa thông tin sinh viên';

                document.getElementById('maSV').value = student.maSV;
                document.getElementById('tenSV').value = student.tenSV;
                document.getElementById('ngaySinh').value = student.ngaySinh;
                document.getElementById('gioiTinh').value = student.gioiTinh || '';
                document.getElementById('soDienThoai').value = student.soDienThoai;
                document.getElementById('email').value = student.email || '';
                document.getElementById('diaChi').value = student.diaChi;
                document.getElementById('ngayDKThe').value = student.ngayDKThe;

                document.getElementById('studentModal').style.display = 'flex';
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Lỗi khi tải thông tin sinh viên');
            });
    }

    function deleteStudent(maSV) {
        if (!confirm('Bạn có chắc chắn muốn xóa sinh viên này?')) return;

        fetch('StudentServlet?action=delete&maSV=' + maSV, {
            method: 'DELETE'
        })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    alert('Đã xóa sinh viên thành công!');
                    loadAllStudents();
                } else {
                    showError('Không thể xóa sinh viên');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Lỗi khi xóa sinh viên');
            });
    }

    function renewCard(maSV) {
        if (!confirm('Gia hạn thẻ thư viện cho sinh viên này thêm 4 năm?')) return;

        fetch('StudentServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=renewCard&maSV=' + maSV
        })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    alert('Gia hạn thẻ thành công! Thẻ có hiệu lực đến ' + formatDate(data.ngayHH));
                    loadAllStudents();
                } else {
                    showError('Không thể gia hạn thẻ');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Lỗi khi gia hạn thẻ');
            });
    }

    function saveStudent() {
        var formData = {
            tenSV: document.getElementById('tenSV').value.trim(),
            ngaySinh: document.getElementById('ngaySinh').value,
            gioiTinh: document.getElementById('gioiTinh').value,
            soDienThoai: document.getElementById('soDienThoai').value.trim(),
            email: document.getElementById('email').value.trim(),
            diaChi: document.getElementById('diaChi').value.trim(),
            ngayDKThe: document.getElementById('ngayDKThe').value
        };

        if (!formData.tenSV || !formData.ngaySinh || !formData.soDienThoai || !formData.diaChi || !formData.ngayDKThe) {
            alert('Vui lòng điền đầy đủ các trường bắt buộc (*)');
            return;
        }

        if (!isValidPhoneNumber(formData.soDienThoai)) {
            alert('Số điện thoại không hợp lệ');
            return;
        }

        if (formData.email && !isValidEmail(formData.email)) {
            alert('Email không hợp lệ');
            return;
        }

        var birthDate = new Date(formData.ngaySinh);
        var today = new Date();
        var age = today.getFullYear() - birthDate.getFullYear();
        if (age < 16) {
            alert('Sinh viên phải từ 16 tuổi trở lên');
            return;
        }

        var action = currentEditId ? 'update' : 'add';
        var params = 'action=' + action;

        for (var key in formData) {
            params += '&' + key + '=' + encodeURIComponent(formData[key]);
        }

        if (currentEditId) {
            params += '&maSV=' + currentEditId;
        }

        fetch('StudentServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    alert(currentEditId ? 'Cập nhật thông tin sinh viên thành công!' : 'Thêm sinh viên mới thành công!');
                    closeStudentModal();
                    loadAllStudents();
                } else {
                    showError('Không thể lưu thông tin sinh viên');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showError('Lỗi khi lưu thông tin sinh viên');
            });
    }

    function closeStudentModal() {
        document.getElementById('studentModal').style.display = 'none';
        clearStudentForm();
    }

    function clearStudentForm() {
        document.getElementById('studentForm').reset();
        currentEditId = null;
    }

    function formatDate(dateString) {
        if (!dateString) return 'N/A';
        var date = new Date(dateString);
        return date.toLocaleDateString('vi-VN');
    }

    function isValidPhoneNumber(phone) {
        var phoneRegex = /^[0-9]{10,11}$/;
        return phoneRegex.test(phone);
    }

    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function showError(message) {
        alert(message);
    }

    function exportToCSV() {
        if (students.length === 0) {
            alert('Không có dữ liệu để xuất');
            return;
        }

        var headers = ['Mã SV', 'Họ tên', 'Ngày sinh', 'Giới tính', 'Điện thoại', 'Email', 'Địa chỉ', 'Ngày đăng ký', 'Ngày hết hạn', 'Trạng thái'];
        var csvContent = headers.join(',') + '\n';

        for (var i = 0; i < students.length; i++) {
            var student = students[i];
            var status = getCardStatus(student.ngayHHThe);
            var row = [
                student.maSV,
                '"' + student.tenSV + '"',
                student.ngaySinh,
                student.gioiTinh || '',
                student.soDienThoai,
                student.email || '',
                '"' + student.diaChi + '"',
                student.ngayDKThe,
                student.ngayHHThe,
                status
            ];
            csvContent += row.join(',') + '\n';
        }

        var blob = new Blob(['\uFEFF' + csvContent], { type: 'text/csv;charset=utf-8;' });
        var link = document.createElement('a');
        var url = URL.createObjectURL(blob);
        link.setAttribute('href', url);
        link.setAttribute('download', 'danh_sach_sinh_vien_' + new Date().toISOString().split('T')[0] + '.csv');
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    document.getElementById('studentModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeStudentModal();
        }
    });

    function checkExpiringCards() {
        var expiringStudents = [];
        for (var i = 0; i < students.length; i++) {
            var student = students[i];
            var status = getCardStatus(student.ngayHHThe);
            var daysUntilExpiry = getDaysUntilExpiry(student.ngayHHThe);
            if (status === 'Đang hoạt động' && daysUntilExpiry <= 30) {
                expiringStudents.push(student);
            }
        }

        if (expiringStudents.length > 0) {
            var message = 'Có ' + expiringStudents.length + ' thẻ thư viện sắp hết hạn trong 30 ngày tới:\n\n';
            for (var i = 0; i < expiringStudents.length; i++) {
                var s = expiringStudents[i];
                message += '- ' + s.tenSV + ' (' + s.maSV + '): còn ' + getDaysUntilExpiry(s.ngayHHThe) + ' ngày\n';
            }

            setTimeout(function() {
                if (confirm(message + '\n\nBạn có muốn xem danh sách chi tiết không?')) {
                    document.getElementById('statusFilter').value = 'Đang hoạt động';
                    filterByStatus('Đang hoạt động');
                }
            }, 1000);
        }
    }

    window.addEventListener('load', function() {
        setTimeout(checkExpiringCards, 500);
    });
</script>
</body>
</html>