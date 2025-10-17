<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.quanlythuvien.model.TaiKhoan" %>
<%
    // ========================== 1. BẢO VỆ TRANG VÀ KHAI BÁO BIẾN ==========================

    // Lấy đối tượng TaiKhoan từ Session
    TaiKhoan currentAccount = (TaiKhoan) session.getAttribute("loggedInAccount");

    // Kiểm tra: Nếu không có tài khoản HOẶC không phải là vai trò được phép, chuyển hướng
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
    <title>Quản lý Sách - Thư viện</title>
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
            <a href="${pageContext.request.contextPath}/BookServlet" class="nav-link active">
                <span class="nav-icon">📖</span> Quản lý Sách
            </a>
            <a href="${pageContext.request.contextPath}/StudentServlet" class="nav-link">
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
                <h1>Quản lý Sách</h1>
                <p>Thêm, sửa, xóa và tìm kiếm thông tin sách</p>
            </div>
            <div class="header-right">
                <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm sách..."
                       value="${searchKeyword}">
                <button class="btn btn-primary" onclick="openAddBookModal()">
                    <span>➕</span>
                    Thêm sách mới
                </button>
            </div>
        </div>

        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType}" id="alertMessage">
                    ${sessionScope.message}
            </div>
            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>
        </c:if>

        <div class="card">
            <div class="card-header">
                <div>
                    <h3 class="card-title">Danh sách sách</h3>
                    <p class="card-subtitle">Tổng cộng: <span id="totalBooksCount">${books.size()}</span> cuốn sách</p>
                </div>
                <div style="display: flex; gap: 12px;">
                    <select id="categoryFilter" class="form-select" style="width: 200px;">
                        <option value="0">Tất cả thể loại</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.key}" ${selectedCategory == category.key ? 'selected' : ''}>
                                    ${category.value}
                            </option>
                        </c:forEach>
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
                            <th>Mã sách</th>
                            <th>Tên sách</th>
                            <th>Tác giả</th>
                            <th>Thể loại</th>
                            <th>Năm xuất bản</th>
                            <th>Nhà xuất bản</th>
                            <th>Số trang</th>
                            <th>Giá tiền</th>
                            <th>Số lượng</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody id="booksTableBody">
                        <c:choose>
                            <c:when test="${empty books}">
                                <tr>
                                    <td colspan="10" class="text-center">Không có dữ liệu</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="book" items="${books}">
                                    <tr>
                                        <td><strong>${book.maSach}</strong></td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                <c:if test="${not empty book.duongLinkAnh}">
                                                    <img src="${book.duongLinkAnh}"
                                                         alt="${book.tenSach}"
                                                         style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;">
                                                </c:if>
                                                <span>${book.tenSach}</span>
                                            </div>
                                        </td>
                                        <td>${not empty book.tacGia ? book.tacGia : 'Chưa rõ'}</td>
                                        <td>
                                            <span class="badge badge-info">${book.tenTheLoai}</span>
                                        </td>
                                        <td>${not empty book.namXuatBan ? book.namXuatBan : 'N/A'}</td>
                                        <td>${not empty book.tenNXB ? book.tenNXB : 'N/A'}</td>
                                        <td>${not empty book.soTrang ? book.soTrang : 'N/A'}</td>
                                        <td>
                                            <c:if test="${not empty book.giaTien}">
                                                <fmt:formatNumber value="${book.giaTien}" type="currency"
                                                                  currencySymbol="₫" groupingUsed="true"/>
                                            </c:if>
                                            <c:if test="${empty book.giaTien}">N/A</c:if>
                                        </td>
                                        <td style="text-align: center;">
                                                    <span class="badge ${book.soLuong > 5 ? 'badge-success' : book.soLuong > 0 ? 'badge-warning' : 'badge-danger'}">
                                                            ${book.soLuong}
                                                    </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <div style="display: flex; gap: 4px; align-items: center; justify-content: flex-start;">
                                                <button class="btn btn-ghost btn-sm" onclick="editBook(${book.maSach})" title="Sửa">
                                                    ✏️
                                                </button>
                                                <button class="btn btn-ghost btn-sm" onclick="deleteBook(${book.maSach})" title="Xóa">
                                                    🗑️
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal-backdrop" id="bookModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title" id="modalTitle">Thêm sách mới</h3>
            <button class="modal-close" onclick="closeBookModal()">&times;</button>
        </div>
        <form id="bookForm" method="post" action="BookServlet" enctype="multipart/form-data">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="maSach" id="maSach">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Ảnh bìa sách</label>
                    <input type="file" name="bookImage" id="bookImage"
                           class="form-input" accept="image/*" onchange="previewImage(event)">
                    <div id="imagePreview" style="margin-top: 12px; display: none;">
                        <img id="previewImg" src="" alt="Preview"
                             style="max-width: 200px; max-height: 200px; border-radius: 8px; border: 2px solid #e1e8ed;">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Tên sách *</label>
                    <input type="text" name="tenSach" id="tenSach" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Tác giả</label>
                    <input type="text" name="tacGia" id="tacGia" class="form-input"
                           placeholder="Nhập tên tác giả (hoặc chọn từ danh sách)">
                    <small style="color: #7f8c8d; font-size: 12px;">
                        * Lưu ý: Hiện tại chỉ lưu tên tác giả. Chức năng liên kết với bảng TACGIA sẽ được bổ sung sau.
                    </small>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Thể loại *</label>
                        <select name="maTheLoai" id="maTheLoai" class="form-select" required>
                            <option value="">Chọn thể loại</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.key}">${category.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Năm xuất bản</label>
                        <input type="number" name="namXuatBan" id="namXuatBan" class="form-input"
                               min="1900" max="2100">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Nhà xuất bản</label>
                    <select name="maNXB" id="maNXB" class="form-select">
                        <option value="">Chọn nhà xuất bản</option>
                        <c:forEach var="publisher" items="${publishers}">
                            <option value="${publisher.key}">${publisher.value}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Số trang</label>
                        <input type="number" name="soTrang" id="soTrang" class="form-input" min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giá tiền (VNĐ)</label>
                        <input type="number" name="giaTien" id="giaTien" class="form-input"
                               min="0" step="1000">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Số lượng *</label>
                    <input type="number" name="soLuong" id="soLuong" class="form-input"
                           min="0" value="1" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Mô tả</label>
                    <textarea name="moTa" id="moTa" class="form-textarea" rows="3"
                              placeholder="Mô tả ngắn về cuốn sách..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeBookModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Auto hide alert after 3 seconds
    window.onload = function() {
        const alert = document.getElementById('alertMessage');
        if (alert) {
            setTimeout(() => {
                alert.style.display = 'none';
            }, 3000);
        }
    };

    // Preview ảnh trước khi upload
    function previewImage(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('previewImg').src = e.target.result;
                document.getElementById('imagePreview').style.display = 'block';
            };
            reader.readAsDataURL(file);
        }
    }

    // Tìm kiếm sách
    document.getElementById('searchInput').addEventListener('input', function() {
        const keyword = this.value;
        const categoryId = document.getElementById('categoryFilter').value;

        if (keyword.length >= 2 || keyword.length === 0) {
            window.location.href = 'BookServlet?action=search&keyword=' +
                encodeURIComponent(keyword) + '&categoryId=' + categoryId;
        }
    });

    // Lọc theo thể loại
    document.getElementById('categoryFilter').addEventListener('change', function() {
        const categoryId = this.value;
        const keyword = document.getElementById('searchInput').value;

        if (categoryId === '0') {
            window.location.href = 'BookServlet?action=list';
        } else {
            window.location.href = 'BookServlet?action=search&keyword=' +
                encodeURIComponent(keyword) + '&categoryId=' + categoryId;
        }
    });

    // Mở modal thêm sách
    function openAddBookModal() {
        document.getElementById('modalTitle').textContent = 'Thêm sách mới';
        document.getElementById('formAction').value = 'add';
        document.getElementById('bookForm').reset();
        document.getElementById('maSach').value = '';
        document.getElementById('imagePreview').style.display = 'none';
        document.getElementById('bookModal').style.display = 'flex';
    }

    // Sửa sách
    function editBook(maSach) {
        console.log('Editing book ID:', maSach);

        fetch('BookServlet?action=getById&id=' + maSach)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(book => {
                console.log('Book data:', book);

                document.getElementById('modalTitle').textContent = 'Chỉnh sửa sách';
                document.getElementById('formAction').value = 'update';
                document.getElementById('maSach').value = book.maSach;
                document.getElementById('tenSach').value = book.tenSach || '';
                document.getElementById('tacGia').value = book.tacGia || '';
                document.getElementById('maTheLoai').value = book.maTheLoai || '';
                document.getElementById('namXuatBan').value = book.namXuatBan || '';
                document.getElementById('maNXB').value = book.maNXB || '';
                document.getElementById('soTrang').value = book.soTrang || '';
                document.getElementById('giaTien').value = book.giaTien || '';
                document.getElementById('soLuong').value = book.soLuong || '';
                document.getElementById('moTa').value = book.moTa || '';

                document.getElementById('imagePreview').style.display = 'none';
                document.getElementById('bookModal').style.display = 'flex';
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể tải thông tin sách! Error: ' + error.message);
            });
    }

    // Xóa sách
    function deleteBook(maSach) {
        if (!confirm('Bạn có chắc chắn muốn xóa sách này?')) {
            return false;
        }

        // Tạo form để submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'BookServlet';

        // Action = delete
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';

        // Mã sách
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'maSach';
        idInput.value = maSach;

        // Append và submit
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);

        console.log('Deleting book ID:', maSach);
        form.submit();
        return true;
    }

    // Đóng modal
    function closeBookModal() {
        document.getElementById('bookModal').style.display = 'none';
        document.getElementById('bookForm').reset();
        document.getElementById('imagePreview').style.display = 'none';
    }

    // Đóng modal khi click bên ngoài
    document.getElementById('bookModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeBookModal();
        }
    });

    // Xuất CSV
    function exportToCSV() {
        const table = document.querySelector('.table');
        const rows = table.querySelectorAll('tr');
        let csvContent = '';

        rows.forEach((row, index) => {
            const cols = row.querySelectorAll('td, th');
            const rowData = [];

            cols.forEach((col, colIndex) => {
                // Skip hành động column
                if (colIndex === cols.length - 1 && index > 0) return;

                let text = col.textContent.trim();
                // Escape quotes
                text = text.replace(/"/g, '""');
                rowData.push('"' + text + '"');
            });

            if (rowData.length > 0) {
                csvContent += rowData.join(',') + '\n';
            }
        });

        // Create download link
        const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);
        link.setAttribute('href', url);
        link.setAttribute('download', 'danh_sach_sach_' + new Date().toISOString().split('T')[0] + '.csv');
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
</script>
</body>
</html>