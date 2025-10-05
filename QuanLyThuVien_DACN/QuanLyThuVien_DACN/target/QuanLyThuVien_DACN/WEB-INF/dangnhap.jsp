<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng nhập - LibSys</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

  <form action="login" method="post" class="bg-white shadow-lg rounded-xl p-8 w-96">
    <h2 class="text-2xl font-bold text-center text-green-600 mb-6">Đăng nhập hệ thống</h2>

    <div class="mb-4">
      <label class="block text-gray-700 mb-2">Tên đăng nhập</label>
      <input type="text" name="username" required
             class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
    </div>

    <div class="mb-6">
      <label class="block text-gray-700 mb-2">Mật khẩu</label>
      <input type="password" name="password" required
             class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
    </div>

    <button type="submit"
            class="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-2 rounded-lg transition">
      Đăng nhập
    </button>
  </form>

</body>
</html>
