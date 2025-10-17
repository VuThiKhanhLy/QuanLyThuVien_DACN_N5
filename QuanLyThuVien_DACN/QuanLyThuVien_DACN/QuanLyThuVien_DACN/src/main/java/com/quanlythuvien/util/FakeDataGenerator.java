package com.quanlythuvien.util;

import com.github.javafaker.Faker;
import com.quanlythuvien.db.DBConnect;

import java.sql.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.Normalizer;
import java.time.LocalDate;
import java.util.*;

public class FakeDataGenerator {
    private static final Faker faker = new Faker(new Locale("vi"));
    private static final Random random = new Random();

    // Định nghĩa số lượng cố định
    private static final int COUNT_SINH_VIEN = 50;
    private static final int COUNT_NHAN_VIEN = 20;
    private static final int COUNT_TAC_GIA = 20;
    private static final int COUNT_NXB = 10;
    private static final int COUNT_PHIEU_MUON = 60;
    private static final int COUNT_PHIEU_TRA = 50;
    private static final int COUNT_SACH = 80;

    // Các biến lưu trữ tiền tố ngẫu nhiên (XXX) cho từng bảng
    private static int PREFIX_SV;
    private static int PREFIX_NV;
    private static int PREFIX_TG;
    private static int PREFIX_TL;
    private static int PREFIX_NXB;
    private static int PREFIX_SACH;
    private static int PREFIX_PM;
    private static int PREFIX_PT;

    // Set để đảm bảo tính DUY NHẤT của các tiền tố 3 chữ số
    private static final Set<Integer> usedPrefixes = new HashSet<>();


    // Danh sách lưu trữ các ID đã tạo để dùng cho Foreign Key (sẽ là dãy 6 chữ số)
    private static final List<Integer> maSinhViens = new ArrayList<>();
    private static final List<Integer> maNhanViens = new ArrayList<>();
    private static final List<Integer> maSachs = new ArrayList<>();
    private static final List<Integer> maPhieuMuons = new ArrayList<>();
    private static final List<Integer> maTacGias = new ArrayList<>();
    private static final List<Integer> maTheLoais = new ArrayList<>();
    private static final List<Integer> maNXBs = new ArrayList<>();


    // ================== HÀM HỖ TRỢ ĐÃ CẬP NHẬT ==================
    /**
     * Chuyển đổi chuỗi tiếng Việt có dấu thành không dấu, loại bỏ khoảng trắng và chuyển thành chữ thường.
     * ĐẶC BIỆT: Xử lý 'Đ'/'đ' thành 'd'.
     */
    private static String toNonDiacritic(String text) {
        if (text == null || text.isEmpty()) {
            return "";
        }

        // 1. Chuyển về chữ thường
        String temp = text.toLowerCase();

        // 2. Xử lý ký tự 'đ' thành 'd' (trước khi loại bỏ dấu)
        temp = temp.replace('đ', 'd');

        // 3. Chuẩn hóa sang Form NFD (Canonical Decomposition)
        String normalized = Normalizer.normalize(temp, Normalizer.Form.NFD);

        // 4. Loại bỏ các dấu kết hợp (huyền, sắc, hỏi, ngã, nặng)
        String nonDiacritic = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

        // 5. Loại bỏ khoảng trắng và các ký tự không mong muốn (chữ thường)
        nonDiacritic = nonDiacritic.replaceAll("[\\s-]+", "");

        return nonDiacritic;
    }
    // ============================================================

    /**
     * Sinh một tiền tố 3 chữ số ngẫu nhiên và duy nhất trong một phạm vi.
     */
    private static int generateUniquePrefix(int minPrefix, int maxPrefix) {
        int prefix;
        do {
            prefix = random.nextInt(maxPrefix - minPrefix + 1) + minPrefix;
        } while (usedPrefixes.contains(prefix));

        usedPrefixes.add(prefix);
        return prefix;
    }

