<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LibSys - Library System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="Anh/logo.png" sizes="512x512">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; }
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
            <a href="#" class="text-green-600 font-semibold">Trang chủ</a>
            <a href="#" class="text-gray-600 hover:text-green-600 transition">Giới thiệu</a>
            <a href="#" class="text-gray-600 hover:text-green-600 transition">Hỗ trợ</a>
            <a href="Homepage.html" class="bg-green-600 hover:bg-green-700 text-white px-5 py-2 rounded-lg font-semibold transition">Đăng nhập</a>
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
            <input
                    type="text"
                    class="w-full pl-14 pr-5 py-4 border-2 border-gray-300 rounded-lg outline-none text-gray-900 bg-white font-semibold text-lg focus:border-green-500 focus:ring-2 focus:ring-green-200 transition"
                    placeholder="Tìm kiếm tài liệu, văn bản, luận văn..."
            >
        </div>
    </div>
</section>

<section class="relative">
    <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=1200&q=80" alt="Library Banner" class="w-full h-64 object-cover">
    <div class="absolute inset-0 flex flex-col items-center justify-center bg-black bg-opacity-50">
        <h1 class="text-white text-3xl md:text-4xl font-bold mb-2 text-center">Khám phá thế giới qua từng trang sách</h1>
        <p class="text-white text-lg mb-4 text-center">Kiến thức và cảm hứng luôn chờ bạn.</p>
    </div>
</section>

<main class="max-w-7xl mx-auto px-6 py-10 flex flex-col lg:flex-row gap-8">

    <aside class="w-full lg:w-64 bg-white rounded-xl shadow p-4 flex-shrink-0 min-h-[400px]">
        <h2 class="font-bold text-xl mb-4 border-b pb-3">Chuyên mục</h2>
        <nav class="space-y-2">
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition font-semibold">
                Văn học
            </a>
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition">
                Lịch sử
            </a>
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition">
                Khoa học
            </a>
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition">
                Kinh doanh
            </a>
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition">
                Thiếu nhi
            </a>
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition">
                Hư cấu
            </a>
            <a href="#" class="block px-3 py-2 rounded-lg text-gray-700 hover:bg-green-100 hover:text-green-700 transition">
                Tâm lý
            </a>
        </nav>
    </aside>

    <section class="flex-1">
        <div class="flex items-center gap-4 mb-6">
            <select class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 bg-white focus:outline-none focus:ring-2 focus:ring-green-500">
                <option>Sắp xếp: Mới nhất</option>
                <option>Sắp xếp: Phổ biến</option>
            </select>
            <select class="border border-gray-300 rounded-lg px-3 py-2 text-gray-700 bg-white focus:outline-none focus:ring-2 focus:ring-green-500">
                <option>Hiển thị: 12 sách/trang</option>
                <option>Hiển thị: 24 sách/trang</option>
            </select>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-8">
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/10523338-L.jpg" alt="The Cosmic Key" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Chìa Khoá Vũ Trụ</div>
                    <div class="text-base text-gray-500 mb-2">Av Naney</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/10523339-L.jpg" alt="Echoes of the Past" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Dư âm quá khứ</div>
                    <div class="text-base text-gray-500 mb-2">Av Uzanny</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/10523340-L.jpg" alt="Echoes of the Past" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Dư âm quá khứ</div>
                    <div class="text-base text-gray-500 mb-2">Dr Naney</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/10523341-L.jpg" alt="Fiction" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Văn học</div>
                    <div class="text-base text-gray-500 mb-2">Dr Cetiny</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/8264783-L.jpg" alt="The Hobbit" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Anh Chàng Hobbit</div>
                    <div class="text-base text-gray-500 mb-2">J.R.R. Tolkien</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách giấy</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/12918882-L.jpg" alt="Sapiens" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Lược sử loài người</div>
                    <div class="text-base text-gray-500 mb-2">Yuval Noah Harari</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/10077181-L.jpg" alt="Pride and Prejudice" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Kiêu hãnh và định kiến</div>
                    <div class="text-base text-gray-500 mb-2">Jane Austen</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách giấy</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/11188384-L.jpg" alt="The Alchemist" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Nhà giả kim</div>
                    <div class="text-base text-gray-500 mb-2">Paulo Coelho</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/13139250-L.jpg" alt="Atomic Habits" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Thói quen nguyên tử</div>
                    <div class="text-base text-gray-500 mb-2">James Clear</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/9253907-L.jpg" alt="1984" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">1984</div>
                    <div class="text-base text-gray-500 mb-2">George Orwell</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách giấy</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/7882299-L.jpg" alt="To Kill a Mockingbird" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Giết con chim nhại</div>
                    <div class="text-base text-gray-500 mb-2">Harper Lee</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách điện tử</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden">
                <img src="https://covers.openlibrary.org/b/id/8313269-L.jpg" alt="The Great Gatsby" class="w-full h-52 object-cover">
                <div class="flex-1 flex flex-col px-5 py-4">
                    <div class="font-bold text-lg mb-1 text-gray-800">Đại gia Gatsby</div>
                    <div class="text-base text-gray-500 mb-2">F. Scott Fitzgerald</div>
                    <div class="flex items-center gap-2 text-sm text-gray-500 mb-4">
                        <i class="fas fa-book"></i>
                        <span>Sách giấy</span>
                    </div>
                    <div class="flex gap-3 mt-auto w-full">
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap border border-gray-300 text-gray-700 hover:bg-gray-100 transition">Chi tiết</button>
                        <button class="flex-1 px-1 py-2 rounded-lg font-semibold text-base whitespace-nowrap bg-green-600 text-white hover:bg-green-700 transition">Mượn sách</button>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

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

</body>
</html>