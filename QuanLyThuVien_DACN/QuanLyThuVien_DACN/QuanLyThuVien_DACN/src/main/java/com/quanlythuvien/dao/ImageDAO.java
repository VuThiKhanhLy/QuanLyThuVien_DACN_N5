package com.quanlythuvien.dao;
import com.quanlythuvien.db.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ImageDAO {
    private Connection conn;

    public ImageDAO() {
        this.conn = DBConnect.getConnection();
    }

    // Thêm ảnh mới
    public int addImage(String duongLinkAnh, int maSach) {
        String sql = "INSERT INTO HINHANH (DuongLinkAnh, MaSach) VALUES (?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, duongLinkAnh);
            ps.setInt(2, maSach);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Trả về MaAnh vừa tạo
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    // Lấy ảnh chính của sách (ảnh đầu tiên)
    public String getMainImageBySachId(int maSach) {
        String sql = "SELECT DuongLinkAnh FROM HINHANH WHERE MaSach = ? ORDER BY MaAnh ASC LIMIT 1";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("DuongLinkAnh");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Lấy tất cả ảnh của sách
    public List<String> getAllImagesBySachId(int maSach) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT DuongLinkAnh FROM HINHANH WHERE MaSach = ? ORDER BY MaAnh ASC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                images.add(rs.getString("DuongLinkAnh"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return images;
    }

    // Cập nhật ảnh
    public boolean updateImage(int maAnh, String duongLinkAnh) {
        String sql = "UPDATE HINHANH SET DuongLinkAnh = ? WHERE MaAnh = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, duongLinkAnh);
            ps.setInt(2, maAnh);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa ảnh theo mã ảnh
    public boolean deleteImage(int maAnh) {
        String sql = "DELETE FROM HINHANH WHERE MaAnh = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maAnh);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa tất cả ảnh của sách
    public boolean deleteAllImagesBySachId(int maSach) {
        String sql = "DELETE FROM HINHANH WHERE MaSach = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm số ảnh của sách
    public int countImagesBySachId(int maSach) {
        String sql = "SELECT COUNT(*) as total FROM HINHANH WHERE MaSach = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maSach);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}