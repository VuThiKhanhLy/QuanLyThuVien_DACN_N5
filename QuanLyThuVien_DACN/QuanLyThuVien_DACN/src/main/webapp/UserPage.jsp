<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>LibSys - Library System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Anh/logo.png" sizes="512x512">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>

<body class="bg-gray-100 text-gray-800">

<header class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto flex items-center justify-between px-6 py-4">
        <div class="flex items-center gap-3">
            <img src="${pageContext.request.contextPath}/Anh/logo.png" alt="LibSys Logo" class="w-12 h-12 rounded-full shadow">
            <span class="text-2xl font-bold text-gray-800">LibSys</span>
        </div>
        <nav class="flex items-center gap-6 text-base">
            <a href="#" class="text-green-600 font-semibold">Trang chủ</a>
            <a href="#" class="text-gray-600 hover:text-green-600 transition">Hỗ trợ</a>
            <div class="flex items-center gap-3 relative">
                    <span class="text-gray-700 font-medium" id="userIdDisplay">
                        <c:out value="${sessionScope.loggedInAccount.tenDangNhap}" default="User"/>
                    </span>

                <div class="relative">
                    <img src="https://i.pravatar.cc/40?img=3" alt="Avatar" id="profileAvatar"
                         class="w-10 h-10 rounded-full border-2 border-green-500 cursor-pointer">
                    <div id="profileMenu"
                         class="hidden absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-50">
                        <a href="#" class="block px-4 py-2 text-gray-700 hover:bg-green-100"
                           onclick="manageInfo()">Quản lý thông tin</a>
                        <a href="#" class="block px-4 py-2 text-gray-700 hover:bg-green-100"
                           onclick="viewHistory()">Lịch sử mượn sách</a>
                    </div>
                </div>
                <button onclick="logout()"
                        class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-lg font-semibold transition">Đăng
                    xuất</button>
            </div>
        </nav>
    </div>
</header>

<section class="bg-white shadow">
    <div class="max-w-4xl mx-auto px-6 py-5">
        <h2 class="text-gray-800 font-bold text-2xl mb-4 text-center tracking-wide">
            HỆ THỐNG TRA CỨU TÀI LIỆU, VĂN BẢN, DỮ LIỆU...
        </h2>
        <div class="relative w-full">
            <div class="absolute inset-y-0 left-0 pl-5 flex items-center pointer-events-none">
                <i class="fas fa-search text-gray-400"></i>
            </div>
            <input type="text" id="searchInput"
                   class="w-full pl-14 pr-5 py-4 border-2 border-gray-300 rounded-lg outline-none text-gray-900 bg-white font-semibold text-lg focus:border-green-500 focus:ring-2 focus:ring-green-200 transition"
                   placeholder="Tìm kiếm tài liệu, văn bản, luận văn..."
                   value="<c:out value='${paramSearch}'/>">
        </div>
    </div>
</section>

