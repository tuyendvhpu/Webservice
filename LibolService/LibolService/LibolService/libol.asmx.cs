using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

namespace LibolService
{
    /// <summary>
    /// Summary description for Service1
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    public class Service1 : System.Web.Services.WebService
    {

        [WebMethod]
        private SqlConnection getConnection()
        {
            SqlConnection conn = new SqlConnection("Server=localhost;Database=LIBOL60;UID=...;PWD=...");
            return conn;
        }

        [WebMethod(Description = "Danh sách bạn đọc quá hạn: DataTable BanDocQuaHan(string mabandoc ) Input(mabandoc='1112404061'); Output(MaBanDoc, NgayPhaiTra, NgayMuonSach, MaAnPham, SoNgayQuaHan)")]
        public DataTable BanDocQuaHan(string code)
        {
            SqlConnection conn = getConnection();
            DataTable dt = new DataTable("BanDocQuaHan");
            //string sql;

            SqlCommand cmd = new SqlCommand("uspBanDocMuonQuaHan", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@code", SqlDbType.NVarChar).Value = code;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            conn.Close();
            return dt;
        }
    }
}