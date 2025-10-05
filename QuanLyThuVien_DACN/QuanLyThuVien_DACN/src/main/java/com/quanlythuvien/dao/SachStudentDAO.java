package com.quanlythuvien.dao;

import com.quanlythuvien.db.DBConnect;
import com.quanlythuvien.model.Sach;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SachStudentDAO {

    private Connection getConnection() throws SQLException {
        return DBConnect.getConnection();
    }

    private static class Pair<A, B> {
        private final A first;
        private final B second;

        public Pair(A first, B second) {
            this.first = first;
            this.second = second;
        }

        public A getFirst() { return first; }
        public B getSecond() { return second; }
    }

    private Pair<String, List<Object>> buildWhereClause(String category, String search) {
        StringBuilder whereClause = new StringBuilder(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.equalsIgnoreCase("all") && !category.isEmpty()) {
            whereClause.append(" AND tl.tenTheLoai = ? ");
            params.add(category);
        }

        if (search != null && !search.trim().isEmpty()) {
            // Đã sửa: Dùng tg.tenTacGia
            whereClause.append(" AND (s.tenSach LIKE ? OR tg.tenTacGia LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        return new Pair<>(whereClause.toString(), params);
    }

    private String buildOrderByClause(String sortBy) {
        if (sortBy != null) {
            switch (sortBy.toLowerCase()) {
                case "popular":
                    return " ORDER BY s.soLuotMuon DESC ";
                case "oldest":
                    return " ORDER BY s.namXuatBan ASC ";
                default:
                    return " ORDER BY s.maSach DESC ";
            }
        }
        return " ORDER BY s.maSach DESC ";
    }

    private Sach mapResultSetToSach(ResultSet rs) throws SQLException {
        Sach sach = new Sach();
        sach.setMaSach(rs.getInt("maSach"));
        sach.setTenSach(rs.getString("tenSach"));
        sach.setNamXuatBan(rs.getInt("namXuatBan"));
        sach.setSoTrang(rs.getInt("soTrang"));
        sach.setMaNXB(rs.getInt("maNXB"));
        sach.setMaTheLoai(rs.getInt("maTheLoai"));
        sach.setMoTa(rs.getString("moTa"));
        sach.setGiaTien(rs.getDouble("giaTien"));

        sach.setTenTheLoai(rs.getString("tenTheLoai"));
        sach.setTenTacGia(rs.getString("tenTacGia"));
        sach.setImage(rs.getString("image"));

        return sach;
    }

    public int getTotalBooks(String search, String category) {
        int count = 0;

        Pair<String, List<Object>> filter = buildWhereClause(category, search);
        String whereClause = filter.getFirst();

        String sql = "SELECT COUNT(s.maSach) AS total " +
                "FROM sach s " +
                // Đã sửa: Dùng s.maTheLoai và tl.maTheLoai (camelCase)
                "JOIN theloai tl ON s.maTheLoai = tl.maTheLoai " +
                // Đã sửa: Dùng s.maTacGia và tg.maTacGia (camelCase)
                "JOIN tacgia tg ON s.maTacGia = tg.maTacGia " +
                whereClause;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            List<Object> params = filter.getSecond();
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Sach> getFilteredBooks(int offset, int limit, String sortBy, String search, String category) {
        List<Sach> listSach = new ArrayList<>();

        Pair<String, List<Object>> filter = buildWhereClause(category, search);
        String whereClause = filter.getFirst();
        String orderByClause = buildOrderByClause(sortBy);

        // Đã sửa: Dùng tg.tenTacGia AS tenTacGia
        String sql = "SELECT s.*, tl.tenTheLoai, tg.tenTacGia AS tenTacGia, s.DuongLinkAnh AS image " +
                "FROM sach s " +
                // Đã sửa: Dùng s.maTheLoai và tl.maTheLoai (camelCase)
                "JOIN theloai tl ON s.maTheLoai = tl.maTheLoai " +
                // Đã sửa: Dùng s.maTacGia và tg.maTacGia (camelCase)
                "JOIN tacgia tg ON s.maTacGia = tg.maTacGia " +
                whereClause +
                orderByClause +
                " LIMIT ? OFFSET ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            List<Object> params = filter.getSecond();
            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }

            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listSach.add(mapResultSetToSach(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listSach;
    }
}