<section class="relative">
    <div class="relative w-full h-64 overflow-hidden rounded-b-xl">
        <div id="bannerSlider" class="flex transition-transform duration-700 ease-in-out h-64">
            <img src="${pageContext.request.contextPath}/Anh/nensach1.jpg"
                 alt="Banner 1" class="w-full h-64 object-cover flex-shrink-0">
            <img src="${pageContext.request.contextPath}/Anh/nensach2.jpg"
                 alt="Banner 2" class="w-full h-64 object-cover flex-shrink-0">
            <img src="${pageContext.request.contextPath}/Anh/nensach3.jpg"
                 alt="Banner 3" class="w-full h-64 object-cover flex-shrink-0">
        </div>
        <button onclick="prevBanner()"
                class="absolute left-2 top-1/2 -translate-y-1/2 bg-black bg-opacity-30 text-white rounded-full p-2 hover:bg-opacity-60 transition z-20">
            <i class="fas fa-chevron-left"></i>
        </button>
        <button onclick="nextBanner()"
                class="absolute right-2 top-1/2 -translate-y-1/2 bg-black bg-opacity-30 text-white rounded-full p-2 hover:bg-opacity-60 transition z-20">
            <i class="fas fa-chevron-right"></i>
        </button>
        <div class="absolute bottom-3 left-1/2 -translate-x-1/2 flex gap-2 z-20">
                <span class="w-3 h-3 rounded-full bg-white bg-opacity-70 border border-green-600 cursor-pointer"
                      onclick="goToBanner(0)" id="dot0"></span>
            <span class="w-3 h-3 rounded-full bg-white bg-opacity-50 border border-green-600 cursor-pointer"
                  onclick="goToBanner(1)" id="dot1"></span>
            <span class="w-3 h-3 rounded-full bg-white bg-opacity-50 border border-green-600 cursor-pointer"
                  onclick="goToBanner(2)" id="dot2"></span>
        </div>
    </div>
    <div class="absolute inset-0 flex flex-col items-center justify-center bg-black bg-opacity-50 z-10">
        <h1 class="text-white text-3xl md:text-4xl font-bold mb-2 text-center">Khám phá thế giới qua từng trang sách
        </h1>
        <p class="text-white text-lg mb-4 text-center">Kiến thức và cảm hứng luôn chờ bạn.</p>
    </div>
</section>
<main class="max-w-7xl mx-auto px-6 py-10 flex flex-col lg:flex-row gap-8">

    <aside class="w-full lg:w-64 bg-white rounded-xl shadow p-4 flex-shrink-0 h-fit sticky top-4">
        <h2 class="font-bold text-xl mb-4 border-b pb-3">Chuyên mục</h2>
        <nav class="space-y-2">
            <a href="student/home?category=all&search=<c:out value='${paramSearch}'/>&limit=<c:out value='${paramLimit}'/>&sortBy=<c:out value='${paramSortBy}'/>&page=1"
               class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition font-semibold category-filter
                    <c:if test="${paramCategory == 'all' || empty paramCategory}">bg-green-100 text-green-700</c:if>"
               data-category="all">
                Tất cả
            </a>

            <c:set var="categories" value="${['Tiểu thuyết', 'Truyện ngắn', 'Khoa học', 'Công nghệ', 'Tâm lý', 'Lịch sử', 'Giáo dục', 'Thiếu nhi']}" />
            <c:forEach var="cat" items="${categories}">
                <a href="student/home?category=<c:out value='${cat}'/>&search=<c:out value='${paramSearch}'/>&limit=<c:out value='${paramLimit}'/>&sortBy=<c:out value='${paramSortBy}'/>&page=1"
                   class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition category-filter
                        <c:if test="${paramCategory == cat}">bg-green-100 text-green-700 font-semibold</c:if>"
                   data-category="<c:out value='${cat}'/>">
                        ${cat}
                </a>
            </c:forEach>
        </nav>
    </aside>

    <section class="flex-1">
        <div class="flex items-center gap-4 mb-6">

            <select id="sortBy" onchange="changeSortBy()"
                    class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 bg-white focus:outline-none focus:ring-2 focus:ring-green-500">
                <option value="latest" <c:if test="${paramSortBy == 'latest' || empty paramSortBy}">selected</c:if>>Sắp xếp: Mới nhất</option>
                <option value="popular" <c:if test="${paramSortBy == 'popular'}">selected</c:if>>Sắp xếp: Phổ biến</option>
                <option value="oldest" <c:if test="${paramSortBy == 'oldest'}">selected</c:if>>Sắp xếp: Cũ nhất</option>
            </select>

            <select id="booksPerPage" onchange="changeBooksPerPage()"
                    class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 bg-white focus:outline-none focus:ring-2 focus:ring-green-500">
                <option value="12" <c:if test="${paramLimit == '12' || empty paramLimit}">selected</c:if>>Hiển thị: 12 sách/trang</option>
                <option value="24" <c:if test="${paramLimit == '24'}">selected</c:if>>Hiển thị: 24 sách/trang</option>
            </select>
        </div>

        <div id="bookGrid" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-8">
        </div>

        <div class="mt-8 flex justify-center gap-2" id="pagination">
        </div>
    </section>
