package com.quanlythuvien.dao;

import com.quanlythuvien.db.DBConnect;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import java.sql.*;

public class ReportDAO {

    // ====================== THỐNG KÊ TỔNG QUAN ======================
    public JsonObject getSummaryStats() {
        JsonObject json = new JsonObject();

        try (Connection conn = DBConnect.getConnection()) {
            System.out.println("=== Đang l// ====================== XUẤT BÁO CÁO PDF & WORD ======================\n" +
                    "\n" +
                    "import com.itextpdf.text.*;\n" +
                    "import com.itextpdf.text.pdf.*;\n" +
                    "import org.apache.poi.xwpf.usermodel.*;\n" +
                    "\n" +
                    "import java.io.OutputStream;\n" +
                    "\n" +
                    "public void exportToPDF(OutputStream out) throws Exception {\n" +
                    "    Document document = new Document();\n" +
                    "    PdfWriter.getInstance(document, out);\n" +
                    "    document.open();\n" +
                    "\n" +
                    "    // ======= Tiêu đề =======\n" +
                    "    Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLUE);\n" +
                    "    Paragraph title = new Paragraph(\"BÁO CÁO HOẠT ĐỘNG THƯ VIỆN\", titleFont);\n" +
                    "    title.setAlignment(Element.ALIGN_CENTER);\n" +
                    "    document.add(title);\n" +
                    "    document.add(new Paragraph(\" \"));\n" +
                    "\n" +
                    "    // ======= Nội dung thống kê =======\n" +
                    "    JsonObject stats = getSummaryStats();\n" +
                    "    Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);\n" +
                    "\n" +
                    "    document.add(new Paragraph(\"\uD83D\uDCD8 Tổng phiếu mượn: \" + stats.get(\"totalBorrows\").getAsInt(), normalFont));\n" +
                    "    document.add(new Paragraph(\"\uD83D\uDCD7 Tổng phiếu trả: \" + stats.get(\"totalReturns\").getAsInt(), normalFont));\n" +
                    "    document.add(new Paragraph(\"\uD83D\uDCD9 Sách đang được mượn: \" + stats.get(\"activeBooks\").getAsInt(), normalFont));\n" +
                    "    document.add(new Paragraph(\"\uD83D\uDCD5 Sách quá hạn: \" + stats.get(\"overdueCount\").getAsInt(), normalFont));\n" +
                    "\n" +
                    "    document.add(new Paragraph(\" \"));\n" +
                    "    document.add(new Paragraph(\"Thống kê theo thể loại:\", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));\n" +
                    "\n" +
                    "    JsonObject genres = getGenreDistribution();\n" +
                    "    for (String key : genres.keySet()) {\n" +
                    "        document.add(new Paragraph(\" - \" + key + \": \" + genres.get(key).getAsInt() + \" lượt mượn\", normalFont));\n" +
                    "    }\n" +
                    "\n" +
                    "    document.close();\n" +
                    "}\n" +
                    "\n" +
                    "public void exportToWord(OutputStream out) throws Exception {\n" +
                    "    XWPFDocument doc = new XWPFDocument();\n" +
                    "\n" +
                    "    // ======= Tiêu đề =======\n" +
                    "    XWPFParagraph title = doc.createParagraph();\n" +
                    "    title.setAlignment(ParagraphAlignment.CENTER);\n" +
                    "    XWPFRun runTitle = title.createRun();\n" +
                    "    runTitle.setText(\"BÁO CÁO HOẠT ĐỘNG THƯ VIỆN\");\n" +
                    "    runTitle.setBold(true);\n" +
                    "    runTitle.setFontSize(18);\n" +
                    "    runTitle.setColor(\"0033CC\");\n" +
                    "\n" +
                    "    // ======= Nội dung =======\n" +
                    "    JsonObject stats = getSummaryStats();\n" +
                    "    XWPFParagraph p = doc.createParagraph();\n" +
                    "    XWPFRun run = p.createRun();\n" +
                    "    run.setFontSize(12);\n" +
                    "\n" +
                    "    run.setText(\"\uD83D\uDCD8 Tổng phiếu mượn: \" + stats.get(\"totalBorrows\").getAsInt());\n" +
                    "    run.addBreak();\n" +
                    "    run.setText(\"\uD83D\uDCD7 Tổng phiếu trả: \" + stats.get(\"totalReturns\").getAsInt());\n" +
                    "    run.addBreak();\n" +
                    "    run.setText(\"\uD83D\uDCD9 Sách đang được mượn: \" + stats.get(\"activeBooks\").getAsInt());\n" +
                    "    run.addBreak();\n" +
                    "    run.setText(\"\uD83D\uDCD5 Sách quá hạn: \" + stats.get(\"overdueCount\").getAsInt());\n" +
                    "    run.addBreak();\n" +
                    "    run.addBreak();\n" +
                    "\n" +
                    "    run.setBold(true);\n" +
                    "    run.setText(\"Thống kê theo thể loại:\");\n" +
                    "    run.addBreak();\n" +
                    "    run.setBold(false);\n" +
                    "\n" +
                    "    JsonObject genres = getGenreDistribution();\n" +
                    "    for (String key : genres.keySet()) {\n" +
                    "        run.setText(\" - \" + key + \": \" + genres.get(key).getAsInt() + \" lượt mượn\");\n" +
                    "        run.addBreak();\n" +
                    "    }\n" +
                    "\n" +
                    "    doc.write(out);\n" +
                    "    doc.close();\n" +
                    "}\noad Summary Stats ===");

            // Tổng phiếu mượn
            String sqlTotalBorrow = "SELECT COUNT(*) FROM PHIEUMUON";
            int totalBorrows = countQuery(conn, sqlTotalBorrow);
            json.addProperty("totalBorrows", totalBorrows);

            // Tổng phiếu trả
            String sqlTotalReturn = "SELECT COUNT(*) FROM PHIEUTRA";
            int totalReturns = countQuery(conn, sqlTotalReturn);
            json.addProperty("totalReturns", totalReturns);

            // Sách đang được mượn
            String sqlActiveBooks = """
                    SELECT COALESCE(SUM(ct.SoLuongMuon), 0)
                    FROM CHITIETPHIEUMUON ct
                    JOIN PHIEUMUON pm ON ct.MaPhieuMuon = pm.MaPhieuMuon
                    WHERE pm.TrangThai = 'Đang mượn'
                    """;
            int activeBooks = countQuery(conn, sqlActiveBooks);
            json.addProperty("activeBooks", activeBooks);

            // Sách quá hạn
            String sqlOverdue = """
                    SELECT COUNT(*)
                    FROM PHIEUMUON
                    WHERE TrangThai = 'Đang mượn' AND HanTra < CURDATE()
                    """;
            int overdueCount = countQuery(conn, sqlOverdue);
            json.addProperty("overdueCount", overdueCount);

            System.out.println("✅ Summary Stats: " + json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Lỗi trong getSummaryStats: " + e.getMessage());
            json.addProperty("totalBorrows", 0);
            json.addProperty("totalReturns", 0);
            json.addProperty("activeBooks", 0);
            json.addProperty("overdueCount", 0);
        }
        return json;
    }

    private int countQuery(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ====================== TOP SÁCH ĐƯỢC MƯỢN ======================
    public JsonArray getTopBooks(int limit) {
        JsonArray arr = new JsonArray();
        String sql = """
                SELECT s.MaSach AS maSach,
                       s.TenSach AS tenSach,
                       COALESCE(tl.TenTheLoai, 'Chưa phân loại') AS theLoai,
                       COUNT(ct.MaPhieuMuon) AS soLanMuon,
                       SUM(CASE WHEN pm.TrangThai = 'Đang mượn' THEN 1 ELSE 0 END) AS dangMuon
                FROM SACH s
                LEFT JOIN THELOAI tl ON s.MaTheLoai = tl.MaTheLoai
                LEFT JOIN CHITIETPHIEUMUON ct ON s.MaSach = ct.MaSach
                LEFT JOIN PHIEUMUON pm ON ct.MaPhieuMuon = pm.MaPhieuMuon
                GROUP BY s.MaSach, s.TenSach, tl.TenTheLoai
                HAVING soLanMuon > 0
                ORDER BY soLanMuon DESC
                LIMIT ?
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                JsonObject obj = new JsonObject();
                obj.addProperty("maSach", rs.getInt("maSach"));
                obj.addProperty("tenSach", rs.getString("tenSach"));
                obj.addProperty("theLoai", rs.getString("theLoai"));
                obj.addProperty("soLanMuon", rs.getInt("soLanMuon"));
                obj.addProperty("dangMuon", rs.getInt("dangMuon"));
                arr.add(obj);
            }

            System.out.println("✅ Top Books loaded: " + arr.size() + " items");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Lỗi trong getTopBooks: " + e.getMessage());
        }
        return arr;
    }

    // ====================== TOP SINH VIÊN ======================
    public JsonArray getTopStudents(int limit) {
        JsonArray arr = new JsonArray();
        String sql = """
                SELECT sv.MaSV AS maSV,
                       sv.TenSV AS tenSV,
                       COUNT(pm.MaPhieuMuon) AS tongMuon,
                       SUM(CASE WHEN pm.TrangThai = 'Đã trả' THEN 1 ELSE 0 END) AS daTra,
                       SUM(CASE WHEN pm.TrangThai = 'Đang mượn' THEN 1 ELSE 0 END) AS dangMuon,
                       SUM(CASE WHEN pm.TrangThai = 'Đang mượn' AND pm.HanTra < CURDATE() THEN 1 ELSE 0 END) AS quaHan
                FROM SINHVIEN sv
                LEFT JOIN PHIEUMUON pm ON sv.MaSV = pm.MaSV
                GROUP BY sv.MaSV, sv.TenSV
                HAVING tongMuon > 0
                ORDER BY tongMuon DESC
                LIMIT ?
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                JsonObject obj = new JsonObject();
                obj.addProperty("maSV", rs.getInt("maSV"));
                obj.addProperty("tenSV", rs.getString("tenSV"));
                obj.addProperty("tongMuon", rs.getInt("tongMuon"));
                obj.addProperty("daTra", rs.getInt("daTra"));
                obj.addProperty("dangMuon", rs.getInt("dangMuon"));
                obj.addProperty("quaHan", rs.getInt("quaHan"));
                arr.add(obj);
            }

            System.out.println("✅ Top Students loaded: " + arr.size() + " items");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Lỗi trong getTopStudents: " + e.getMessage());
        }
        return arr;
    }

