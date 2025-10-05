package com.quanlythuvien.servlet;

import com.quanlythuvien.dao.SachStudentDAO; // <-- SỬA: Đã đổi tên từ SachDAO thành SachStudentDAO
import com.quanlythuvien.dao.TaiKhoanDAO;
import com.quanlythuvien.model.Sach;
import com.quanlythuvien.model.TaiKhoan;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet này xử lý logic tải dữ liệu và hiển thị trang chủ cho Sinh viên đã đăng nhập.
 * URL: /student/home
 */
@WebServlet(name = "HomePageForStudentServlet", urlPatterns = {"/student/home"})
public class HomePageForStudentServlet extends HttpServlet {

    private static final int DEFAULT_BOOKS_PER_PAGE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ========================== 1. KIỂM TRA BẢO MẬT (SESSION) ==========================
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedInAccount") == null) {
            response.sendRedirect(request.getContextPath() + "/Signin.jsp");
            return;
        }

        TaiKhoan taiKhoan = (TaiKhoan) session.getAttribute("loggedInAccount");

        // LƯU Ý: Đảm bảo TaiKhoanDAO.VAI_TRO_SINHVIEN chứa giá trị đúng như trong CSDL ("Sinh viên")
        if (!TaiKhoanDAO.VAI_TRO_SINHVIEN.equalsIgnoreCase(taiKhoan.getVaiTro())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // KHỞI TẠO VỚI TÊN DAO MỚI
            SachStudentDAO sachDAO = new SachStudentDAO();

            // ========================== 2. Xử lý Tham số Lọc/Tìm kiếm (VÀ CHUẨN HÓA) ==========================
            String category = request.getParameter("category");
            String search = request.getParameter("search");
            String sortBy = request.getParameter("sortBy");

            // Chuẩn hóa tham số để tránh lỗi NullPointerException trong DAO
            category = (category == null || category.isEmpty()) ? "all" : category;
            search = (search == null) ? "" : search;


            // ========================== 3. Xử lý Phân trang (Pagination) ==========================
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && pageParam.matches("\\d+")) {
                currentPage = Integer.parseInt(pageParam);
            }

            int booksPerPage = DEFAULT_BOOKS_PER_PAGE;
            String limitParam = request.getParameter("limit");
            if (limitParam != null && limitParam.matches("\\d+")) {
                booksPerPage = Integer.parseInt(limitParam);
            }

            // ========================== 4. Lấy Tổng số sách và Tính Tổng số trang ==========================
            // Truyền tham số đã được chuẩn hóa
            int totalBooks = sachDAO.getTotalBooks(search, category);
            int totalPages = (int) Math.ceil((double) totalBooks / booksPerPage);

            if (totalPages > 0 && currentPage > totalPages) {
                currentPage = totalPages;
            }
            if (totalBooks == 0) {
                totalPages = 0;
            }

            int offset = (currentPage - 1) * booksPerPage;

            // ========================== 5. Lấy danh sách sách đã được lọc/phân trang ==========================
            List<Sach> listSach = sachDAO.getFilteredBooks(offset, booksPerPage, sortBy, search, category);


            // ========================== 6. Đặt dữ liệu vào Request Scope ==========================
            request.setAttribute("listSach", listSach);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            // Đặt các tham số đã chuẩn hóa/nhận được vào request scope để JSP sử dụng
            request.setAttribute("paramCategory", category);
            request.setAttribute("paramSearch", search);
            request.setAttribute("paramSortBy", sortBy);
            request.setAttribute("paramLimit", String.valueOf(booksPerPage));

            // ========================== 7. Chuyển tiếp (FORWARD) đến UserPage.jsp ==========================
            RequestDispatcher dispatcher = request.getRequestDispatcher("/UserPage.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}