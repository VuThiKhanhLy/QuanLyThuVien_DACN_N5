<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý thông tin cá nhân - LibSys</title>
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
    <main class="max-w-2xl mx-auto bg-white rounded-xl shadow p-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">Quản lý thông tin cá nhân</h2>
        <form id="userInfoForm" class="space-y-5" autocomplete="off">
            <div>
                <label class="block font-semibold mb-1" for="studentName">Tên sinh viên</label>
                <input type="text" id="studentName" name="studentName"
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-400"
                    required>
            </div>
            <div>
                <label class="block font-semibold mb-1" for="dob">Ngày sinh</label>
                <input type="date" id="dob" name="dob"
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-400"
                    required>
            </div>
            <div>
                <label class="block font-semibold mb-1">Giới tính</label>
                <div class="flex gap-6">
                    <label class="flex items-center">
                        <input type="radio" name="gender" value="Nam" class="mr-2" required> Nam
                    </label>
                    <label class="flex items-center">
                        <input type="radio" name="gender" value="Nữ" class="mr-2"> Nữ
                    </label>
                    <label class="flex items-center">
                        <input type="radio" name="gender" value="Khác" class="mr-2"> Khác
                    </label>
                </div>
            </div>
            <div>
                <label class="block font-semibold mb-1" for="address">Địa chỉ</label>
                <input type="text" id="address" name="address"
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-400"
                    required>
            </div>
            <div>
                <label class="block font-semibold mb-1" for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phone"
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-400"
                    required pattern="0[0-9]{9,10}">
            </div>
            <div>
                <label class="block font-semibold mb-1" for="email">Email</label>
                <input type="email" id="email" name="email"
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-400"
                    required>
            </div>
            <div class="flex justify-end gap-4 pt-4">
                <button type="reset"
                    class="px-6 py-2 rounded-lg bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold transition">Nhập
                    lại</button>
                <button type="submit"
                    class="px-6 py-2 rounded-lg bg-green-600 hover:bg-green-700 text-white font-semibold transition">Lưu
                    thông tin</button>
            </div>
        </form>
        <div id="successMsg" class="hidden mt-6 text-green-600 text-center font-semibold">
            Cập nhật thông tin thành công!
        </div>
    </main>
    <script>
        // Load user info from localStorage nếu có
        window.addEventListener('DOMContentLoaded', () => {
            const info = JSON.parse(localStorage.getItem('userInfo') || '{}');
            if (info.studentName) document.getElementById('studentName').value = info.studentName;
            if (info.dob) document.getElementById('dob').value = info.dob;
            if (info.gender) {
                document.querySelectorAll('input[name="gender"]').forEach(r => {
                    if (r.value === info.gender) r.checked = true;
                });
            }
            if (info.address) document.getElementById('address').value = info.address;
            if (info.phone) document.getElementById('phone').value = info.phone;
            if (info.email) document.getElementById('email').value = info.email;
        });

        // Lưu thông tin khi submit
        document.getElementById('userInfoForm').addEventListener('submit', function (e) {
            e.preventDefault();
            const info = {
                studentName: document.getElementById('studentName').value,
                dob: document.getElementById('dob').value,
                gender: document.querySelector('input[name="gender"]:checked')?.value || '',
                address: document.getElementById('address').value,
                phone: document.getElementById('phone').value,
                email: document.getElementById('email').value
            };
            localStorage.setItem('userInfo', JSON.stringify(info));
            document.getElementById('successMsg').classList.remove('hidden');
            setTimeout(() => {
                document.getElementById('successMsg').classList.add('hidden');
            }, 2000);
        });
    </script>
</body>

</html>