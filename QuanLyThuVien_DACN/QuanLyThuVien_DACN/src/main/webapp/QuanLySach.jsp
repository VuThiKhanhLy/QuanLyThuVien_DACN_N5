<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sách - Thư viện</title>
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
                <a href="QuanLySach.html" class="nav-link active">
                    <span class="nav-icon">📖</span>
                    Quản lý Sách
                </a>
                <a href="QuanLySinhVien.html" class="nav-link">
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
                    <h1>Quản lý Sách</h1>
                    <p>Thêm, sửa, xóa và tìm kiếm thông tin sách</p>
                </div>
                <div class="header-right">
                    <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm sách...">
                    <button class="btn btn-primary" onclick="openAddBookModal()">
                        <span>➕</span>
                        Thêm sách mới
                    </button>
                </div>
            </div>

            <!-- Books Table -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <h3 class="card-title">Danh sách sách</h3>
                        <p class="card-subtitle">Tổng cộng: <span id="totalBooksCount">0</span> cuốn sách</p>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <select id="categoryFilter" class="form-select" style="width: 150px;">
                            <option value="">Tất cả thể loại</option>
                            <option value="CNTT">CNTT</option>
                            <option value="Kinh tế">Kinh tế</option>
                            <option value="Văn học">Văn học</option>
                            <option value="Lịch sử">Lịch sử</option>
                            <option value="Khoa học">Khoa học</option>
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
                                <!-- Dữ liệu sách sẽ được render ở đây -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Thêm/Sửa Sách -->
    <div class="modal-backdrop" id="bookModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Thêm sách mới</h3>
                <button class="modal-close" onclick="closeBookModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="bookForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mã sách *</label>
                            <input type="text" id="maSach" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Thể loại *</label>
                            <select id="maTheLoai" class="form-select" required>
                                <option value="">Chọn thể loại</option>
                                <option value="CNTT">CNTT</option>
                                <option value="Kinh tế">Kinh tế</option>
                                <option value="Văn học">Văn học</option>
                                <option value="Lịch sử">Lịch sử</option>
                                <option value="Khoa học">Khoa học</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Năm xuất bản</label>
                            <input type="number" id="namXuatBan" class="form-input" min="1900" max="2100">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nhà xuất bản</label>
                            <input type="text" id="nhaXuatBan" class="form-input">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tên sách *</label>
                        <input type="text" id="tenSach" class="form-input" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tác giả</label>
                        <input type="text" id="tacGia" class="form-input">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Số trang</label>
                            <input type="number" id="soTrang" class="form-input" min="1">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giá tiền</label>
                            <input type="number" id="giaTien" class="form-input" min="0" step="1000">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Số lượng *</label>
                        <input type="number" id="soLuong" class="form-input" min="1" value="1" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Mô tả</label>
                        <textarea id="moTa" class="form-textarea" rows="3" placeholder="Mô tả ngắn về cuốn sách..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" onclick="closeBookModal()">Hủy</button>
                <button class="btn btn-primary" onclick="saveBook()">Lưu</button>
            </div>
        </div>
    </div>

    <script>
        // Dữ liệu mẫu - trong thực tế sẽ lấy từ API
        let books = [
             {
        maSach: 'SACH001',
        tenSach: 'Lập trình C# từ cơ bản đến nâng cao',
        tacGia: 'Nguyễn Văn A',
        maTheLoai: 'CNTT',
        namXuatBan: 2021,
        nhaXuatBan: 'NXB Giáo dục',
        soTrang: 450,
        giaTien: 250000,
        soLuong: 15,
        moTa: 'Sách hướng dẫn lập trình C# dành cho người mới bắt đầu'
            },
            {
                maSach: 'SACH002',
        tenSach: 'Cấu trúc dữ liệu và giải thuật',
        tacGia: 'Trần Thị B',
        maTheLoai: 'CNTT',
        namXuatBan: 2020,
        nhaXuatBan: 'NXB Trẻ',
        soTrang: 380,
        giaTien: 200000,
        soLuong: 12,
        moTa: 'Kiến thức nền tảng về cấu trúc dữ liệu'
            },
            {
                maSach: 'SACH003',
                tenSach: 'Kinh tế học vi mô',
                tacGia: 'Phạm Văn C',
                maTheLoai: 'Kinh tế',
                soTrang: 320,
                giaTien: 180000,
                soLuong: 8,
                moTa: 'Giáo trình kinh tế vi mô cơ bản'
            },
            {
                maSach: 'SACH004',
                tenSach: 'Lịch sử Việt Nam',
                tacGia: 'Lê Thị D',
                maTheLoai: 'Lịch sử',
                soTrang: 500,
                giaTien: 150000,
                soLuong: 20,
                moTa: 'Tổng quan lịch sử dân tộc Việt Nam'
            },
            {
                maSach: 'SACH005',
                tenSach: 'Truyện Kiều',
                tacGia: 'Nguyễn Du',
                maTheLoai: 'Văn học',
                soTrang: 250,
                giaTien: 120000,
                soLuong: 25,
                moTa: 'Tác phẩm kinh điển của văn học Việt Nam'
            }
        ];

        let currentEditId = null;

        // Khởi tạo trang
        document.addEventListener('DOMContentLoaded', function() {
            renderBooksTable();
            setupEventListeners();
        });

        function setupEventListeners() {
            // Tìm kiếm
            document.getElementById('searchInput').addEventListener('input', filterBooks);
            
            // Lọc theo thể loại
            document.getElementById('categoryFilter').addEventListener('change', filterBooks);
        }

        function renderBooksTable(booksToRender = books) {
    const tbody = document.getElementById('booksTableBody');
    
    if (booksToRender.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="text-center">Không có dữ liệu</td></tr>';
        document.getElementById('totalBooksCount').textContent = '0';
        return;
    }

    tbody.innerHTML = booksToRender.map(book => `
        <tr>
            <td><strong>${book.maSach}</strong></td>
            <td>${book.tenSach}</td>
            <td>${book.tacGia || 'Chưa rõ'}</td>
            <td>
                <span class="badge badge-info">${book.maTheLoai}</span>
            </td>
            <td>${book.namXuatBan || 'N/A'}</td>
            <td>${book.nhaXuatBan || 'N/A'}</td>
            <td>${book.soTrang || 'N/A'}</td>
            <td>${book.giaTien ? formatCurrency(book.giaTien) : 'N/A'}</td>
            <td style="text-align: center;">
                <span class="badge ${book.soLuong > 5 ? 'badge-success' : book.soLuong > 0 ? 'badge-warning' : 'badge-danger'}">
                    ${book.soLuong}
                </span>
            <td style="text-align: center;">
    <div style="display: flex; gap: 4px; align-items: center; justify-content: flex-start;">
        <button class="btn btn-ghost btn-sm" onclick="editBook('${book.maSach}')" title="Sửa">
            ✏️
        </button>
        <button class="btn btn-ghost btn-sm" onclick="deleteBook('${book.maSach}')" title="Xóa">
            🗑️
        </button>                  
    </div>
</td>
        </tr>
    `).join('');

    document.getElementById('totalBooksCount').textContent = booksToRender.length;
}

        function filterBooks() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const categoryFilter = document.getElementById('categoryFilter').value;

    const filteredBooks = books.filter(book => {
        // Chỉ tìm kiếm theo tên sách
        const matchesSearch = book.tenSach.toLowerCase().includes(searchTerm);
        const matchesCategory = !categoryFilter || book.maTheLoai === categoryFilter;
        return matchesSearch && matchesCategory;
    });

    renderBooksTable(filteredBooks);
}

        function openAddBookModal() {
            currentEditId = null;
            document.getElementById('modalTitle').textContent = 'Thêm sách mới';
            clearBookForm();
            // Generate new book ID
            const newId = generateBookId();
            document.getElementById('maSach').value = newId;
            document.getElementById('bookModal').style.display = 'flex';
        }

        function editBook(maSach) {
            const book = books.find(b => b.maSach === maSach);
            if (!book) return;

            currentEditId = maSach;
            document.getElementById('modalTitle').textContent = 'Chỉnh sửa sách';
            
            // Fill form with book data
            document.getElementById('maSach').value = book.maSach;
            document.getElementById('tenSach').value = book.tenSach;
            document.getElementById('tacGia').value = book.tacGia || '';
            document.getElementById('maTheLoai').value = book.maTheLoai;
            document.getElementById('namXuatBan').value = book.namXuatBan || '';
            document.getElementById('nhaXuatBan').value = book.nhaXuatBan || '';
            document.getElementById('soTrang').value = book.soTrang || '';
            document.getElementById('giaTien').value = book.giaTien || '';
            document.getElementById('soLuong').value = book.soLuong;
            document.getElementById('moTa').value = book.moTa || '';

            document.getElementById('bookModal').style.display = 'flex';
        }

        function deleteBook(maSach) {
            if (!confirm('Bạn có chắc chắn muốn xóa sách này?')) return;

            const index = books.findIndex(b => b.maSach === maSach);
            if (index !== -1) {
                books.splice(index, 1);
                renderBooksTable();
                alert('Đã xóa sách thành công!');
            }
        }

        function saveBook() {
            const formData = {
    maSach: document.getElementById('maSach').value.trim(),
    tenSach: document.getElementById('tenSach').value.trim(),
    tacGia: document.getElementById('tacGia').value.trim(),
    maTheLoai: document.getElementById('maTheLoai').value,
    namXuatBan: parseInt(document.getElementById('namXuatBan').value) || null,
    nhaXuatBan: document.getElementById('nhaXuatBan').value.trim(),
    soTrang: parseInt(document.getElementById('soTrang').value) || null,
    giaTien: parseInt(document.getElementById('giaTien').value) || null,
    soLuong: parseInt(document.getElementById('soLuong').value) || 1,
    moTa: document.getElementById('moTa').value.trim()
};

            // Validate required fields
            if (!formData.maSach || !formData.tenSach || !formData.maTheLoai) {
                alert('Vui lòng điền đầy đủ các trường bắt buộc (*)');
                return;
            }

            // Check if book ID already exists (when adding new)
            if (!currentEditId && books.some(b => b.maSach === formData.maSach)) {
                alert('Mã sách đã tồn tại. Vui lòng chọn mã khác.');
                return;
            }

            if (currentEditId) {
                // Update existing book
                const index = books.findIndex(b => b.maSach === currentEditId);
                if (index !== -1) {
                    books[index] = formData;
                    alert('Cập nhật sách thành công!');
                }
            } else {
                // Add new book
                books.push(formData);
                alert('Thêm sách mới thành công!');
            }

            closeBookModal();
            renderBooksTable();
        }

        function closeBookModal() {
            document.getElementById('bookModal').style.display = 'none';
            clearBookForm();
        }

        function clearBookForm() {
            document.getElementById('bookForm').reset();
            document.getElementById('namXuatBan').value = '';
            document.getElementById('nhaXuatBan').value = '';
        }

        function generateBookId() {
            const existingIds = books.map(b => b.maSach);
            let counter = 1;
            let newId;
            
            do {
                newId = `SACH${String(counter).padStart(3, '0')}`;
                counter++;
            } while (existingIds.includes(newId));
            
            return newId;
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount);
        }

        function exportToCSV() {
            const headers = ['Mã sách', 'Tên sách', 'Tác giả', 'Thể loại', 'Số trang', 'Giá tiền', 'Số lượng', 'Mô tả'];
            const csvContent = [
                headers.join(','),
                ...books.map(book => [
                    book.maSach,
                    `"${book.tenSach}"`,
                    `"${book.tacGia || ''}"`,
                    book.maTheLoai,
                    book.soTrang || '',
                    book.giaTien || '',
                    book.soLuong,
                    `"${book.moTa || ''}"`
                ].join(','))
            ].join('\n');

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', `danh_sach_sach_${new Date().toISOString().split('T')[0]}.csv`);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        // Close modal when clicking outside
        document.getElementById('bookModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeBookModal();
            }
        });
    </script>
</body>
</html>