</main>

<div id="confirmModal" class="modal">
    <div class="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full mx-4">
        <div class="text-center mb-6">
            <i class="fas fa-question-circle text-6xl text-green-600 mb-4"></i>
            <h3 class="text-2xl font-bold text-gray-800 mb-2">Xác nhận mượn sách</h3>
            <p class="text-gray-600">Bạn có chắc chắn muốn mượn sách này?</p>
        </div>
        <div id="bookInfo" class="bg-gray-50 rounded-lg p-4 mb-6">
        </div>
        <div class="flex gap-4">
            <button onclick="cancelBorrow()"
                    class="flex-1 px-6 py-3 bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold rounded-lg transition">Hủy</button>
            <button onclick="confirmBorrow()"
                    class="flex-1 px-6 py-3 bg-green-600 hover:bg-green-700 text-white font-semibold rounded-lg transition">OK</button>
        </div>
    </div>
</div>

<footer class="bg-gray-800 border-t mt-12 py-8 text-white text-sm">
    <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6 px-6">
        <div class="w-full md:w-1/3 flex flex-col items-start mb-6 md:mb-0">
            <div>
                <span class="font-bold text-lg">Thư viện LibSys</span> | Thành lập: 2010<br>
                LibSys là thư viện hiện đại với hơn 50.000 đầu sách, phục vụ cộng đồng học tập và nghiên cứu.<br>
                Đạt giải "Thư viện xuất sắc toàn quốc 2022" và "Giải thưởng Đổi mới công nghệ thư viện 2024".<br>
                <span class="block mt-2"><i class="fas fa-map-marker-alt mr-1"></i> Địa chỉ: Cầu Diễn, Quận Bắc Từ
                        Liêm, TP. Hà Nội</span>
            </div>
        </div>
        <div class="w-full md:w-1/3 flex flex-col items-center mb-6 md:mb-0">
            <span class="font-semibold mb-1">Hotline liên hệ:</span>
            <div class="flex gap-4 items-center">
                <a href="https://zalo.me/0123456789" target="_blank"
                   class="hover:text-green-400 transition flex items-center" title="Zalo">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo"
                         class="w-5 h-5 mr-1" style="background:white;border-radius:50%;"> Zalo
                </a>
                <a href="https://facebook.com/libsys" target="_blank"
                   class="hover:text-green-400 transition flex items-center" title="Facebook">
                    <i class="fab fa-facebook-f mr-1"></i> Facebook
                </a>
                <a href="https://instagram.com/libsys" target="_blank"
                   class="hover:text-green-400 transition flex items-center" title="Instagram">
                    <i class="fab fa-instagram mr-1"></i> Instagram
                </a>
                <span class="ml-2 flex items-center"><i class="fas fa-phone-alt mr-1"></i>0123 456 789</span>
            </div>
        </div>
        <div class="w-full md:w-1/3 flex flex-col items-end text-right">
            <span class="text-gray-400">&copy; 2025 LibSys. Mọi quyền được bảo lưu.</span>
        </div>
    </div>
</footer>

