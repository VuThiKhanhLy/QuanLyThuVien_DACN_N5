<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Lịch sử mượn sách - LibSys</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="Anh/logo.png" sizes="512x512">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>

<body class="bg-gray-100 text-gray-800 min-h-screen">
    <header class="bg-white shadow-sm mb-8">
        <div class="max-w-4xl mx-auto flex items-center justify-between px-6 py-4">
            <div class="flex items-center gap-3">
                <img src="Anh/logo.png" alt="LibSys Logo" class="w-10 h-10 rounded-full shadow">
                <span class="text-xl font-bold text-gray-800">LibSys</span>
            </div>
            <a href="UserPage.html" class="text-green-600 hover:text-green-800 font-semibold transition">Quay lại trang
                chính</a>
        </div>
    </header>
    <main class="max-w-3xl mx-auto bg-white rounded-xl shadow p-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">Lịch sử mượn sách</h2>
        <div id="historyList">
            <!-- Lịch sử mượn sách sẽ được hiển thị ở đây -->
        </div>
    </main>
    <script>
        // Lấy lịch sử mượn sách từ localStorage
        const history = JSON.parse(localStorage.getItem('borrowHistory') || '[]');

        function renderHistory() {
            const container = document.getElementById('historyList');
            if (history.length === 0) {
                container.innerHTML = `
                <div class="text-center text-gray-500 py-12">
                    <i class="fas fa-book-open text-4xl mb-4"></i>
                    <p>Bạn chưa mượn cuốn sách nào.</p>
                </div>
            `;
                return;
            }
            container.innerHTML = `
            <div class="overflow-x-auto">
                <table class="min-w-full border rounded-lg overflow-hidden text-center">
                    <thead class="bg-green-100 text-green-800">
                        <tr>
                            <th class="py-3 px-2 w-1/3">Tên sách</th>
                            <th class="py-3 px-2 w-1/5">Tác giả</th>
                            <th class="py-3 px-2 w-1/5">Ngày mượn</th>
                            <th class="py-3 px-2 w-1/5">Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${history.map(item => `
                            <tr class="border-b align-middle">
                                <td class="py-2 px-2 flex items-center gap-2 justify-center">
                                    <img src="${item.image}" alt="${item.title}" class="w-10 h-14 object-cover rounded shadow">
                                    <span class="text-left">${item.title}</span>
                                </td>
                                <td class="py-2 px-2 align-middle">${item.author}</td>
                                <td class="py-2 px-2 align-middle">${item.date}</td>
                                <td class="py-2 px-2 align-middle">
    <span class="inline-block px-3 py-1 rounded-full bg-blue-200 text-blue-800 text-xs font-semibold">Đang mượn</span>
</td>   
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        `;
        }

        renderHistory();
    </script>
</body>

</html>