    /**
     * Hàm resetTable
     */
    private static void resetTable(Connection conn, String tableName) throws SQLException {
        try (Statement st = conn.createStatement()) {
            st.executeUpdate("SET FOREIGN_KEY_CHECKS = 0");
            st.executeUpdate("DELETE FROM " + tableName);
            st.executeUpdate("ALTER TABLE " + tableName + " AUTO_INCREMENT = 1");
            st.executeUpdate("SET FOREIGN_KEY_CHECKS = 1");
        }
    }

    /**
     * Chèn bản ghi đầu tiên với ID được chỉ định để thiết lập AUTO_INCREMENT.
     */
    private static int insertInitialId(Connection conn, String tableName, String idColumn, int prefix) throws SQLException {
        // ID khởi tạo (6 chữ số): prefix * 1000 + 1 (VD: 250 * 1000 + 1 = 250001)
        int startId = prefix * 1000 + 1;
        String sql = String.format("INSERT INTO %s (%s) VALUES (?)", tableName, idColumn);

        try (Statement st = conn.createStatement(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Tắt kiểm tra FK tạm thời
            st.executeUpdate("SET FOREIGN_KEY_CHECKS = 0");

            ps.setInt(1, startId);
            ps.executeUpdate();

            // Xóa bản ghi đó đi. AUTO_INCREMENT đã được đặt là startId + 1 (XXX002).
            st.executeUpdate(String.format("DELETE FROM %s WHERE %s = %d", tableName, idColumn, startId));

            // Bật lại kiểm tra FK
            st.executeUpdate("SET FOREIGN_KEY_CHECKS = 1");

            return startId;
        }
    }

    public static void main(String[] args) {
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                System.out.println("❌ Không thể kết nối CSDL!");
                return;
            }
            System.out.println("✅ Kết nối thành công!");

            // Xóa danh sách ID cũ và tiền tố
            usedPrefixes.clear();
            maSinhViens.clear();
            maNhanViens.clear();
            maSachs.clear();
            maPhieuMuons.clear();
            maTacGias.clear();
            maTheLoais.clear();
            maNXBs.clear();

            // 1. SINH TIỀN TỐ NGẪU NHIÊN VÀ DUY NHẤT (3 CHỮ SỐ)
            PREFIX_SV = generateUniquePrefix(100, 499); // MaSV: 100-499
            PREFIX_NV = generateUniquePrefix(500, 999); // MaNV: 500-999
            PREFIX_TG = generateUniquePrefix(100, 999);
            PREFIX_TL = generateUniquePrefix(100, 999);
            PREFIX_NXB = generateUniquePrefix(100, 999);
            PREFIX_SACH = generateUniquePrefix(100, 999);
            PREFIX_PM = generateUniquePrefix(100, 999);
            PREFIX_PT = generateUniquePrefix(100, 999);

            System.out.println("⚙️ Tiền tố ID ngẫu nhiên: SV=" + PREFIX_SV + ", NV=" + PREFIX_NV + "...");

            // --- RESET BẢNG & THIẾT LẬP AUTO_INCREMENT DÙNG TIỀN TỐ ---
            resetTable(conn, "CHITIETPHIEUTRA");
            resetTable(conn, "PHIEUTRA");
            insertInitialId(conn, "PHIEUTRA", "MaPhieuTra", PREFIX_PT);
            resetTable(conn, "LICHSUGIAHAN");
            resetTable(conn, "CHITIETPHIEUMUON");
            resetTable(conn, "PHIEUMUON");
            insertInitialId(conn, "PHIEUMUON", "MaPhieuMuon", PREFIX_PM);
            resetTable(conn, "SACH_TACGIA");
            resetTable(conn, "TAIKHOAN");
            resetTable(conn, "HINHANH");
            resetTable(conn, "SACH");
            insertInitialId(conn, "SACH", "MaSach", PREFIX_SACH);
            resetTable(conn, "NHAXUATBAN");
            insertInitialId(conn, "NHAXUATBAN", "MaNXB", PREFIX_NXB);
            resetTable(conn, "THELOAI");
            insertInitialId(conn, "THELOAI", "MaTheLoai", PREFIX_TL);
            resetTable(conn, "TACGIA");
            insertInitialId(conn, "TACGIA", "MaTG", PREFIX_TG);
            resetTable(conn, "NHANVIEN");
            insertInitialId(conn, "NHANVIEN", "MaNV", PREFIX_NV);
            resetTable(conn, "SINHVIEN");
            insertInitialId(conn, "SINHVIEN", "MaSV", PREFIX_SV);

            // --- CHÈN DỮ LIỆU ---
            insertNhanVien(conn, COUNT_NHAN_VIEN);
            insertSinhVien(conn, COUNT_SINH_VIEN);
            insertTacGia(conn, COUNT_TAC_GIA);
            insertTheLoai(conn);
            insertNXB(conn, COUNT_NXB);
            insertSach(conn);
            insertHinhAnh(conn);
            insertSachTacGia(conn);

            insertPhieuMuon(conn, COUNT_PHIEU_MUON);
            insertPhieuTra(conn, COUNT_PHIEU_TRA);

            insertTaiKhoan(conn);

            System.out.println("🎉 Sinh dữ liệu giả thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- CÁC HÀM INSERT DỮ LIỆU ĐÃ CẬP NHẬT ---

    private static void insertSinhVien(Connection conn, int count) throws SQLException {
        String sql = "INSERT INTO SINHVIEN (TenSV, NgaySinh, GioiTinh, DiaChi, SoDienThoai, Email, NgayDKThe, NgayHHThe) VALUES (?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < count; i++) {
                String tenDayDu = faker.name().fullName();

                // Email không dấu và giống tên
                String tenKhongDau = toNonDiacritic(tenDayDu);
                String email = tenKhongDau + "@sv.tvu.edu.vn";

                // Số điện thoại 11 số
                String sdt = "0" + faker.number().digits(10);

                ps.setString(1, tenDayDu);
                ps.setDate(2, Date.valueOf(LocalDate.now().minusYears(18 + random.nextInt(5)).minusDays(random.nextInt(365))));
                ps.setString(3, random.nextBoolean() ? "Nam" : "Nữ");
                ps.setString(4, faker.address().fullAddress());
                ps.setString(5, sdt);
                ps.setString(6, email);
                LocalDate ngayDK = LocalDate.now().minusMonths(random.nextInt(12));
                ps.setDate(7, Date.valueOf(ngayDK));
                ps.setDate(8, Date.valueOf(ngayDK.plusYears(4)));
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) maSinhViens.add(rs.getInt(1));
                }
            }
        }
    }

    private static void insertNhanVien(Connection conn, int count) throws SQLException {
        String sql = "INSERT INTO NHANVIEN (TenNV, NgaySinh, GioiTinh, SoDienThoai, Email) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < count; i++) {
                String tenDayDu = faker.name().fullName();

                // Email không dấu và giống tên
                String tenKhongDau = toNonDiacritic(tenDayDu);
                String email = tenKhongDau + "@nv.tvu.edu.vn";

                // Số điện thoại 11 số
                String sdt = "0" + faker.number().digits(10);

                ps.setString(1, tenDayDu);
                ps.setDate(2, Date.valueOf(LocalDate.now().minusYears(22 + random.nextInt(20))));
                ps.setString(3, random.nextBoolean() ? "Nam" : "Nữ");
                ps.setString(4, sdt);
                ps.setString(5, email);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) maNhanViens.add(rs.getInt(1));
                }
            }
        }
    }

    private static void insertTacGia(Connection conn, int count) throws SQLException {
        String sql = "INSERT INTO TACGIA (TenTG, QueQuan, NamSinh) VALUES (?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < count; i++) {
                ps.setString(1, faker.book().author());
                ps.setString(2, faker.address().cityName());
                ps.setInt(3, 1940 + random.nextInt(50));
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) maTacGias.add(rs.getInt(1));
                }
            }
        }
    }

    private static void insertNXB(Connection conn, int count) throws SQLException {
        String sql = "INSERT INTO NHAXUATBAN (TenNXB, DiaChi, SoDienThoai) VALUES (?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < count; i++) {
                ps.setString(1, "NXB " + faker.company().name());
                ps.setString(2, faker.address().streetAddress());
                ps.setString(3, faker.phoneNumber().phoneNumber());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) maNXBs.add(rs.getInt(1));
                }
            }
        }
    }

    private static void insertTheLoai(Connection conn) throws SQLException {
        String[] list = {"Tiểu thuyết", "Truyện ngắn", "Khoa học", "Công nghệ", "Tâm lý", "Lịch sử", "Giáo dục", "Thiếu nhi"};
        String sql = "INSERT INTO THELOAI (TenTheLoai) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (String tl : list) {
                ps.setString(1, tl);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) maTheLoais.add(rs.getInt(1));
                }
            }
        }
    }

    private static void insertSach(Connection conn) throws SQLException {
        Map<String, List<String>> TEN_SACH_THEO_THELOAI = new LinkedHashMap<String, List<String>>() {{
            put("Tiểu thuyết", Arrays.asList(
                    "Mùa Hè Của Tôi", "Người Lạ Trên Phố", "Hoa Trong Gió", "Bức Tranh Tình Yêu", "Những Ngày Không Quên",
                    "Dưới Ánh Trăng", "Mây Trôi Cuối Trời", "Những Bước Chân Im Lặng", "Hạnh Phúc Mong Manh", "Lời Thì Thầm"
            ));
            put("Truyện ngắn", Arrays.asList(
                    "Chuyến Xe Cuối Tuần", "Ngôi Nhà Sau Hẻm", "Một Thoáng Quá Khứ", "Câu Chuyện Đêm Trăng", "Những Khoảnh Khắc Nhỏ",
                    "Bên Cửa Sổ", "Đêm Thành Phố", "Ký Ức Tuổi Thơ", "Những Điều Chưa Kể", "Những Bức Thư Mất"
            ));
            put("Khoa học", Arrays.asList(
                    "Vũ Trụ Học Cơ Bản", "Khám Phá Sinh Học", "Hóa Học Vui", "Thiên Văn Học Thực Hành", "Khoa Học Trẻ Em",
                    "Công Nghệ Sinh Học", "Vật Lý Thực Hành", "Các Phát Minh Vĩ Đại", "Thế Giới Toán Học", "Khoa Học Máy Tính"
            ));
            put("Công nghệ", Arrays.asList(
                    "Lập Trình Java", "Học Python Thực Hành", "Cơ Sở Dữ Liệu Nâng Cao", "Robot & Tự Động Hóa", "Machine Learning Thực Hành",
                    "Phát Triển Web", "Thiết Kế App Android", "Trí Tuệ Nhân Tạo", "Blockchain Thực Hành", "Công Nghệ Mạng"
            ));
            put("Tâm lý", Arrays.asList(
                    "Tâm Lý Học Gia Đình", "Quản Lý Cảm Xúc", "Những Bài Học Cuộc Sống", "Tâm Lý Trẻ Em", "Kỹ Năng Giao Tiếp",
                    "Hiểu Về Tâm Hồn", "Tâm Lý Học Thực Hành", "Cân Bằng Cuộc Sống", "Những Câu Chuyện Trị Liệu", "Sống Không Hối Tiếc"
            ));
            put("Lịch sử", Arrays.asList(
                    "Lịch Sử Việt Nam", "Chiến Tranh Và Hòa Bình", "Những Vị Vua Việt Nam", "Lịch Sử Thế Giới", "Những Ngày Tháng Không Quên",
                    "Đế Chế La Mã", "Chiến Tranh Thế Giới II", "Cuộc Cách Mạng Công Nghiệp", "Hồ Chí Minh Toàn Tập", "Những Anh Hùng Dân Tộc"
            ));
            put("Giáo dục", Arrays.asList(
                    "Cẩm Nang Sinh Viên", "Giáo Trình Toán Học", "Giáo Dục Thường Thức", "Học Vui Học Khỏe", "Kỹ Năng Học Tập",
                    "Phương Pháp Giảng Dạy", "Tâm Lý Học Giáo Dục", "Kỹ Năng Thuyết Trình", "Học Tiếng Anh Hiệu Quả", "Kỹ Năng Sinh Viên"
            ));
            put("Thiếu nhi", Arrays.asList(
                    "Truyện Cổ Tích Việt Nam", "Thiếu Nhi Khám Phá", "Những Ngày Tháng Vui", "Vui Học Toán", "Chuyện Kể Trước Giờ Ngủ",
                    "Phiêu Lưu Cùng Thỏ", "Câu Chuyện Rừng Xanh", "Những Người Bạn Nhỏ", "Học Vui Qua Truyện", "Thế Giới Diệu Kỳ"
            ));
        }};

        String sql = "INSERT INTO SACH (TenSach, NamXuatBan, SoTrang, MaNXB, MaTheLoai, MoTa, GiaTien, SoLuong) VALUES (?,?,?,?,?,?,?,?)";
        Set<String> usedTenSach = new HashSet<>();
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int currentTLIndex = 0;
            for (String tl : TEN_SACH_THEO_THELOAI.keySet()) {
                List<String> tenSachList = TEN_SACH_THEO_THELOAI.get(tl);
                for (String ten : tenSachList) {
                    if (usedTenSach.contains(ten)) continue;
                    usedTenSach.add(ten);

                    int maNXB = maNXBs.get(random.nextInt(maNXBs.size()));
                    int maTL = maTheLoais.get(currentTLIndex);

                    ps.setString(1, ten);
                    ps.setInt(2, 2000 + random.nextInt(24));
                    ps.setInt(3, 50 + random.nextInt(400));
                    ps.setInt(4, maNXB);
                    ps.setInt(5, maTL);
                    ps.setString(6, getMoTaByTheLoai(tl, ten));
                    ps.setBigDecimal(7, new BigDecimal(30000 + random.nextInt(200000)));
                    ps.setInt(8,faker.number().numberBetween(1,50));
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) maSachs.add(rs.getInt(1));
                    }
                }
                currentTLIndex++;
            }
        }
    }


    private static void insertHinhAnh(Connection conn) throws SQLException {
        String sql = "INSERT INTO HINHANH (DuongLinkAnh, MaSach) VALUES (?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int maSach : maSachs) {
                ps.setString(1, "https://picsum.photos/seed/book" + maSach + "/200/300");
                ps.setInt(2, maSach);
                ps.executeUpdate();
            }
        }
    }

    private static void insertSachTacGia(Connection conn) throws SQLException {
        String sql = "INSERT INTO SACH_TACGIA (MaTG, MaSach) VALUES (?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int maSach : maSachs) {
                Set<Integer> usedTG = new HashSet<>();
                int soTacGia = 1 + random.nextInt(3);
                for (int i = 0; i < soTacGia; i++) {
                    int maTG;
                    do {
                        maTG = maTacGias.get(random.nextInt(maTacGias.size()));
                    } while (usedTG.contains(maTG));

                    usedTG.add(maTG);
                    ps.setInt(1, maTG);
                    ps.setInt(2, maSach);
                    try {
                        ps.executeUpdate();
                    } catch (SQLException e) {
                        if (!e.getMessage().contains("Duplicate entry")) {
                            throw e;
                        }
                    }
                }
            }
        }
    }


    private static void insertPhieuMuon(Connection conn, int count) throws SQLException {
        String sql = "INSERT INTO PHIEUMUON (MaSV, NgayMuon, HanTra, TrangThai, MaNV, SoLanGiaHan) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < count; i++) {
                int maSV = maSinhViens.get(random.nextInt(maSinhViens.size()));
                int maNV = maNhanViens.get(random.nextInt(maNhanViens.size()));

                LocalDate ngayMuon = LocalDate.now().minusDays(random.nextInt(30));
                LocalDate hanTra = ngayMuon.plusDays(14);

                ps.setInt(1, maSV);
                ps.setDate(2, Date.valueOf(ngayMuon));
                ps.setDate(3, Date.valueOf(hanTra));
                ps.setString(4, random.nextBoolean() ? "Đang mượn" : "Đã trả");
                ps.setInt(5, maNV);
                ps.setInt(6, random.nextInt(3));

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int maPM = rs.getInt(1);
                        maPhieuMuons.add(maPM);
                        insertCTPhieuMuon(conn, maPM);
                    }
                }
            }
        }
    }

    private static void insertCTPhieuMuon(Connection conn, int maPM) throws SQLException {
        String sql = "INSERT INTO CHITIETPHIEUMUON (MaPhieuMuon, MaSach, SoLuongMuon) VALUES (?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int soSach = 1 + random.nextInt(3);
            Set<Integer> usedSach = new HashSet<>();
            for (int i = 0; i < soSach; i++) {
                int maSach;
                do {
                    maSach = maSachs.get(random.nextInt(maSachs.size()));
                } while (usedSach.contains(maSach));
                usedSach.add(maSach);

                ps.setInt(1, maPM);
                ps.setInt(2, maSach);
                ps.setInt(3, 1);
                ps.executeUpdate();
            }
        }
    }

    private static void insertPhieuTra(Connection conn, int count) throws SQLException {
        String sql = "INSERT INTO PHIEUTRA (MaPhieuMuon, NgayTra, MaNV, MaSV) VALUES (?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < count; i++) {
                int maPM = maPhieuMuons.get(random.nextInt(maPhieuMuons.size()));

                int maNV = maNhanViens.get(random.nextInt(maNhanViens.size()));
                int maSV = maSinhViens.get(random.nextInt(maSinhViens.size()));

                LocalDate ngayTra = LocalDate.now().minusDays(random.nextInt(10));

                ps.setInt(1, maPM);
                ps.setDate(2, Date.valueOf(ngayTra));
                ps.setInt(3, maNV);
                ps.setInt(4, maSV);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int maPT = rs.getInt(1);
                        insertCTPhieuTra(conn, maPT);
                    }
                }
            }
        }
    }

    private static void insertCTPhieuTra(Connection conn, int maPT) throws SQLException {
        String sql = "INSERT INTO CHITIETPHIEUTRA (MaPhieuTra, MaSach, SoLuongTra) VALUES (?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int soSach = 1 + random.nextInt(2);
            Set<Integer> usedSach = new HashSet<>();
            for (int i = 0; i < soSach; i++) {
                int maSach;
                do {
                    maSach = maSachs.get(random.nextInt(maSachs.size()));
                } while (usedSach.contains(maSach));
                usedSach.add(maSach);

                ps.setInt(1, maPT);
                ps.setInt(2, maSach);
                ps.setInt(3, 1);
                ps.executeUpdate();
            }
        }
    }

    private static void insertTaiKhoan(Connection conn) throws SQLException {
        String sql = "INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, MaNV, MaSV, VaiTro) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. Tài khoản NHANVIEN (TenDangNhap là MaNV)
            for (int maNV : maNhanViens) {
                ps.setString(1, String.valueOf(maNV));
                ps.setString(2, "123456");
                ps.setInt(3, maNV);
                ps.setNull(4, Types.INTEGER);
                ps.setString(5, "Nhân viên");
                ps.executeUpdate();
            }

            // 2. Tài khoản SINHVIEN (TenDangNhap là MaSV)
            for (int maSV : maSinhViens) {
                ps.setString(1, String.valueOf(maSV));
                ps.setString(2, "123456");
                ps.setNull(3, Types.INTEGER);
                ps.setInt(4, maSV);
                ps.setString(5, "Sinh viên");
                ps.executeUpdate();
            }

            // 3. Tài khoản Admin
            ps.setString(1, "admin");
            ps.setString(2, "admin");
            ps.setNull(3, Types.INTEGER);
            ps.setNull(4, Types.INTEGER);
            ps.setString(5, "Admin");
            ps.executeUpdate();
        }
    }

    private static String getMoTaByTheLoai(String tenTheLoai, String tenSach) {
        return "Mô tả cho sách " + tenSach + " thuộc thể loại " + tenTheLoai + ".";
    }
}