    // ====================== SÁCH QUÁ HẠN ======================
    public JsonArray getOverdueBooks() {
        JsonArray arr = new JsonArray();
        String sql = """
                SELECT pm.MaPhieuMuon AS maPhieu,
                       sv.MaSV AS maSV,
                       sv.TenSV AS tenSV,
                       s.MaSach AS maSach,
                       s.TenSach AS tenSach,
                       pm.NgayMuon AS ngayMuon,
                       pm.HanTra AS ngayHenTra,
                       DATEDIFF(CURDATE(), pm.HanTra) AS soNgayTre
                FROM PHIEUMUON pm
                JOIN CHITIETPHIEUMUON ct ON pm.MaPhieuMuon = ct.MaPhieuMuon
                JOIN SACH s ON ct.MaSach = s.MaSach
                JOIN SINHVIEN sv ON pm.MaSV = sv.MaSV
                WHERE pm.TrangThai = 'Đang mượn' AND pm.HanTra < CURDATE()
                ORDER BY soNgayTre DESC
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JsonObject obj = new JsonObject();
                obj.addProperty("maPhieu", rs.getInt("maPhieu"));
                obj.addProperty("maSV", rs.getInt("maSV"));
                obj.addProperty("tenSV", rs.getString("tenSV"));
                obj.addProperty("maSach", rs.getInt("maSach"));
                obj.addProperty("tenSach", rs.getString("tenSach"));
                obj.addProperty("ngayMuon", rs.getString("ngayMuon"));
                obj.addProperty("ngayHenTra", rs.getString("ngayHenTra"));
                obj.addProperty("soNgayTre", rs.getInt("soNgayTre"));
                arr.add(obj);
            }

            System.out.println("✅ Overdue Books loaded: " + arr.size() + " items");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Lỗi trong getOverdueBooks: " + e.getMessage());
        }
        return arr;
    }

    // ====================== PHÂN BỐ THEO THỂ LOẠI ======================
    public JsonObject getGenreDistribution() {
        JsonObject json = new JsonObject();
        String sql = """
                SELECT COALESCE(tl.TenTheLoai, 'Chưa phân loại') AS theLoai,
                       COUNT(ct.MaPhieuMuon) AS soLanMuon
                FROM CHITIETPHIEUMUON ct
                JOIN SACH s ON ct.MaSach = s.MaSach
                LEFT JOIN THELOAI tl ON s.MaTheLoai = tl.MaTheLoai
                GROUP BY tl.TenTheLoai
                ORDER BY soLanMuon DESC
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                json.addProperty(rs.getString("theLoai"), rs.getInt("soLanMuon"));
            }

            System.out.println("✅ Genre Distribution loaded: " + json.size() + " items");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Lỗi trong getGenreDistribution: " + e.getMessage());
        }
        return json;
    }
}
