package com.quanlythuvien.dao;

import com.quanlythuvien.db.DBConnect;
import java.sql.*;
import java.util.*;

public class AuthorDAO {
    private Connection conn;

    public AuthorDAO() {
        this.conn = DBConnect.getConnection();
    }

    // Lấy tất cả tác giả
    public Map<Integer, String> getAllAuthors() {
        Map<Integer, String> authors = new LinkedHashMap<>();
        String sql = "SELECT MaTG, TenTG FROM TACGIA ORDER BY TenTG";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                authors.put(rs.getInt("MaTG"), rs.getString("TenTG"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return authors;
    }

    // Lấy ID tác giả theo tên (không phân biệt hoa thường)
    public Integer getAuthorIdByName(String tenTG) {
        String sql = "SELECT MaTG FROM TACGIA WHERE LOWER(TRIM(TenTG)) = LOWER(TRIM(?))";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tenTG);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("MaTG");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm tác giả mới nếu chưa tồn tại
    public int addAuthorIfNotExists(String tenTG) {
        if (tenTG == null || tenTG.trim().isEmpty()) {
            return -1;
        }

        // Kiểm tra đã tồn tại chưa
        Integer existingId = getAuthorIdByName(tenTG);
        if (existingId != null) {
            return existingId;
        }

        // Thêm mới
        String sql = "INSERT INTO TACGIA (TenTG) VALUES (?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, tenTG.trim());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    // Thêm quan hệ sách-tác giả
    public boolean addBookAuthor(int maSach, int maTG) {
        String sql = "INSERT INTO SACH_TACGIA (MaSach, MaTG) VALUES (?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            ps.setInt(2, maTG);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Bỏ qua lỗi duplicate key
            if (!e.getMessage().contains("Duplicate entry")) {
                e.printStackTrace();
            }
            return false;
        }
    }

    // Xóa tất cả tác giả của một cuốn sách
    public boolean deleteAllAuthorsBySachId(int maSach) {
        String sql = "DELETE FROM SACH_TACGIA WHERE MaSach = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách ID tác giả của một cuốn sách
    public List<Integer> getAuthorIdsBySachId(int maSach) {
        List<Integer> authorIds = new ArrayList<>();
        String sql = "SELECT MaTG FROM SACH_TACGIA WHERE MaSach = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                authorIds.add(rs.getInt("MaTG"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return authorIds;
    }
}
