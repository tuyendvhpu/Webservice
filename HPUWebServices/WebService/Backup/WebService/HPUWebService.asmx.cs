using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Configuration;
using System.Text;
using System.Security.Cryptography;

namespace Services
{
    /// <summary>
    /// Summary description for HPUWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class HPUWebService : System.Web.Services.WebService
    {
        public HPUWebService()
        {
            //Uncomment the following line if using designed components 
            //InitializeComponent(); 
        }
        string key = "hpu20140310";
        private SqlConnection getConnection()
        {
          SqlConnection conn = new SqlConnection("Server=10.1.0.246;Database=EduMngNew;UID=ws;PWD=ws123654");
          //SqlConnection conn = new SqlConnection("Server=10.1.0.236;Database=EduMngNew;UID=ws;PWD=ws123654");
            return conn;
        }

        [WebMethod(Description = "Số tín chỉ, môn học sinh viên đã đăng ký theo năm học, học kỳ: DataTable SoTinChiSinhVienDaDangKy(string masinhvien ) Input(Masinhvien='1112404061'); Output(MaSinhVien,NamHoc,HocKy,SoMonHoc,TongTC)")]
        public DataTable SoTinChiSinhVienDaDangKy(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SoTinChiSinhVienDaDangKy");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSoTCSinhVienDK", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách sách các môn sinh viên đã đăng ký theo năm học, học kỳ:DataTable MonHocDangKy(string masinhvien) Input(Masinhvien='1112404061'); Output(MaSinhVien,NamHoc,HocKy,MaMonHoc,TenMonHoc,SoTC,HocPhi)")]
        public DataTable MonHocDangKy(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHocDangKy");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonhocDaDK", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Môn học trong kỳ:DataTable MonHocTrongKy(string masinhvien) Input(Masinhvien='1112404061'); Output(MaSinhVien,MaMonHoc,TenMonHoc,SoTC)")]
        public DataTable MonHocTrongKy(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHocTrongKy");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonHocTrongKy", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Giấy tờ sinh viên đã nộp, chưa nộp:DataTable GiayToDaNop(string masinhvien) Input(masinhvien='1112404061'); Output(MaSinhVien,TenGiayTo,Ban,TrangThai)")]
        public DataTable GiayToDaNop(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("GiayToDaNop");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspGiayToDaNop", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Môn đăng ký thi lại: MonDaDangKyThiLai(string masinhvien) Input(Masinhvien='110913'); Output(MaSinhVien,maMonHoc,TenMonHoc,namHoc,hocKy,LePhiThiLai,LePhiThiLaiDaNop)")]
        public DataTable MonDaDangKyThiLai(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonDaDangKyThiLai");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonDaDangKyThiLai", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

       
        [WebMethod(Description = "Thông tin sinh viên:DataTable ThongTinSinhVien(string masinhvien) Input(Masinhvien='110913'); Output(Masinhvien,HoDem,Ten,NgaySinh,GioiTinh,AnhSinhVien,MaTinhTrang,TinhTrang,MaLop,DiaChi,DienThoai,Email,TenNganh,TenKhoaHoc,TenHeDaoTao,MaDaoTao,DaoTao)")]
        public DataTable ThongTinSinhVien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("ThongTinSinhVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspThongTinSinhVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }


        [WebMethod(Description = "Môn còn nợ áp dụng cho DieuKien:DataTable MonSinhVienNo(string masinhvien) Input(Masinhvien='110913'); Output(MaSinhVien,MaMonHoc,TenMonHoc,ThuocCTDT,DiemMax)")]
        public DataTable MonSinhVienNo(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonSinhVienNo");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonSinhVienNo", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Môn học sinh viên còn nợ áp dụng cho VP:DataTable MonSinhVienNoMon(string masinhvien) Input(Masinhvien='110913'); Output(MaSinhVien,TenMonHoc,DiemMax)")]
        public DataTable MonSinhVienNoMon(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonSinhVienNoMon");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonSinhVienNoMon", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
        [WebMethod(Description = "Môn đã qua:DataTable MonSinhVienDaQua(string masinhvien) Input(Masinhvien='110913'); Output(MaSinhVien,MaMonHoc,TenMonHoc,ThuocCTDT,DiemMax)")]
        public DataTable MonSinhVienDaQua(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonSinhVienDaQua");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonSinhVienDaQua", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các môn sinh viên đã học :DataTable MonSinhVienDaHoc(string masinhvien) Input(Masinhvien='110913'); Output(MaSinhVien,MaMonHoc,TenMonHoc,ThuocCTDT,DiemMax)")]
        public DataTable MonSinhVienDaHoc(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonSinhVienDaHoc");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonSinhVienDaHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        
        [WebMethod(Description = "Các khoản đã nộp:DataTable CacKhoanDaNop(string masinhvien) Input(Masinhvien='110913'); Output(SoPhieu,SoTien,Noidung,NgayThu,NamHoc,HocKy,Huy,PhieuHuy)")]
        public DataTable CacKhoanDaNop(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CacKhoanDaNop");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspCacKhoanDaNop", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Các khoản đã chi:DataTable CacKhoanDaChi(string masinhvien) Input(Masinhvien='110913'); Output(SoPhieu,SoTien,NoiDung,NgayChi,namHoc,hocKy,Huy,PhieuHuy)")]
        public DataTable CacKhoanDaChi(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CacKhoanDaChi");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspCacKhoanDaChi", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Các khoản còn thiếu:DataTable CacKhoanThieu(string masinhvien) Input(Masinhvien='110913'); Output(MaSinhVien,KhoanThu,NamHoc,HocKy,soTienQuyDinh,SoTienThayDoi,soTienMienGiam,SoTienKyTruocChuyenSang,SoTienDaThu,SoTienPhaiChi,SoTienDaChi,SoTienChuyenSangKySau, SotienConThieu)")]
        public DataTable CacKhoanThieu(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CacKhoanThieu");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspCacKhoanThieu", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }



        [WebMethod(Description = "Theo dõi quá trình sinh viên ở trong KSSV :DataTable SinhvienKSSV(string Namhoc, string masinhvien) Input(Masinhvien='121480'); Output(MaSinhVien,NamHoc,MaPhong,NgayVao,NgayRa,chiSoDienKhiVao,chiSoNuocLanhKhiVao,chiSoNuocNongKhiVao,chiSoDienKhiRa,chiSoNuocLanhKhiRa,chiSoNuocNongKhiRa,TrangThai)")]
        public DataTable SinhvienKSSV(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhvienKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSinhvienKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Điểm rèn luyện sinh viên:DataTable SinhvienDiemRenLuyen(string masinhvien) Input(Masinhvien='121480'); Output(MaSinhVien,NamHoc,Hocky,Diem)")]
        public DataTable SinhvienDiemRenLuyen(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhvienDiemRenLuyen");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSinhvienDiemRenLuyen", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Khung CTĐT của sinh viên:DataTable KhungChuongTrinh(string masinhvien) Input(Masinhvien='110913'); Output(MaHeDaoTao, MaKhoaHoc, MaNganh,MaMonHoc, TenMonHoc,TongSo,MaKhoiKienThuc,TenKhoiKienThuc,DonVi,TuChon,BatBuoc,ThayThe, TenNganh,TongSoMonTuChon,SoMonPhaiChon,BatBuoc,MaNhom,TenNHom)")]
        public DataTable KhungChuongTrinh(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("KhungChuongTrinh");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspKhungChuongTrinh", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Điều kiện trước sau môn học:DataTable DieuKienTruocSau(string masinhvien) Input(Masinhvien='110913'); Output(MaHeDaoTao, MaKhoaHoc, MaNganh,MaMonHoc, TenMonHoc,MaKhoiKienThuc,DonVi,TuChon,BatBuoc,ThayThe, TenNganh)")]
        public DataTable DieuKienTruocSau(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DieuKienTruocSau");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDieuKienTruocSau", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Môn học thay thế:DataTable MonThayThe(string masinhvien) Input(Masinhvien='1008C69024'); Output(MaHeDaoTao,MaKhoaHoc,MaNganh,MaMonHoc1,MaMonHoc2,MaHeDaoTao2,MaKhoaHoc2,MaNganh2)")]
        public DataTable MonThayThe(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonThayThe");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonThayThe", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }


        [WebMethod(Description = "Môn học :DataTable MonHoc(string Mamonhoc) Input(Mamonhoc='SAE33021'); Output(MaMonHoc,TenMonHoc)")]
        public DataTable MonHoc(string Mamonhoc)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHoc");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Mamonhoc", SqlDbType.NVarChar).Value = Mamonhoc;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Bảng điểm chi tiết của sinh viên theo năm học học kỳ")]
        public DataTable BangDiem(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("BangDiem");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspBangDiem", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Bảng điểm toàn khóa của sinh viên theo năm học:Input(Masinhvien='1008C69006'); Output(MaSinhVien,MaMonHoc,TenMonHoc,KL KhoiLuong,NamHoc,Diem DiemThang10, DiemThang4,Diemchu,GhiChu)")]
        public DataTable BangDiemToanKhoa(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("BangDiemToanKhoa");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspBangDiemToanKhoa", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
                
        [WebMethod(Description = "Môn nằm ngoài CTĐT, điều kiện thay thế! Yêu cầu P.Đào tạo chuyển mã môn! Input(Masinhvien='500425'); Output(MaSinhVien,MaMonHoc,TenMonHoc,Diem)")]
        public DataTable MonTuDo(string maSinhVien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonTuDo");
            //string sql;

            SqlCommand cmd = new SqlCommand("usp_MonTuDo", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Nhóm môn học theo sinh viên! Input(Masinhvien='500425'); Output(MaMonHoc,TenMonHoc,TenKhoiKienThuc,MaNhom)")]
        public DataTable NhomMonHocSinhVien(string maSinhVien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("NhomMonHocSinhVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspNhomMon", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Khung CTĐT đăng ký thực tập tốt nghiệp! CTDTDangKyTTTN(string maSinhVien) Input(Masinhvien='1008C69003'); Output(MaHeDaoTao, MaKhoaHoc, MaNganh,MaMonHoc, TenMonHoc,TongSo,MaKhoiKienThuc,TenKhoiKienThuc,DonVi,TuChon,BatBuoc,ThayThe,TenNganh,TenNhom,TongSoMonTuChon, SoMonPhaiChon, BatBuoc)")]
        public DataTable CTDTDangKyTTTN(string maSinhVien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CTDTDangKyTTTN");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDangKyTTTN", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Khung CTĐT đăng ký làm tốt nghiệp! CTDTDangKyLTN(string maSinhVien) Input(Masinhvien='1008C69003'); Output(MaHeDaoTao, MaKhoaHoc, MaNganh,MaMonHoc, TenMonHoc,TongSo,MaKhoiKienThuc,TenKhoiKienThuc,DonVi,TuChon,BatBuoc,ThayThe,TenNganh,TenNhom,TongSoMonTuChon, SoMonPhaiChon, BatBuoc)")]
        public DataTable CTDTDangKyLTN(string maSinhVien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CTDTDangKyLTN");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDangKyLTN", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Nhóm tự chọn sinh viên đăng ký! DangKyNhomTuChon(string maSinhVien) Input(Masinhvien='1008C69003'); Output(maNhom,maHeDaoTao,maNganhHoc,maKhoaHoc)")]
        public DataTable DangKyNhomTuChon(string maSinhVien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DangKyNhomTuChon");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDangKyNhomTuChon", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

       //


        [WebMethod(Description = "Danh sách các phòng còn trống trong KSSV! KssvPhongTrong() ; Output(MaPhong,SoGiuong,loaiPhong,SoSVDangO)")]
        public DataTable KssvPhongTrong()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("KssvPhongTrong");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspKssvPhongTrong", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các sinh viên ở trong phòng  ! PhongSV(string Maphong) Input(Maphong='A216'); Output(MaSinhVien,HoDem,Ten,NgaySinh,GioiTinh,MaLop,AnhSinhVien)")]
        public DataTable PhongSV(string Maphong)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("PhongSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspPhongSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Maphong", SqlDbType.NVarChar).Value = Maphong;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các môn được phép đăng ký cải thiện điểm! MonDuocPhepCaiThienDiem(string maSinhVien) Input(Masinhvien='1008C69003'); Output(MaMonHoc,TenMonHoc,NamHoc,HocKy,dieml1)")]
        public DataTable MonDuocPhepCaiThienDiem(string maSinhVien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("uspMonDuocPhepCaiThienDiem");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMonDuocPhepCaiThienDiem", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thời khóa biểu! TKB(string maSinhVien) Input(Masinhvien='1008C69003'); Output(TenGiaoVien,MaSinhVien,MaLop,MaMonHoc,TenMonHoc,sotc,MaPhongHoc,NamHoc,HocKy,SoTuanHoc,TuanHocBatDau,TuNgay,NgayKetThuc,SoTiet,2,3,4,5,6,7,8)")]
        public DataTable TKB(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TKB");
            DataTable dt1 = new DataTable("KyHienTai");
            DataRow dr;
            //string sql;
            int hocky;
            string sql ="Select HocKy From HocKy Where HienTai=1";
            SqlCommand cmd1 = new SqlCommand(sql, conn);
            cmd1.CommandType = CommandType.Text;
            SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
            da1.Fill(dt1);
            conn.Close();
            if (dt1.Rows.Count>0) {
                dr = dt1.Rows[0];
                hocky = int.Parse(dr.ItemArray[0].ToString());
                if (hocky == 1)
                {
                    SqlCommand cmd = new SqlCommand("uspTKB_HK1", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                    
                }

                else if (hocky == 2)
                {
                    SqlCommand cmd = new SqlCommand("uspTKB_HK2", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                    
                }

                else if (hocky == 3)
                {
                    SqlCommand cmd = new SqlCommand("uspTKB_HK3", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                  }
                        
            }

            return dt;              
        }

        [WebMethod(Description = "Danh sách sinh vien lớp môn học trong kỳ! SinhVienLopMonHoc() ; Output(MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc)")]
        public DataTable SinhVienLopMonHoc()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhVienLopMonHoc");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspLopMonHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thời khóa biểu theo lớp môn học! TKBLopMonHoc() ; Output(TenGiaoVien,MaGiaoVien,MaLop,MaMonHoc,TenMonHoc,sotc,MaPhongHoc,NamHoc,HocKy,SoTuanHoc,TuanHocBatDau,TuNgay,NgayKetThuc,SoTiet,2,3,4,5,6,7,8)")]
        public DataTable TKBLopMonHoc()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TKBLopMonHoc");
            DataTable dt1 = new DataTable("KyHienTai");
            DataRow dr;
            //string sql;
            int hocky;
            string sql = "Select HocKy From HocKy Where HienTai=1";
            SqlCommand cmd1 = new SqlCommand(sql, conn);
            cmd1.CommandType = CommandType.Text;
            SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
            da1.Fill(dt1);
            conn.Close();
            if (dt1.Rows.Count > 0)
            {
                dr = dt1.Rows[0];
                hocky = int.Parse(dr.ItemArray[0].ToString());
                if (hocky == 1)
                {
                    SqlCommand cmd = new SqlCommand("uspTKBLopMonHoc_HK1", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

                else if (hocky == 2)
                {
                    SqlCommand cmd = new SqlCommand("uspTKBLopMonHoc_HK2", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

                else if (hocky == 3)
                {
                    SqlCommand cmd = new SqlCommand("uspTKBLopMonHoc_HK3", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                }

            }

            return dt;
        }

        [WebMethod(Description = "Cố vấn học tập sinh viên: CoVanHocTap(string masinhvien) input('120639') Output(TenGiaoVien,DienThoai,Email)")]
        public DataTable CoVanHocTap(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CoVanHocTap");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspCoVanHocTap", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Miễn giảm học phí sinh viên: MienGiamHP(string masinhvien) input('1108C69426') Output(Masinhvien,NamHoc,SoTienMienGiam,ghiChu)")]
        public DataTable MienGiamHP(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MienGiamHP");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspMienGiamHP", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Dữ liệu sinh viên! SinhVien() ; Output(MaSinhVien, Lop, Hodem, Ten, GioiTinh, NgaySinh, MatKhauKhoiTao,TenKhoaHoc, TenHeDaoTao, MaNganh, TenNganh,TrangThai)")]
        public DataTable SinhVien()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSinhVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Dữ liệu sinh viên đang học! SinhVienDangHoc() ; Output(MaSinhVien, Lop, Hodem, Ten, GioiTinh, NgaySinh, MatKhauKhoiTao,TenKhoaHoc, TenHeDaoTao, MaNganh, TenNganh,TrangThai)")]
        public DataTable SinhVienDangHoc()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhVienDangHoc");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSinhVienDangHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Học kỳ hiện tại trong năm học! HocKyHienTai() ; Output(Namhoc,HocKy,Hientai, NgayBatDau,NgayKetThuc)")]
        public DataTable HocKyHienTai()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("HocKyHienTai");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspHocKyHienTai", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách lớp hành chính! LopHanhChinh() ; Output(MaLop,MaNganh,MaKhoaHoc,MaHeDaoTao,DaoTaoTheoTinChi)")]
        public DataTable LopHanhChinh()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopHanhChinh");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspLopHanhChinh", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
        
        [WebMethod(Description = "Tìm kiếm thông tin theo tên! TimKiemTheoTen(string hodem,string ten) Input(Họ đệm:='Nguyễn Thanh' Tên:= 'Toàn'); Output(Masinhvien,Hodem,Ten,Ngaysinh,Malop)")]
        public DataTable TimKiemTheoTen(string hodem,string ten)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TimKiemTheoTen");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspTimKiemTheoTen", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@hodem", SqlDbType.NVarChar).Value = hodem;
            cmd.Parameters.Add("@ten", SqlDbType.NVarChar).Value = ten;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Nợ tiền KSSV! NoTienKSSV(string maSinhVien) Input(Masinhvien='1013104013'); Output(MaSinhVien,KhoanThu,NamHoc,HocKy,soTienQuyDinh,SoTienThayDoi,soTienMienGiam,SoTienKyTruocChuyenSang,SoTienDaThu,SoTienPhaiChi,SoTienDaChi,SoTienChuyenSangKySau, SotienConThieu)")]
        public DataTable NoTienKSSV(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("NoTienKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspThieuTienKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thống kê số chỗ trống,đang ở tại KSSV theo nam, nữ! SoChoTrongKSSV() ; Output(Loai,SoSVDangO,SoChoTrong,TongSoCho)")]
        public DataTable SoChoTrongKSSV()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SoChoTrongKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSoChoTrongKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Số tín chỉ tích lũy và xếp hạng năm đào tạo! XepHangNam(string maSinhVien) Input(Masinhvien='1012104013'); Output(MaSinhVien,SoTinChiTichLuy,NamThu)")]
        public DataTable XepHangNam(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("XepHangNam");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspXepHangNam", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Trung bình chung học tập theo điểm lần 1 của năm học, học kỳ! TBCHTNamHocHKlan1(string masinhvien) Input(NamHoc,HocKy,Diem,XepLoai10,Diem4,XepLoai4,LanThu)")]
        public DataTable TBCHTNamHocHKlan1(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TBCHTNamHocHKlan1");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspTBCHTNamHocHK_lan1", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Trung bình chung học tập theo điểm lần 2 của năm học, học kỳ! TBCHTNamHocHKlan2(string masinhvien) Input(NamHoc,HocKy,Diem,XepLoai10,Diem4,XepLoai4,LanThu)")]
        public DataTable TBCHTNamHocHKlan2(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TBCHTNamHocHKlan2");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspTBCHTNamHocHK_lan2", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Tổng số môn đã học, Tổng số tín chỉ theo năm học, học kỳ! SoMonHocTheoNamHocKy(string masinhvien) Input(Masinhvien='1012104013'); Output(Masinhvien,Namhoc,HocKy,SoMonHoc,TongSoTC)")]
        public DataTable SoMonHocTheoNamHocKy(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SoMonHocTheoNamHocKy");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSoMonHocTheoNamHocKy", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thống kê số môn sinh viên đăng ký học theo học kỳ chính: Tổng số môn DK, đã qua, chưa qua! ThongKeMonHocHK(string masinhvien) Input(Masinhvien='1012104013'); Output(MaSinhVien,NamHoc,HocKy,SoMonDK,TongTC,SoMonDaQua,SoMonChuaQua)")]
        public DataTable ThongKeMonHocHK(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("ThongKeMonHocHK");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspThongKeMonHocHK", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thống kê số môn sinh viên đăng ký học theo học ký hiện tại: Tổng số môn, Tổng số tín chỉ! SoMonHocTheoNamHocKyHienTai(string masinhvien) Input(Masinhvien='1012104013'); Output(MaSinhVien,NamHoc,HocKy,SoMon,TongTC)")]
        public DataTable SoMonHocTheoNamHocKyHienTai(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SoMonHocTheoNamHocKyHienTai");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSoMonHocTheoNamHocKyHienTai", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Theo dõi tình hình sử dụng điện, nước của phòng KSSV theo tháng! DienNuocKSSVTheoThang(string maphong) Input(maphong='A203'); Output(MaPhong,Nam,Thang,ChiSoDien,ChiSoNuocNong,ChiSoNuocLanh)")]
        public DataTable DienNuocKSSVTheoThang(string maphong)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DienNuocKSSVTheoThang");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDienNuocKSSVTheoThang", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaPhong", SqlDbType.NVarChar).Value = maphong;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các phòng tại KSSV! DanhSachPhongKSSV() ; Output(MaPhong,MaToaNha,SoGuong,LoaiPhong)")]
        public DataTable DanhSachPhongKSSV()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DanhSachPhongKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDanhSachPhongKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Sử dụng điện nước tại phòng KSSV! SuDungDienNuocKSSV(string masinhvien) Input(Masinhvien='1354020033'); Output(NamHoc,MaPhong,MaSinhVien,TrangThai,NgayVao,NgayRa,chiSoDienKhiVao,chiSoNuocLanhKhiVao,chiSoNuocNongKhiVao,chiSoDienKhiRa,chiSoNuocLanhKhiRa,chiSoNuocNongKhiRa)")]
        public DataTable SuDungDienNuocKSSV(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SuDungDienNuocKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSuDungDienNuocKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Bảng hồ sơ giá điện, nước, phòng tại KSSV! GiaDienNuocKSSV() ; Output(giaDien,giaNuocLanh,giaNuocNong,giaPhongO,apDungTuNgay)")]
        public DataTable GiaDienNuocKSSV()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("GiaDienNuocKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspGiaDienNuocKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Theo số người ở tại phòng KSSV! SoLuongSinhVienPhongKSSV(string maphong) Input(maphong='A203'); Output( NamHoc,MaPhong,MaSinhVien,TrangThai,NgayVao,NgayRa)")]
        public DataTable SoLuongSinhVienPhongKSSV(string maphong)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SoLuongSinhVienPhongKSSV");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSoLuongSinhVienPhongKSSV", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaPhong", SqlDbType.NVarChar).Value = maphong;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Tính tiền điện, nước lạnh, nước nóng, nhà của sinh viên ở KSSV ! SuDungDienNuocKSSVTheoSinhVien(string masinhvien) Input(Masinhvien='1354020033'); Output(MaPhong,MaSinhVien,NgayVao,NgayRa,TienDien,TienNuocLanh,TienNuocNong, TienNha,TongCong)")]
        public DataTable SuDungDienNuocKSSVTheoSinhVien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SuDungDienNuocKSSVTheoSinhVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspSuDungDienNuocKSSVTheoSinhVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách cán bộ, giáo viên! DanhCanBoGiaoVien(); Output(MaNguoiDung,TenDangNhap,HoVaTen,MaGiaoVien,Email)")]
        public DataTable DanhCanBoGiaoVien()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DanhCanBoGiaoVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDanhCanBoGiaoVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
        //Danh sách Cán bộ giảng viên toàn trường

        [WebMethod(Description = "Danh sách cán bộ, giáo viên toàn trường! DanhSachCanBoGiangVien(); Output(MaGiaoVien,MaNguoiDung,TenDangNhap,HoDem,Ten,MaKhoa,MaBoMon,Email,TenTrangThai,DangBiKhoa,QuyenDuyet)")]
        public DataTable DanhSachCanBoGiangVien()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DanhSachCanBoGiangVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspDanhSachCanBoGiangVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Điểm môn học trong kỳ! DiemMonHocTrongKy(string masinhvien) ; Output(MaMonHoc,TenMonHoc,DQT,DiemThiL1,DiemTHL1,DiemThiL2,DiemTHL2,CamThiLan1,ViPham,PhaiHocLai")]
        public DataTable DiemMonHocTrongKy(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DiemMonHocTrongKy");
            DataTable dt1 = new DataTable("KyHienTai");
            DataRow dr;
            //string sql;
            int hocky;
            string sql = "Select HocKy From HocKy Where HienTai=1";
            SqlCommand cmd1 = new SqlCommand(sql, conn);
            cmd1.CommandType = CommandType.Text;
            SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
            da1.Fill(dt1);
            conn.Close();
            if (dt1.Rows.Count > 0)
            {
                dr = dt1.Rows[0];
                hocky = int.Parse(dr.ItemArray[0].ToString());
                if (hocky == 1)
                {
                    SqlCommand cmd = new SqlCommand("uspDiemMonHocTrongKy1", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

                else if (hocky == 2)
                {
                    SqlCommand cmd = new SqlCommand("uspDiemMonHocTrongKy2", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

                else if (hocky == 3)
                {
                    SqlCommand cmd = new SqlCommand("uspDiemMonHocTrongKy3", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                }

            }

            return dt;
        }

        [WebMethod(Description = "Danh môn học theo nhóm tự chọn:NhomMonTuChon(string masinhvien) Input(Masinhvien='1012104013'); Output(MaMonHoc, TenMonHoc,TenNHom,TongSoMonTuChon,SoMonPhaiChon,BatBuoc)")]
        public DataTable NhomMonTuChon(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("NhomMonTuChon");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspNhomMonTuChon", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Lịch thi của sinh viên theo học kỳ 1: LichThiHK(masinhvien, namhoc, hocky,lanthi) input('1008C69077','2012-2013',3) Output(Namhoc,Hocky,Malop,TenMonHoc,ngay,gio,DD_thi,HT_thi,lanthi,GhiChu)")]
        public DataTable LichThiHK(string masinhvien, string namhoc, int hocky,int lanthi)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LichThiHK");

            if (hocky == 1)
                {
                    SqlCommand cmd = new SqlCommand("uspLichThiHK1", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    cmd.Parameters.Add("@namhoc", SqlDbType.NVarChar).Value = namhoc;
                    cmd.Parameters.Add("@hocky", SqlDbType.Int).Value = hocky;
                    cmd.Parameters.Add("@lanthi", SqlDbType.Int).Value = lanthi;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

            if (hocky == 2)
            {
                SqlCommand cmd = new SqlCommand("uspLichThiHK2", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                cmd.Parameters.Add("@namhoc", SqlDbType.NVarChar).Value = namhoc;
                cmd.Parameters.Add("@hocky", SqlDbType.Int).Value = hocky;
                cmd.Parameters.Add("@lanthi", SqlDbType.Int).Value = lanthi;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();

            }

            else if (hocky >= 3)
                {
                    SqlCommand cmd = new SqlCommand("uspLichThiHK3", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
                    cmd.Parameters.Add("@namhoc", SqlDbType.NVarChar).Value = namhoc;
                    cmd.Parameters.Add("@hocky", SqlDbType.Int).Value = hocky;
                    cmd.Parameters.Add("@lanthi", SqlDbType.Int).Value = lanthi;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                }
         

            return dt;
        }

          
                
        [WebMethod(Description = "Học bổng của sinh viên theo năm học: HocBongSinhVien(string masinhvien) input('1012404131') Output(NamHoc,diemTBCHT,XepLoaiHocTap,XepLoaiRenLuyen,XepLoaiHocBong)")]
        public DataTable HocBongSinhVien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("HocBongSinhVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspHocBongSinhVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
        
        // Begin Kiểm tra điều kiện môn học

        [WebMethod(Description = "Danh sách các khóa đang học tại trường: KhoaDangHoc()  Output(MaKhoaHoc,TenKhoaHoc)")]
        public DataTable KhoaDangHoc()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("KhoaDangHoc");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspKhoaDangHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        //****************************************************************************//

        [WebMethod(Description = "Danh sách các hệ đào tạo tại trường: HeDaoTao(string makhoahoc) input (makhoahoc) Output(MaHeDaoTao,TenHeDaoTao,MaKhoaHoc)")]
        public DataTable HeDaoTao(string makhoahoc)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("HeDaoTao");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspHeDaoTao", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@makhoahoc", SqlDbType.NVarChar).Value = makhoahoc;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        //****************************************************************************//

        [WebMethod(Description = "Danh sách các ngành theo khóa,hệ đào tạo tại trường: NganhTheoKhoaHe(string makhoahoc, string mahedaotao) input (makhoahoc,mahedaotao) Output(MaNganh,TenNganh)")]
        public DataTable NganhTheoKhoaHe(string makhoahoc, string mahedaotao)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("NganhTheoKhoaHe");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspNganhTheoKhoaHe", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@makhoahoc", SqlDbType.NVarChar).Value = makhoahoc;
            cmd.Parameters.Add("@mahedaotao", SqlDbType.NVarChar).Value = mahedaotao;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
        //Begin Kiểm tra điều kiện môn học ****************************************************************************//
        [WebMethod(Description = "Danh sách sinh viên theo khóa, hệ, ngành: SinhVienKhoaHeNganh(string makhoahoc, string mahedaotao, string manganh) input (makhoahoc,mahedaotao,manganh) Output(MaSinhVien,MaNganh,TenNganh,MaHeDaoTao,TenHeDaoTao,MaKhoaHoc,TenKhoaHoc,NamVaoTruong,NamRaTruong)")]
        public DataTable SinhVienKhoaHeNganh(string makhoahoc, string mahedaotao, string manganh)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhVienKhoaHeNganh");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspSinhVienKhoaHeNganh", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@makhoahoc", SqlDbType.NVarChar).Value = makhoahoc;
            cmd.Parameters.Add("@mahedaotao", SqlDbType.NVarChar).Value = mahedaotao;
            cmd.Parameters.Add("@manganh", SqlDbType.NVarChar).Value = manganh;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các môn thay thế theo khóa hệ ngành: MonThayTheKhoaHeNganh() Output(MaMonHoc,TenMonHoc,MaHeDaoTao,MaKhoaHoc,MaNganh,MaMonHoc2,MaNganh2,MaHeDaoTao2,MaKhoaHoc2)")]
        public DataTable MonThayTheKhoaHeNganh()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonThayTheKhoaHeNganh");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonThayTheKhoaHeNganh", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các môn có ở các khóa hệ ngành khác: DanhSachCacMonTheoKhoaHeNganh() Output(MaMonHoc,TenMonHoc,MaHeDaoTao,MaKhoaHoc,MaNganh)")]
        public DataTable DanhSachCacMonTheoKhoaHeNganh()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DanhSachCacMonTheoKhoaHeNganh");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspDanhSachCacMonTheoKhoaHeNganh", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        //End Kiểm tra điều kiện môn học

        //END VP*****************************************************************************************************************************************
        //Begin Sổ đầu bài

        [WebMethod(Description = "Phân công giảng dạy Giảng viên theo các lớp môn học: LopMonGiangVien() Input(MaGiaoVien='1971024006'); Output(TenGiaoVien,MaGiaoVien,MaLop,MaMonHoc,TenMonHoc)")]
        public DataTable LopMonGiangVien()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopMonGiangVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspLopMonGiangVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thời khóa biểu giảng viên chi tiết của Giảng viên : TKBGiangVien() Input(MaGiaoVien='1971024006'); Output(TenGiaoVien,MaGiaoVien,MaLop,MaMonHoc,TenMonHoc,MaPhongHoc,NamHoc, HocKy,SoTiet,TuanHocBatDau,TuNgay,NgayKetThuc,SoTuanHoc,TietBatDau,Thu)")]
        public DataTable TKBGiangVien()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TKBGiangVien");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspTKBGiangVien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Lớp môn học sinh viên theo năm học, học kỳ! LopMonHocSinhVienHK() ; Output(MaSinhVien,Hodem,Ten, MaMonHoc, Malop, MaLopHanhChinh,TenMonHoc")]
        public DataTable LopMonHocSinhVienHK()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopMonHocSinhVienHK");
            DataTable dt1 = new DataTable("KyHienTai");
            DataRow dr;
            //string sql;
            int hocky;
            string sql = "Select HocKy From HocKy Where HienTai=1";
            SqlCommand cmd1 = new SqlCommand(sql, conn);
            cmd1.CommandType = CommandType.Text;
            SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
            da1.Fill(dt1);
            conn.Close();
            if (dt1.Rows.Count > 0)
            {
                dr = dt1.Rows[0];
                hocky = int.Parse(dr.ItemArray[0].ToString());
                if (hocky == 1)
                {
                    SqlCommand cmd = new SqlCommand("uspLopMonHocSinhVienHK1", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

                else if (hocky == 2)
                {
                    SqlCommand cmd = new SqlCommand("uspLopMonHocSinhVienHK2", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();

                }

                else if (hocky == 3)
                {
                    SqlCommand cmd = new SqlCommand("uspLopMonHocSinhVienHK3", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    conn.Close();
                }

            }

            return dt;
        }

        [WebMethod(Description = "Thời khóa biểu chi tiết theo các giai đoạn: TKBTheoGiaiDoan() ; Output(TenGiaoVien,MaGiaoVien,MaLop,MaMonHoc,TenMonHoc,MaPhongHoc,NamHoc,HocKy,SoTiet,TuanHocBatDau,TuNgay,NgayKetThuc,SoTuanHoc,TietBatDau,Thu)")]
        public DataTable TKBTheoGiaiDoan()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TKBTheoGiaiDoan");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspTKBTheoGiaiDoan", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Thời gian theo tuần: ThoiGianTuan() ; Output(MaTKB,Tuan,TuNgay,DenNgay)")]
        public DataTable ThoiGianTuan()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("ThoiGianTuan");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspThoiGianTuan", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Trung bình chung tích lũy và xếp loại học tập! TBCTL_XepLoai(string maSinhVien) Input(Masinhvien='1012104013'); Output(MaSinhVien,NamHoc,HocKy,Diem10,XepLoai10,Diem4,XepLoai4)")]
        public DataTable TBCTL_XepLoai(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TBCTL_XepLoai");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspTBCTL_XepLoai", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Trung bình chung tích lũy và xếp loại học tập toàn khóa! TBCTLXepLoai_TK(string maSinhVien) Input(Masinhvien='1012104013'); Output(MaSinhVien,NamHoc,HocKy,Diem10,XepLoai10,Diem4,XepLoai4)")]
        public DataTable TBCTLXepLoai_TK(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TBCTLXepLoai_TK");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspTBCTLXepLoai_TK", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Lớp ghép trong học kỳ : LopGhepHocKy() ; Output(MaLopGhep,NamHoc,HocKy,MaLop,MaMonHoc)")]
        public DataTable LopGhepHocKy()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopGhepHocKy");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspLopGhepHK", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Lớp Quản Lý: LopQuanLy() ; Output(MaLop,MaNganh,MaKhoaHoc,MaHeDaoTao,DaoTaoTheoTinChi)")]
        public DataTable LopQuanLy()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopQuanLy");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspLopQuanLy", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh sách các phòng học: PhongHoc() ; Output(MaPhongHoc,TenPhongHoc, MaViTri, MaToaNha, ChiSoTang, SoBan, HeSoHoc, HeSoThi, KieuPhong)")]
        public DataTable PhongHoc()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("PhongHoc");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspPhongHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Danh mục môn học: DanhMucMonHoc() ; Output(MaMonHoc,TenMonHoc)")]
        public DataTable DanhMucMonHoc()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("DanhMucMonHoc");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspDanhMucMonHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Lấy danh sách cố vấn lớp trong kỳ hiện tại: CoVanHocTapTrongHocKy() ; Output(MaLop,MaGiaoVien,TenGiaoVien,GiaoVien.DienThoai,GiaoVien.Email)")]
        public DataTable CoVanHocTapTrongHocKy()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CoVanHocTapTrongHocKy");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspCoVanHocTapTrongHocKy", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }


        [WebMethod(Description = "Lấy danh sách môn học của sinh viên trong kỳ hiện tại: PhanMonCuaSinhVienTheoKyHienTai() ; Output(MaSinhVien, HoDem, Ten, NgaySinh,GioiTinh,  LopQuanLy, MaLopMonHoc,MaMonHoc, TenMonHoc, SoTC)")]
        public DataTable PhanMonCuaSinhVienTheoKyHienTai()
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("PhanMonCuaSinhVienTheoKyHienTai");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspPhanMonCuaSinhVienTheoKyHienTai", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "Lấy danh sách môn học của sinh viên trong kỳ hiện tại: PhanMonCuaSinhVienTheoKyHienTai_VP() ; Output(MaSinhVien, HoDem, Ten, NgaySinh,GioiTinh,  LopQuanLy, MaLopMonHoc,MaMonHoc, TenMonHoc, SoTC)")]
        public DataTable PhanMonCuaSinhVienTheoKyHienTai_VP(string masinhvien, string mamonhoc)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("PhanMonCuaSinhVienTheoKyHienTai_VP");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspPhanMonCuaSinhVienTheoKyHienTai_VP", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = masinhvien;
            cmd.Parameters.Add("@mamonhoc", SqlDbType.NVarChar).Value = mamonhoc;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }


        [WebMethod(Description = "CauHinhMonHoc_ListByEmail(string email)")]
        public DataTable CauHinhMonHoc_ListByEmail(string email)
        {
            //string cnStr = ConfigurationManager.ConnectionStrings["EduMngConnectionString"].ConnectionString;
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CauHinhMonHoc");

            SqlCommand cmd = new SqlCommand("uspCauHinhMonHoc_ListByEmail", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = email;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "CauHinhMonHoc_GetByMaMonHoc(string maMonHoc)")]
        public DataTable CauHinhMonHoc_GetByMaMonHoc(string maMonHoc)
        {
            //string cnStr = ConfigurationManager.ConnectionStrings["EduMngConnectionString"].ConnectionString;
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("CauHinhMonHoc");

            SqlCommand cmd = new SqlCommand("uspCauHinhMonHoc_GetByMaMonHoc", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "CauHinhMonHoc_Update(string maMonHoc, string loaiMonHoc, string deCuongXayDungTheoHuong, decimal tongSoTiet, decimal soTietLyThuyet, decimal soTietThucHanh, decimal soTietTuHoc, decimal soTietBaiTap, decimal soTietDiThucTe, int tyLeDiemQuaTrinh, string hinhThucThi, int thoiGianThi, string deCuongChiTiet, string userName, string password); Trả về 1 khi cập nhật thành công")]
        public int CauHinhMonHoc_Update(string maMonHoc, string loaiMonHoc, string deCuongXayDungTheoHuong, decimal tongSoTiet, decimal soTietLyThuyet, decimal soTietThucHanh, decimal soTietTuHoc, decimal soTietBaiTap, decimal soTietDiThucTe, int tyLeDiemQuaTrinh, string hinhThucThi, int thoiGianThi, string deCuongChiTiet, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();

            conn.Open();
            SqlCommand cmd = new SqlCommand("uspCauHinhMonHoc_Update", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;
            cmd.Parameters.Add("@LoaiMonHoc", SqlDbType.NVarChar).Value = loaiMonHoc;
            cmd.Parameters.Add("@DeCuongXayDungTheoHuong", SqlDbType.NVarChar).Value = deCuongXayDungTheoHuong;
            cmd.Parameters.Add("@TongSoTiet", SqlDbType.Real).Value = (decimal)tongSoTiet;
            cmd.Parameters.Add("@SoTietLyThuyet", SqlDbType.Real).Value = (decimal)soTietLyThuyet;
            cmd.Parameters.Add("@SoTietThucHanh", SqlDbType.Real).Value = (decimal)soTietThucHanh;
            cmd.Parameters.Add("@SoTietTuHoc", SqlDbType.Real).Value = (decimal)soTietTuHoc;
            cmd.Parameters.Add("@SoTietBaiTap", SqlDbType.Real).Value = (decimal)soTietBaiTap;
            cmd.Parameters.Add("@SoTietDiThucTe", SqlDbType.Real).Value = (decimal)soTietDiThucTe;
            cmd.Parameters.Add("@TyLeDiemQuaTrinh", SqlDbType.Int).Value = (int)tyLeDiemQuaTrinh;
            cmd.Parameters.Add("@HinhThucThi", SqlDbType.NVarChar).Value = hinhThucThi;
            cmd.Parameters.Add("@ThoiGianThi", SqlDbType.Int).Value = (int)thoiGianThi;
            cmd.Parameters.Add("@DeCuongChiTiet", SqlDbType.NText).Value = deCuongChiTiet;

            int result = cmd.ExecuteNonQuery();
            conn.Close();
            return result;
        }

        [WebMethod(Description = "CauHinhMonHoc_UpdateStatus(string maMonHoc, bool dangBiKhoa, string userName, string password); False: Mở khóa, True: Đang bị khóa; Trả về 1 khi cập nhật thành công")]
        public int CauHinhMonHoc_UpdateStatus(string maMonHoc, bool dangBiKhoa, string userName, string password)
        {
            TestAuthentication(userName, password);

            //string cnStr = ConfigurationManager.ConnectionStrings["EduMngConnectionString"].ConnectionString;
            SqlConnection conn = getConnection();

            conn.Open();
            SqlCommand cmd = new SqlCommand("uspCauHinhMonHoc_UpdateStatus", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;
            cmd.Parameters.Add("@DangBiKhoa", SqlDbType.Bit).Value = dangBiKhoa;

            int result = cmd.ExecuteNonQuery();
            conn.Close();
            return result;
        }

        private void TestAuthentication(string userName, string password)
        {
            string user = System.Configuration.ConfigurationManager.AppSettings["Username"].ToString();
            string pass = System.Configuration.ConfigurationManager.AppSettings["Password"].ToString();

            if (string.Compare(userName, user, true) != 0 || password != Encrypt(pass, key, true))
            {
                throw new Exception("User authentication is not valid.");
            }

        }

        public static string Encrypt(string toEncrypt, string key, bool useHashing)
        {
            byte[] keyArray;
            byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(toEncrypt);

            if (useHashing)
            {
                MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
                keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
            }
            else
                keyArray = UTF8Encoding.UTF8.GetBytes(key);

            TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
            tdes.Key = keyArray;
            tdes.Mode = CipherMode.ECB;
            tdes.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = tdes.CreateEncryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

            return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        }

        public static string Decrypt(string toDecrypt, string key, bool useHashing)
        {
            byte[] keyArray;
            byte[] toEncryptArray = Convert.FromBase64String(toDecrypt);

            if (useHashing)
            {
                MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
                keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
            }
            else
                keyArray = UTF8Encoding.UTF8.GetBytes(key);

            TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
            tdes.Key = keyArray;
            tdes.Mode = CipherMode.ECB;
            tdes.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = tdes.CreateDecryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

            return UTF8Encoding.UTF8.GetString(resultArray);
        }

        
        //End Sổ đầu bài


        // Chuyển điểm quá trình

        [WebMethod(Description = "DiemQuaTrinh_Insert(string maSinhVien, string maLopHanhChinh, string maMonHoc, int diemQuaTrinh, string namHoc, int hocKy, string userName, string password); 0: Không chuyển được, 1: Chuyển thành công, 2: Đã có điểm, không chuyển điểm; 3: Chưa phân môn học cho sinh viên")]
        public DataTable DiemQuaTrinh_Insert(string maSinhVien, string maLopHanhChinh, string maMonHoc, int diemQuaTrinh, string namHoc, int hocKy, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TrangThaiCapNhat");
            dt.Columns.Add("TrangThai");

            conn.Open();
            DataTable dt1 = new DataTable("DiemQuaTrinh");
            SqlCommand cmd1 = new SqlCommand("uspDiemQuaTrinh_Exist", conn);
            cmd1.CommandType = CommandType.StoredProcedure;
            cmd1.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
            cmd1.Parameters.Add("@MaLopHanhChinh", SqlDbType.NVarChar).Value = maLopHanhChinh;
            cmd1.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;
            cmd1.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
            cmd1.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;

            SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
            da1.Fill(dt1);
            conn.Close();
            if (dt1.Rows.Count > 0)
            {
                dt.Rows.Add(2);
                return dt;
            }

            conn.Open();
            DataTable dt2 = new DataTable("PhanMon");
            SqlCommand cmd2 = new SqlCommand("uspPhanMonCuaSinhVienTheoKyHienTai_VP", conn);
            cmd2.CommandType = CommandType.StoredProcedure;
            cmd2.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
            cmd2.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;

            SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
            da2.Fill(dt2);
            conn.Close();
            if (dt2.Rows.Count == 0)
            {
                dt.Rows.Add(3);
                return dt;
            }

            try
            {
                conn.Open();
                SqlCommand cmd3 = new SqlCommand("uspDiemQuaTrinh_Insert", conn);
                cmd3.CommandType = CommandType.StoredProcedure;
                cmd3.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd3.Parameters.Add("@MaLopHanhChinh", SqlDbType.NVarChar).Value = maLopHanhChinh;
                cmd3.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;
                cmd3.Parameters.Add("@Diem", SqlDbType.Int).Value = (int)diemQuaTrinh;
                cmd3.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd3.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;

                int result3 = cmd3.ExecuteNonQuery();
                conn.Close();
                if (result3 > 0)
                {
                    dt.Rows.Add(1);
                    return dt;
                }
                else
                {
                    dt.Rows.Add(0);
                    return dt;
                }
            }
            catch (Exception)
            {
                dt.Rows.Add(0);
                return dt;
            }

        }


        // Tạo lớp tín chỉ từ lớp môn của niên chế
        // Đăng ký tự động môn cho sinh viên

        [WebMethod(Description = "Lớp niên chế được phân môn trong kỳ : LopNienCheCoPhanMon(namhoc,hocky) ; Output(MaLop)")]
        public DataTable LopNienCheCoPhanMon(string namhoc, int hocky)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopNienCheCoPhanMon");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspLopNienCheCoPhanMon", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namhoc;
            cmd.Parameters.Add("@Hocky", SqlDbType.Int).Value = hocky;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Danh sách môn học của lớp niên chế được phân môn trong kỳ theo lớp niên chế

        [WebMethod(Description = "Danh sách môn học của lớp niên chế được phân môn trong kỳ : MonHocLopNienChe(namhoc,hocky,malop) ; Output(Namhoc,hocky,Malop,Makhoa,MaheDaotao,SoTinChi,GiaTinChi,TrangThai)")]
        public DataTable MonHocLopNienChe(string namhoc,int hocky,string malop )
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("uspMonHocLopNienChe");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonHocLopNienChe", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namhoc;
            cmd.Parameters.Add("@Hocky", SqlDbType.Int).Value = hocky;
            cmd.Parameters.Add("@Malop", SqlDbType.NVarChar).Value = malop;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Tính toán lại học phí tín chỉ theo sinh viên

        [WebMethod(Description = "Tính toán lại học phí tín chỉ theo sinh viên: UpdateHocPhiTinChi(Masinhvien) ; Output()")]
        public DataTable UpdateHocPhiTinChi(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("UpdateHocPhiTinChi");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspUpdateHocPhiTinChi", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Danh sách sinh viên theo lớp niên chế

        [WebMethod(Description = "Danh sách sinh viên theo lớp niên chế: SinhVienLopNienChe(Malop) ; Output(Masinhvien,Hodem,Ten,NgaySinh,Malop)")]
        public DataTable SinhVienLopNienChe(string malop)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhVienLopNienChe");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspSinhVienLopNienChe", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Malop", SqlDbType.NVarChar).Value = malop;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        [WebMethod(Description = "LopTinChi_Create(string maLop, string maMonHoc, string namHoc, int hocKy, int khoiLuong, string userName, string password); 0: Không tạo được, 1: Tạo thành công, 2: Đã có lớp")]
        public DataTable LopTinChi_Create(string maLop, string maMonHoc, string namHoc, int hocKy, int khoiLuong, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("TrangThai");
            dt.Columns.Add("TrangThai");

            try
            {
                conn.Open();
                DataTable dt1 = new DataTable("LopTinChi");
                SqlCommand cmd1 = new SqlCommand("uspLopTinChi_Exist", conn);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@MaLop", SqlDbType.NVarChar).Value = maLop;
                cmd1.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd1.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;

                SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
                da1.Fill(dt1);
                conn.Close();
                if (dt1.Rows.Count > 0)
                {
                    dt.Rows.Add(2);
                    return dt;
                }

                conn.Open();
                SqlCommand cmd = new SqlCommand("uspLopTinChi_Create", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MaLop", SqlDbType.NVarChar).Value = maLop;
                cmd.Parameters.Add("@MaMonHoc", SqlDbType.NVarChar).Value = maMonHoc;
                cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;
                cmd.Parameters.Add("@KhoiLuong", SqlDbType.Int).Value = (int)khoiLuong;
                int result = cmd.ExecuteNonQuery();
                conn.Close();
                if (result > 0)
                {
                    dt.Rows.Add(1);
                    return dt;
                }
                else
                {
                    dt.Rows.Add(0);
                    return dt;
                }
            }
            catch (Exception)
            {
                dt.Rows.Add(0);
                return dt;
            }

        }

        [WebMethod(Description = "LopTinChi_SinhVien_Create(string maLop, string maSinhVien, string namHoc, int hocKy, float hocPhi, string userName, string password); 0: Không đăng ký được, 1: Đăng ký thành công, 2: Sinh viên đã đăng ký")]
        public DataTable LopTinChi_SinhVien_Create(string maLop, string maSinhVien, string namHoc, int hocKy, float hocPhi, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();
            SqlTransaction transaction;

            DataTable dt = new DataTable("TrangThai");
            dt.Columns.Add("TrangThai");

            try
            {
                conn.Open();
                transaction = conn.BeginTransaction();
            }
            catch (Exception)
            {

                throw new Exception("Connect Database error!");
            }

            try
            {
                SqlConnection conn1 = getConnection();
                DataTable dt1 = new DataTable("LopTinChi_SinhVien");
                SqlCommand cmd1 = new SqlCommand("uspLopTinChi_SinhVien_Exist", conn1);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@MaLop", SqlDbType.NVarChar).Value = maLop;
                cmd1.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd1.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd1.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;

                SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
                da1.Fill(dt1);
                conn1.Close();
                if (dt1.Rows.Count > 0)
                {
                    dt.Rows.Add(2);
                    return dt;
                }

                SqlCommand cmd = new SqlCommand("uspLopTinChi_SinhVien_Create", conn, transaction);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MaLop", SqlDbType.NVarChar).Value = maLop;
                cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;
                cmd.Parameters.Add("@HocPhi", SqlDbType.Float).Value = (float)hocPhi;
                cmd.ExecuteNonQuery();

                SqlCommand cmd2 = new SqlCommand("uspUpdateHocPhiTinChi", conn, transaction);
                cmd2.CommandType = CommandType.StoredProcedure;
                cmd2.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd2.ExecuteNonQuery();

                transaction.Commit();
                conn.Close();
                dt.Rows.Add(1);
                return dt;
            }
            catch (Exception)
            {
                transaction.Rollback();
                conn.Close();
                dt.Rows.Add(0);
                return dt;
            }

        }


        [WebMethod(Description = "LopTinChi_SinhVien_Delete(string maLop, string maSinhVien, string namHoc, int hocKy, string userName, string password); 0: Không hủy đăng ký được, 1: Hủy đăng ký thành công")]
        public DataTable LopTinChi_SinhVien_Delete(string maLop, string maSinhVien, string namHoc, int hocKy, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();
            SqlTransaction transaction;

            DataTable dt = new DataTable("TrangThai");
            dt.Columns.Add("TrangThai");

            try
            {
                conn.Open();
                transaction = conn.BeginTransaction();
            }
            catch (Exception)
            {

                throw new Exception("Connect Database error!");
            }

            try
            {
                SqlCommand cmd = new SqlCommand("uspLopTinChi_SinhVien_Delete", conn, transaction);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MaLop", SqlDbType.NVarChar).Value = maLop;
                cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;
                cmd.ExecuteNonQuery();

                SqlCommand cmd2 = new SqlCommand("uspUpdateHocPhiTinChi", conn, transaction);
                cmd2.CommandType = CommandType.StoredProcedure;
                cmd2.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd2.ExecuteNonQuery();

                transaction.Commit();
                conn.Close();
                dt.Rows.Add(1);
                return dt;
            }
            catch (Exception)
            {
                transaction.Rollback();
                conn.Close();
                dt.Rows.Add(0);
                return dt;
            }

        }

        [WebMethod(Description = "HPU_Log_Create(string logTitle, string logUserName, DateTime logTime, string moduleName, string logContents, string userName, string password); 0: Không ghi log được, 1: Ghi log thành công")]
        public DataTable HPU_Log_Create(string logTitle, string logUserName, DateTime logTime, string moduleName, string logContents, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();

            DataTable dt = new DataTable("TrangThai");
            dt.Columns.Add("TrangThai");

            try
            {
                conn.Open();
            }
            catch (Exception)
            {

                throw new Exception("Connect Database error!");
            }

            try
            {
                SqlCommand cmd = new SqlCommand("uspHPU_Log_Create", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@LogTitle", SqlDbType.NVarChar).Value = logTitle;
                cmd.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = logUserName;
                cmd.Parameters.Add("@LogTime", SqlDbType.DateTime).Value = logTime;
                cmd.Parameters.Add("@ModuleName", SqlDbType.NVarChar).Value = moduleName;
                cmd.Parameters.Add("@LogContents", SqlDbType.NVarChar).Value = logContents;
                cmd.ExecuteNonQuery();

                conn.Close();
                dt.Rows.Add(1);
                return dt;
            }
            catch (Exception)
            {
                conn.Close();
                dt.Rows.Add(0);
                return dt;
            }

        }

        // Lớp tín chỉ trong kỳ.

        [WebMethod(Description = "Danh sách các lớp tín chỉ: LopTinChiTrongKy(namhoc,hocky) ; Output(LopMonHoc,MaMonHoc,TenMonHoc,NamHoc,HocKy)")]
        public DataTable LopTinChiTrongKy(string namhoc, int hocky)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("uspLopTinChiTrongKy");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspLopTinChiTrongKy", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Namhoc", SqlDbType.NVarChar).Value = namhoc;
            cmd.Parameters.Add("@hocky", SqlDbType.Int).Value = hocky;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Danh sách sinh viên lớp tín chỉ trong kỳ.

        [WebMethod(Description = "Danh sách sinh viên lớp tín chỉ: SinhVienLopTinChi(namhoc,hocky,malop) ; Output(MaSinhVien,HoDem,Ten,NgaySinh,GioiTinh,LopQuanLy,LopMonHoc,MaMonHoc,TenMonHoc,NamHoc,HocKy)")]
        public DataTable SinhVienLopTinChi(string malop, string namhoc, int hocky)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("SinhVienLopTinChi");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspSinhVienLopTinChi", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Namhoc", SqlDbType.NVarChar).Value = namhoc;
            cmd.Parameters.Add("@hocky", SqlDbType.Int).Value = hocky;
            cmd.Parameters.Add("@Malop", SqlDbType.NVarChar).Value = malop;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        public object namHoc { get; set; }

        public int hocKy { get; set; }

        [WebMethod(Description = "LopTinChi_SinhVien_DoiLop(string maLop, string maSinhVien, string maLopMoi, string namHoc, int hocKy, string userName, string password); 0: Không đổi lớp được, 1: Đổi lớp thành công")]
        public DataTable LopTinChi_SinhVien_DoiLop(string maLop, string maSinhVien, string maLopMoi, string namHoc, int hocKy, string userName, string password)
        {
            TestAuthentication(userName, password);

            SqlConnection conn = getConnection();

            DataTable dt = new DataTable("TrangThai");
            dt.Columns.Add("TrangThai");

            try
            {
                conn.Open();
            }
            catch (Exception)
            {

                throw new Exception("Connect Database error!");
            }

            try
            {
                SqlCommand cmd = new SqlCommand("uspLopTinChi_SinhVien_DoiLop", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MaLop", SqlDbType.NVarChar).Value = maLop;
                cmd.Parameters.Add("@MaSinhVien", SqlDbType.NVarChar).Value = maSinhVien;
                cmd.Parameters.Add("@MaLopMoi", SqlDbType.NVarChar).Value = maLopMoi;
                cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namHoc;
                cmd.Parameters.Add("@HocKy", SqlDbType.Int).Value = (int)hocKy;
                int return_value = cmd.ExecuteNonQuery();

                conn.Close();
                if (return_value == 1)
                {
                    dt.Rows.Add(1);
                }
                else
                {
                    dt.Rows.Add(0);
                }
                return dt;
            }
            catch (Exception)
            {
                conn.Close();
                dt.Rows.Add(0);
                return dt;
            }

        }


        // Danh sách các lớp tín chỉ được tách

        [WebMethod(Description = "Các lớp tín chỉ được tách trong kỳ : LopTinChiTach(namhoc,hocky) ; Output(MaLop,MaMonHoc,SoLopTach)")]
        public DataTable LopTinChiTach(string namhoc, int hocky)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("LopTinChiTach");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspLopTinChiTach", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@NamHoc", SqlDbType.NVarChar).Value = namhoc;
            cmd.Parameters.Add("@Hocky", SqlDbType.Int).Value = hocky;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Tìm kiếm môn học của sinh viên theo khung chương trình đào tạo

        [WebMethod(Description = "Tìm kiếm môn học của sinh viên theo khung chương trình đào tạo : MonHocTheoKhungChuongTrinh(masinhvien,mamonhoc_3_ky_tu_dau,stt) ; Output(mamonhoc)")]
        public DataTable MonHocTheoKhungChuongTrinh(string masinhvien, string mamon,int stt)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHocTheoKhungChuongTrinh");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonHocTheoKhungChuongTrinh", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            cmd.Parameters.Add("@Mamon", SqlDbType.NVarChar).Value = mamon;
            cmd.Parameters.Add("@stt", SqlDbType.Int).Value =stt;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Môn học còn thiếu học phí

        [WebMethod(Description = "Môn học còn thiếu học phí: MonHocConThieuTien(masinhvien) ; Output(MaSinhVien,MaLop,MaMonHoc,TenMonHoc,KhoiLuong,NamHoc,HocKy,HocPhi,soTienDaNop)")]
        public DataTable MonHocConThieuTien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHocConThieuTien");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonHocConThieuTien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Môn học học lại còn thiếu học phí

        [WebMethod(Description = "Môn học lại còn thiếu học phí: MonHocLaiConThieuTien(masinhvien) ; Output(MaSinhVien,MaLop,MaMonHoc,TenMonHoc,KhoiLuong,NamHoc,HocKy,HocPhi,soTienDaNop)")]
        public DataTable MonHocLaiConThieuTien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHocLaiConThieuTien");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonHocLaiConThieuTien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Môn học bổ sung còn thiếu học phí

        [WebMethod(Description = "Môn học bổ sung còn thiếu học phí: MonHocBoSungConThieuTien(masinhvien) ; Output(MaSinhVien,MaLop,MaMonHoc,TenMonHoc,KhoiLuong,NamHoc,HocKy,HocPhi,soTienDaNop)")]
        public DataTable MonHocBoSungConThieuTien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("MonHocBoSungConThieuTien");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspMonHocBoSungConThieuTien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Học phí học lại kỳ phụ còn thiếu

        [WebMethod(Description = "Học phí học lại kỳ phụ còn thiếu: HocLaiKyPhuThieuTien(masinhvien) ; Output(maSinhVien,namHoc,hocKy,soTienQuyDinh,SoTienThayDoi,soTienMienGiam,SoTienKyTruocChuyenSang,SoTienDaThu,SoTienPhaiChi,SoTienDaChi,SoTienChuyenSangKySau,thieu,chitiet)")]
        public DataTable HocLaiKyPhuThieuTien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("HocLaiKyPhuThieuTien");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspHocLaiKyPhuThieuTien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        // Học phí học bổ sung kỳ phụ còn thiếu

        [WebMethod(Description = "Học phí học lại kỳ phụ còn thiếu: HocBoSungKyPhuThieuTien(masinhvien) ; Output(maSinhVien,namHoc,hocKy,soTienQuyDinh,SoTienThayDoi,soTienMienGiam,SoTienKyTruocChuyenSang,SoTienDaThu,SoTienPhaiChi,SoTienDaChi,SoTienChuyenSangKySau,thieu,chitiet)")]
        public DataTable HocBoSungKyPhuThieuTien(string masinhvien)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("HocBoSungKyPhuThieuTien");
            //string sql;
            SqlCommand cmd = new SqlCommand("uspHocBoSungKyPhuThieuTien", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Masinhvien", SqlDbType.NVarChar).Value = masinhvien;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
        
    }
         
}
