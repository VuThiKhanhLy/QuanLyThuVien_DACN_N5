package com.quanlythuvien.servlet;

import com.quanlythuvien.dao.StudentDAO;
import com.quanlythuvien.model.Student;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // **************** [LOGIC ĐÃ SỬA: PHÂN BIỆT VIEW VÀ API] ****************
        if (action == null || action.isEmpty()) {
            // Khi không có action (truy cập trang lần đầu), chuyển hướng đến JSP (VIEW).
            request.getRequestDispatcher("/QuanLySinhVien.jsp").forward(request, response);
            return;
        }
        // ************************************************************************

        // Logic API (Trả về JSON) - Khi có tham số action
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            if (action.equals("getAll")) {
                List<Student> list = studentDAO.getAllStudents();
                out.print(gson.toJson(list));

            } else if (action.equals("getById")) {
                int maSV = Integer.parseInt(request.getParameter("maSV"));
                Student student = studentDAO.getStudentById(maSV);
                out.print(gson.toJson(student));

            } else if (action.equals("search")) {
                String keyword = request.getParameter("keyword");
                List<Student> list = studentDAO.searchStudents(keyword);
                out.print(gson.toJson(list));

            } else if (action.equals("filterByStatus")) {
                String status = request.getParameter("status");
                List<Student> list = studentDAO.filterByCardStatus(status);
                out.print(gson.toJson(list));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();

        try {
            if (action.equals("add")) {
                Student student = new Student();
                student.setTenSV(request.getParameter("tenSV"));
                student.setNgaySinh(Date.valueOf(request.getParameter("ngaySinh")));
                student.setGioiTinh(request.getParameter("gioiTinh"));
                student.setDiaChi(request.getParameter("diaChi"));
                student.setSoDienThoai(request.getParameter("soDienThoai"));
                student.setEmail(request.getParameter("email"));

                Date ngayDK = Date.valueOf(request.getParameter("ngayDKThe"));
                student.setNgayDKThe(ngayDK);

                Calendar cal = Calendar.getInstance();
                cal.setTime(ngayDK);
                cal.add(Calendar.YEAR, 4);
                student.setNgayHHThe(new Date(cal.getTimeInMillis()));

                boolean success = studentDAO.addStudent(student);
                out.print("{\"success\": " + success + "}");

            } else if (action.equals("update")) {
                Student student = new Student();
                student.setMaSV(Integer.parseInt(request.getParameter("maSV")));
                student.setTenSV(request.getParameter("tenSV"));
                student.setNgaySinh(Date.valueOf(request.getParameter("ngaySinh")));
                student.setGioiTinh(request.getParameter("gioiTinh"));
                student.setDiaChi(request.getParameter("diaChi"));
                student.setSoDienThoai(request.getParameter("soDienThoai"));
                student.setEmail(request.getParameter("email"));

                Date ngayDK = Date.valueOf(request.getParameter("ngayDKThe"));
                student.setNgayDKThe(ngayDK);

                Calendar cal = Calendar.getInstance();
                cal.setTime(ngayDK);
                cal.add(Calendar.YEAR, 4);
                student.setNgayHHThe(new Date(cal.getTimeInMillis()));

                boolean success = studentDAO.updateStudent(student);
                out.print("{\"success\": " + success + "}");

            } else if (action.equals("renewCard")) {
                int maSV = Integer.parseInt(request.getParameter("maSV"));
                Date ngayDKMoi = new Date(System.currentTimeMillis());

                Calendar cal = Calendar.getInstance();
                cal.setTime(ngayDKMoi);
                cal.add(Calendar.YEAR, 4);
                Date ngayHHMoi = new Date(cal.getTimeInMillis());

                boolean success = studentDAO.renewCard(maSV, ngayDKMoi, ngayHHMoi);
                out.print("{\"success\": " + success + ", \"ngayHH\": \"" + ngayHHMoi + "\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        int maSV = Integer.parseInt(request.getParameter("maSV"));
        PrintWriter out = response.getWriter();

        try {
            boolean success = studentDAO.deleteStudent(maSV);
            out.print("{\"success\": " + success + "}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}