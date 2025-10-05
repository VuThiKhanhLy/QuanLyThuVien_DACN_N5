package com.quanlythuvien.servlet;

import com.quanlythuvien.dao.TaiKhoanDAO;
import com.quanlythuvien.model.TaiKhoan;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/loginStudent")
public class StudentLoginServlet extends HttpServlet {

    private TaiKhoanDAO taiKhoanDAO = new TaiKhoanDAO();
    private static final String LOGIN_PAGE = "/Signin.jsp";

    // ĐÃ CẬP NHẬT: Chuyển hướng đến Servlet mới dành cho sinh viên
    private static final String SUCCESS_REDIRECT_HOME = "/student/home";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");

        if (tenDangNhap == null || matKhau == null || tenDangNhap.isEmpty() || matKhau.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
            dispatcher.forward(request, response);
            return;
        }

        // GIẢ ĐỊNH: checkStudentLogin(tenDangNhap, matKhau) đã được TaiKhoanDAO.java định nghĩa
        // và chỉ trả về TaiKhoan nếu VaiTro = 'SINHVIEN'
        TaiKhoan taiKhoan = taiKhoanDAO.checkStudentLogin(tenDangNhap, matKhau);

        if (taiKhoan != null) {

            // Đăng nhập THÀNH CÔNG
            HttpSession session = request.getSession();
            session.setAttribute("loggedInAccount", taiKhoan);

            // Cờ này không còn cần thiết nếu dùng HomePageForStudentServlet.java
            // Nhưng có thể giữ lại nếu bạn vẫn muốn dùng nó để kiểm tra trong UserPage.jsp
            session.setAttribute("isStudent", true);

            // ĐÃ CẬP NHẬT: Chuyển hướng đến HomePageForStudentServlet để tải dữ liệu và hiển thị UserPage.jsp
            response.sendRedirect(request.getContextPath() + SUCCESS_REDIRECT_HOME);

        } else {

            // Đăng nhập THẤT BẠI
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng, hoặc bạn không có quyền Sinh viên.");
            RequestDispatcher dispatcher = request.getRequestDispatcher(LOGIN_PAGE);
            dispatcher.forward(request, response);
        }
    }
}