<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Chi tiết sách - LibSys</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="Anh/logo.png" sizes="512x512">
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
                <img src="Anh/logo.png" alt="LibSys Logo" class="w-12 h-12 rounded-full shadow">
                <span class="text-2xl font-bold text-gray-800">LibSys</span>
            </div>
            <nav class="flex items-center gap-6 text-base">
                <a href="UserPage.html" class="text-gray-600 hover:text-green-600 transition">Trang chủ</a>
                <a href="#" class="text-gray-600 hover:text-green-600 transition">Giới thiệu</a>
                <a href="#" class="text-gray-600 hover:text-green-600 transition">Hỗ trợ</a>
                <div class="flex items-center gap-3">
                    <span class="text-gray-700 font-medium" id="userIdDisplay"></span>
                    <button onclick="logout()"
                        class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-lg font-semibold transition">Đăng
                        xuất</button>
                </div>
            </nav>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-6 py-10">
        <button onclick="history.back()"
            class="mb-6 flex items-center gap-2 text-green-600 hover:text-green-700 font-semibold">
            <i class="fas fa-arrow-left"></i> Quay lại
        </button>

        <div id="bookDetail" class="bg-white rounded-2xl shadow-lg overflow-hidden">
            <!-- Book detail will be rendered here -->
        </div>
    </main>

    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full mx-4">
            <div class="text-center mb-6">
                <i class="fas fa-question-circle text-6xl text-green-600 mb-4"></i>
                <h3 class="text-2xl font-bold text-gray-800 mb-2">Xác nhận mượn sách</h3>
                <p class="text-gray-600">Bạn có chắc chắn muốn mượn sách này?</p>
            </div>
            <div id="bookInfo" class="bg-gray-50 rounded-lg p-4 mb-6">
                <!-- Book info will be inserted here -->
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
            <div class="flex gap-6">
                <a href="#" class="hover:text-green-400 transition">Giới thiệu</a>
                <a href="#" class="hover:text-green-400 transition">Liên hệ</a>
                <a href="#" class="hover:text-green-400 transition">Chính sách bảo mật</a>
            </div>
            <div class="flex gap-4 items-center text-lg">
                <a href="#" class="hover:text-green-400 transition"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="hover:text-green-400 transition"><i class="fab fa-twitter"></i></a>
                <a href="#" class="hover:text-green-400 transition"><i class="fab fa-instagram"></i></a>
            </div>
            <span class="text-gray-400 mt-4 md:mt-0">&copy; 2025 LibSys. Mọi quyền được bảo lưu.</span>
        </div>
    </footer>

    <script>
        // // Check if user is logged in
        // const isLoggedIn = sessionStorage.getItem('isLoggedIn');
        // if (!isLoggedIn) {
        //     window.location.href = 'Signin.html';
        // }

        // Display user ID
        const userId = sessionStorage.getItem('userId');
        document.getElementById('userIdDisplay').textContent = userId || 'User';

        const books = [
            { id: 1, title: "Chìa Khoá Vũ Trụ", author: "Av Naney", category: "Khoa học", image: "https://covers.openlibrary.org/b/id/10523338-L.jpg", type: "Sách điện tử", year: 2020, pages: 352, price: "150,000", description: "Một hành trình khám phá những bí ẩn của vũ trụ qua lăng kính khoa học hiện đại. Cuốn sách đưa người đọc vào thế giới kỳ diệu của thiên văn học, vật lý lượng tử và những khám phá mới nhất về vũ trụ." },
            { id: 2, title: "Dư âm quá khứ", author: "Av Uzanny", category: "Văn học", image: "https://covers.openlibrary.org/b/id/10523339-L.jpg", type: "Sách điện tử", year: 2019, pages: 428, price: "180,000", description: "Câu chuyện đan xen giữa quá khứ và hiện tại, về tình yêu và ký ức. Một tác phẩm văn học sâu sắc khắc họa những vết tích của thời gian trong tâm hồn con người." },
            { id: 3, title: "Dư âm quá khứ", author: "Dr Naney", category: "Văn học", image: "https://covers.openlibrary.org/b/id/10523340-L.jpg", type: "Sách điện tử", year: 2021, pages: 395, price: "175,000", description: "Phiên bản mới với góc nhìn khác về những dư âm của thời gian. Tác giả khám phá sâu hơn về mối liên hệ giữa ký ức cá nhân và lịch sử tập thể." },
            { id: 4, title: "Văn học", author: "Dr Cetiny", category: "Văn học", image: "https://covers.openlibrary.org/b/id/10523341-L.jpg", type: "Sách điện tử", year: 2018, pages: 512, price: "200,000", description: "Tổng quan về văn học thế giới qua các thời kỳ lịch sử. Từ văn học cổ điển đến hiện đại, cuốn sách cung cấp cái nhìn toàn diện về sự phát triển của nghệ thuật viết lách." },
            { id: 5, title: "Anh Chàng Hobbit", author: "J.R.R. Tolkien", category: "Văn học", image: "https://covers.openlibrary.org/b/id/8264783-L.jpg", type: "Sách giấy", year: 1937, pages: 310, price: "220,000", description: "Cuộc phiêu lưu kỳ diệu của Bilbo Baggins trong thế giới Trung Địa. Một tác phẩm kinh điển của văn học giả tưởng với những nhân vật đáng yêu và thế giới phong phú." },
            { id: 6, title: "Lược sử loài người", author: "Yuval Noah Harari", category: "Lịch sử", image: "https://covers.openlibrary.org/b/id/12918882-L.jpg", type: "Sách điện tử", year: 2011, pages: 464, price: "250,000", description: "Hành trình từ loài vượn đến người hiện đại và những cuộc cách mạng định hình lịch sử. Harari phân tích sâu sắc về cách loài người trở thành loài thống trị trên Trái Đất." },
            { id: 7, title: "Kiêu hãnh và định kiến", author: "Jane Austen", category: "Văn học", image: "https://covers.openlibrary.org/b/id/10077181-L.jpg", type: "Sách giấy", year: 1813, pages: 432, price: "195,000", description: "Tác phẩm kinh điển về tình yêu và xã hội thế kỷ 19. Câu chuyện về Elizabeth Bennet và Mr. Darcy đã trở thành biểu tượng của văn học lãng mạn." },
            { id: 8, title: "Nhà giả kim", author: "Paulo Coelho", category: "Văn học", image: "https://covers.openlibrary.org/b/id/11188384-L.jpg", type: "Sách điện tử", year: 1988, pages: 208, price: "140,000", description: "Câu chuyện về hành trình tìm kiếm kho báu và ý nghĩa cuộc sống. Một fable hiện đại về việc theo đuổi ước mơ và lắng nghe tiếng gọi của trái tim." },
            { id: 9, title: "Thói quen nguyên tử", author: "James Clear", category: "Tự giúp bản thân", image: "https://covers.openlibrary.org/b/id/13139250-L.jpg", type: "Sách điện tử", year: 2018, pages: 320, price: "189,000", description: "Cách thức xây dựng thói quen tốt và phá bỏ thói quen xấu một cách hiệu quả. Clear chia sẻ những phương pháp khoa học để tạo ra những thay đổi tích cực trong cuộc sống." },
            { id: 10, title: "1984", author: "George Orwell", category: "Văn học", image: "https://covers.openlibrary.org/b/id/9253907-L.jpg", type: "Sách giấy", year: 1949, pages: 328, price: "165,000", description: "Tác phẩm dystopia kinh điển về xã hội toàn trị và sự kiểm soát. Orwell vẽ nên bức tranh đáng sợ về một thế giới nơi quyền tự do cá nhân bị xóa bỏ hoàn toàn." },
            { id: 11, title: "Giết con chim nhại", author: "Harper Lee", category: "Văn học", image: "https://covers.openlibrary.org/b/id/7882299-L.jpg", type: "Sách điện tử", year: 1960, pages: 336, price: "170,000", description: "Câu chuyện về công lý, đạo đức và sự trưởng thành ở miền Nam nước Mỹ. Qua đôi mắt của cô bé Scout, tác phẩm khám phá những vấn đề sâu sắc về phân biệt chủng tộc và nhân tính." },
            { id: 12, title: "Đại gia Gatsby", author: "F. Scott Fitzgerald", category: "Văn học", image: "https://covers.openlibrary.org/b/id/8313269-L.jpg", type: "Sách giấy", year: 1925, pages: 218, price: "155,000", description: "Bi kịch về giấc mơ Mỹ và tình yêu trong thời đại jazz. Fitzgerald tái hiện chân thực về sự phù hoa, huyễn hoặc và những khát khao không thể đạt được." }
        ];

        const bookId = parseInt(sessionStorage.getItem('selectedBook'));
        const book = books.find(b => b.id === bookId);

        if (!book) {
            document.getElementById('bookDetail').innerHTML = '<div class="p-8 text-center text-gray-500">Không tìm thấy thông tin sách</div>';
        } else {
            document.getElementById('bookDetail').innerHTML = `
            <div class="grid md:grid-cols-2 gap-8 p-8">
                <div class="flex justify-center items-start">
                    <img src="${book.image}" alt="${book.title}" class="w-full max-w-md rounded-lg shadow-lg">
                </div>
                <div class="flex flex-col gap-4">
                    <h1 class="text-4xl font-bold text-gray-800">${book.title}</h1>
                    <div class="flex items-center gap-2 text-xl text-gray-600">
                        <i class="fas fa-user"></i>
                        <span>${book.author}</span>
                    </div>
                    
                    <div class="border-t border-gray-200 pt-4 mt-2 space-y-3">
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600 font-medium">Mã sách:</span>
                            <span class="text-gray-800 font-semibold">BOOK${String(book.id).padStart(4, '0')}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600 font-medium">Thể loại:</span>
                            <span class="text-gray-800 font-semibold">${book.category}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600 font-medium">Năm xuất bản:</span>
                            <span class="text-gray-800 font-semibold">${book.year}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600 font-medium">Số trang:</span>
                            <span class="text-gray-800 font-semibold">${book.pages} trang</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600 font-medium">Loại sách:</span>
                            <span class="text-gray-800 font-semibold">${book.type}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600 font-medium">Giá tiền:</span>
                            <span class="text-green-600 font-bold text-xl">${book.price} VNĐ</span>
                        </div>
                    </div>

                    <div class="mt-4">
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Mô tả:</h3>
                        <p class="text-gray-600 leading-relaxed">${book.description}</p>
                    </div>

                    <button onclick="showBorrowModal()" class="mt-6 w-full bg-green-600 hover:bg-green-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition duration-300 shadow-lg hover:shadow-xl flex items-center justify-center gap-3">
                        <i class="fas fa-book-reader"></i>
                        Mượn sách
                    </button>
                </div>
            </div>
        `;
        }

        function showBorrowModal() {
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
        }

        function confirmBorrow() {
            alert(`Bạn đã mượn sách "${book.title}" thành công!\nVui lòng đến thư viện để nhận sách.`);
            document.getElementById('confirmModal').classList.remove('show');
        }

        function logout() {
            sessionStorage.clear();
            window.location.href = 'Giaodien.html';
        }
    </script>
</body>

</html>