<script>
    // ====================================================================
    // DỮ LIỆU ĐỘNG TỪ SERVER (HOMEPAGEFORSTUDENTSV.JAVA)
    // ====================================================================

    // Dữ liệu Sách
    const books = [];
    <c:forEach var="book" items="${requestScope.listSach}">
    books.push({
        id: ${book.maSach},
        title: "<c:out value='${book.tenSach}' escapeXml='true'/>",
        author: "<c:out value='${book.tenTacGia}' escapeXml='true'/>",
        category: "<c:out value='${book.tenTheLoai}' escapeXml='true'/>",
        image: "<c:out value='${book.image}' escapeXml='true'/>",
        // Giả định: MaNXB=1 là Sách điện tử (cần kiểm tra lại logic CSDL)
        type: "${book.maNXB == 1 ? 'Sách điện tử' : 'Sách giấy'}",
        year: ${book.namXuatBan},
        pages: ${book.soTrang},
        // Định dạng giá tiền bằng JSTL
        price: "<fmt:formatNumber value='${book.giaTien}' type='number' maxFractionDigits='0'/>",
        description: "<c:out value='${book.moTa}' escapeXml='true'/>"
    });
    </c:forEach>

    // Trạng thái Phân trang/Lọc
    let currentCategory = '<c:out value="${paramCategory}" default="all"/>';
    let searchTerm = '<c:out value="${paramSearch}" default=""/>';
    let booksPerPage = parseInt('<c:out value="${paramLimit}" default="12"/>');
    let currentPage = parseInt('<c:out value="${currentPage}" default="1"/>');
    const totalPagesFromServer = parseInt('${totalPages}' || 1);
    let currentSortBy = '<c:out value="${paramSortBy}" default="latest"/>';
    let selectedBookId = null;


    // ====================================================================
    // LOGIC CHUNG
    // ====================================================================

    // Toggle profile menu
    document.getElementById('profileAvatar').addEventListener('click', function (e) {
        e.stopPropagation();
        const menu = document.getElementById('profileMenu');
        menu.classList.toggle('hidden');
    });
    // Hide menu when click outside
    document.addEventListener('click', function () {
        document.getElementById('profileMenu').classList.add('hidden');
    });

    // Dummy functions for menu actions
    function manageInfo() {
        window.location.href = '${pageContext.request.contextPath}/UserInfo.html';
    }
    function viewHistory() {
        window.location.href = '${pageContext.request.contextPath}/UserHistory.html';
    }
    function logout() {
        // Hiển thị modal đăng xuất
        document.getElementById('logoutModal').classList.add('show');
    }
    function closeLogoutModal() {
        document.getElementById('logoutModal').classList.remove('show');
    }
    function confirmLogout() {
        sessionStorage.clear();
        // Chuyển hướng đến trang login
        window.location.href = '${pageContext.request.contextPath}/Giaodien.html';
    }


    // ====================================================================
    // LOGIC HIỂN THỊ SÁCH VÀ PHÂN TRANG
    // ====================================================================

    function renderBooks() {
        const grid = document.getElementById('bookGrid');

        if (books.length === 0) {
            grid.innerHTML = '<div class="col-span-full text-center py-12 text-gray-500"><i class="fas fa-search text-4xl mb-4"></i><p class="text-lg">Không tìm thấy sách phù hợp</p></div>';
            document.getElementById('pagination').innerHTML = '';
            return;
        }

        grid.innerHTML = books.map(book => `
                <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                    <img src="${book.image}" alt="${book.title}" class="w-full h-52 object-cover">
                    <div class="flex-1 flex flex-col px-5 py-4">
                        <div class="font-bold text-lg mb-1 text-gray-800">${book.title}</div>
                        <div class="text-base text-gray-500 mb-2">${book.author}</div>
                        <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                            <i class="fas fa-book"></i>
                            <span>${book.type}</span>
                        </div>
                        <div class="flex gap-3 mt-auto w-full">
                            <button onclick="viewDetail(${book.id})" class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                            <button onclick="showBorrowModal(${book.id})" class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                        </div>
                    </div>
                </div>
            `).join('');

        renderPagination(totalPagesFromServer);
    }

    function renderPagination(totalPages) {
        const pagination = document.getElementById('pagination');
        let paginationHTML = '';

        // Nút Previous
        paginationHTML += `
                <button onclick="changePage(${currentPage - 1})"
                    class="px-3 py-1 rounded-lg border ${currentPage == 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'hover:bg-green-50 text-gray-700'}"
                    ${currentPage == 1 ? 'disabled' : ''}>
                    <i class="fas fa-chevron-left"></i>
                </button>
            `;

        // Các nút số trang
        const maxPagesToShow = 5;
        let startPage = Math.max(1, currentPage - Math.floor(maxPagesToShow / 2));
        let endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);

        if (endPage - startPage + 1 < maxPagesToShow && totalPages > maxPagesToShow) {
            startPage = Math.max(1, endPage - maxPagesToShow + 1);
        }

        if (startPage > 1) {
            paginationHTML += `<button onclick="changePage(1)" class="px-3 py-1 rounded-lg border hover:bg-green-50 text-gray-700">1</button>`;
            if (startPage > 2) paginationHTML += `<span class="px-1 py-1 text-gray-500">...</span>`;
        }

        for (let i = startPage; i <= endPage; i++) {
            paginationHTML += `
                    <button onclick="changePage(${i})"
                            class="px-3 py-1 rounded-lg border ${currentPage == i ? 'bg-green-600 text-white' : 'hover:bg-green-50 text-gray-700'}">
                        ${i}
                    </button>
                `;
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) paginationHTML += `<span class="px-1 py-1 text-gray-500">...</span>`;
            paginationHTML += `<button onclick="changePage(${totalPages})" class="px-3 py-1 rounded-lg border hover:bg-green-50 text-gray-700">${totalPages}</button>`;
        }

        // Nút Next
        paginationHTML += `
                <button onclick="changePage(${currentPage + 1})"
                    class="px-3 py-1 rounded-lg border ${currentPage == totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'hover:bg-green-50 text-gray-700'}"
                    ${currentPage == totalPages ? 'disabled' : ''}>
                    <i class="fas fa-chevron-right"></i>
                </button>
            `;

        pagination.innerHTML = paginationHTML;
    }

    // ====================================================================
    // LOGIC CHUYỂN HƯỚNG SANG SERVLET ĐỂ CẬP NHẬT TRẠNG THÁI
    // ====================================================================

    // Tạo URL mới dựa trên trạng thái hiện tại
    function buildUrl(newPage, newLimit, newSortBy, newCategory, newSearch) {
        // Sử dụng toán tử nullish coalescing (??) hoặc giá trị mặc định đã được thiết lập
        const category = newCategory || currentCategory;
        const search = newSearch || searchTerm;
        const limit = newLimit || booksPerPage;
        const page = newPage || currentPage;
        const sortBy = newSortBy || currentSortBy;

        return `student/home?category=${category}&search=${search}&limit=${limit}&sortBy=${sortBy}&page=${page}`;
    }

    function changePage(page) {
        if (page < 1 || page > totalPagesFromServer) return;
        window.location.href = buildUrl(page);
    }

    function changeBooksPerPage() {
        const newLimit = parseInt(document.getElementById('booksPerPage').value);
        window.location.href = buildUrl(1, newLimit); // Reset về trang 1
    }

    function changeSortBy() {
        const newSortBy = document.getElementById('sortBy').value;
        window.location.href = buildUrl(1, null, newSortBy); // Reset về trang 1
    }

    function viewDetail(bookId) {
        sessionStorage.setItem('selectedBook', bookId);
        window.location.href = '${pageContext.request.contextPath}/UserBookDetail.html';
    }

    // ====================================================================
    // LOGIC MODAL MƯỢN SÁCH
    // ====================================================================

    function showBorrowModal(bookId) {
        selectedBookId = bookId;
        const book = books.find(b => b.id === bookId);

        if (!book) return;

        document.getElementById('bookInfo').innerHTML = `
                <div class="flex items-center gap-4">
                    <img src="${book.image}" alt="${book.title}" class="w-20 h-28 object-cover rounded shadow">
                    <div>
                        <div class="font-bold text-lg text-gray-800">${book.title}</div>
                        <div class="text-gray-600">${book.author}</div>
                        <div class="text-green-600 font-semibold mt-1">${book.price} VNĐ</div>
                    </div>
                </div>
            `;

        document.getElementById('confirmModal').classList.add('show');
    }

    function cancelBorrow() {
        document.getElementById('confirmModal').classList.remove('show');
        selectedBookId = null;
    }

    function confirmBorrow() {
        const book = books.find(b => b.id === selectedBookId);
        if (!book) {
            alert("Không tìm thấy thông tin sách.");
            return;
        }
        // Giả lập lưu lịch sử mượn sách (nên dùng AJAX call đến Servlet)
        const history = JSON.parse(localStorage.getItem('borrowHistory') || '[]');
        history.unshift({
            title: book.title,
            author: book.author,
            image: book.image,
            date: new Date().toLocaleDateString('vi-VN'),
        });
        localStorage.setItem('borrowHistory', JSON.stringify(history));
        alert(`Bạn đã mượn sách "${book.title}" thành công!\nVui lòng đến thư viện để nhận sách.`);
        document.getElementById('confirmModal').classList.remove('show');
        selectedBookId = null;
    }

    // ====================================================================
    // EVENT LISTENERS (TÌM KIẾM)
    // ====================================================================

    document.getElementById('searchInput').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            const newSearch = e.target.value;
            // Chuyển hướng tới Servlet để thực hiện tìm kiếm và reset trang 1
            window.location.href = buildUrl(1, null, null, currentCategory, newSearch);
        }
    });

    // ====================================================================
    // BANNER SLIDER LOGIC
    // ====================================================================

    const bannerImages = [
        "${pageContext.request.contextPath}/Anh/nensach1.jpg",
        "${pageContext.request.contextPath}/Anh/nensach2.jpg",
        "${pageContext.request.contextPath}/Anh/nensach3.jpg"
    ];
    let currentBanner = 0;
    const slider = document.getElementById('bannerSlider');
    const dots = [document.getElementById('dot0'), document.getElementById('dot1'), document.getElementById('dot2')];
    let bannerTimer = null;

    function showBanner(idx) {
        currentBanner = idx;
        slider.style.transform = `translateX(-${idx * 100}%)`;
        dots.forEach((dot, i) => {
            dot.classList.toggle('bg-opacity-70', i === idx);
            dot.classList.toggle('bg-opacity-50', i !== idx);
        });
    }
    function nextBanner() {
        showBanner((currentBanner + 1) % bannerImages.length);
        resetBannerTimer();
    }
    function prevBanner() {
        showBanner((currentBanner - 1 + bannerImages.length) % bannerImages.length);
        resetBannerTimer();
    }
    function goToBanner(idx) {
        showBanner(idx);
        resetBannerTimer();
    }
    function resetBannerTimer() {
        if (bannerTimer) clearInterval(bannerTimer);
        bannerTimer = setInterval(() => {
            showBanner((currentBanner + 1) % bannerImages.length);
        }, 4000);
    }

    // ====================================================================
    // KHỞI TẠO
    // ====================================================================
    renderBooks();
    showBanner(0);
    resetBannerTimer();
</script>
</body>
<div id="logoutModal" class="modal">
    <div class="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full mx-4 text-center">
        <i class="fas fa-sign-out-alt text-5xl text-red-500 mb-4"></i>
        <h3 class="text-2xl font-bold text-gray-800 mb-2">Đăng xuất</h3>
        <p class="text-gray-600 mb-6">Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?</p>
        <div class="flex gap-4">
            <button onclick="closeLogoutModal()"
                    class="flex-1 px-6 py-3 bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold rounded-lg transition">Hủy</button>
            <button onclick="confirmLogout()"
                    class="flex-1 px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-lg transition">Đăng
                xuất</button>
        </div>
    </div>
</div>

</html>