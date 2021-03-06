SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE uspBangDiem
	-- Add the parameters for the stored procedure here
	@MaSinhVien NVARCHAR(20)
WITH ENCRYPTION
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT A.MaSinhVien,
	A.NamHoc
	,A.HocKy
	, A.MaMonHoc
	,CASE WHEN C.TenMonHoc IS NULL THEN (SELECT TenMonHoc FROM MonHoc WHERE MaMonHoc = A.MaMonHoc)
		ELSE C.TenMonHoc
	END TenMocHoc
	,C.KL
	,ISNULL(CAST(D.TyLeDiem AS NVARCHAR(3)) + '/','') + CAST(B.TyLeDiem AS NVARCHAR(3)) AS TyLeDiem
	,D.DQT
	,B.DiemThi1
	,A.DiemTH1
	,B.DiemThi2
	,A.DiemTH2
	,CASE WHEN C.TenMonHoc IS NULL THEN N'Ngoài CT'	END GhiChu
FROM	(SELECT MaSinhVien
				,MaMonHoc
				,NamHoc
				,HocKy
				,[1] DiemTH1
				,[2] DiemTH2
			FROM
				(SELECT MaSinhVien
					,MaMonHoc
					,NamHoc
					,HocKy
					,LanThu
					,Diem
				FROM SV_DiemTrungBinhMonHoc
				WHERE MaSinhVien = @MaSinhVien) p
			PIVOT
				(
					MAX(Diem)
					FOR LanThu IN ([1], [2])
				) AS pvt1
			) A LEFT JOIN	(SELECT MaSinhVien
							,MaMonHoc
							,NamHoc
							,HocKy
							,TyLeDiem
							,[1] DiemThi1
							,[2] DiemThi2
						FROM
							(SELECT MaSinhVien
								,MaMonHoc
								,NamHoc
								,HocKy
								,TyLeDiem
								,CASE WHEN ApDungDiemPhucKhao = 1 THEN DiemPhucKhao ELSE Diem END Diem
								,LanThu
							FROM SV_DiemKiemTra_ThiHK 
							WHERE MaSinhVien = @MaSinhVien) p
						PIVOT
							(
								MAX(Diem)
								FOR LanThu IN ([1], [2])
							) AS pvt2
						) B
					ON A.MaSinhVien = B.MaSinhVien
					AND A.MaMonHoc = B.MaMonHoc
					AND A.NamHoc = B.NamHoc
					AND A.HocKy = B.HocKy LEFT JOIN (SELECT DISTINCT MaSinhVien
														  ,MaMonHoc
														  ,TenMonHoc
														  ,TongSo KL
													  FROM QEd_TCKhung
													  WHERE MaSinhVien = @MaSinhVien) C
												ON A.MaSinhVien = C.MaSinhVien
												AND A.MaMonHoc = C.MaMonHoc  LEFT JOIN	(SELECT MaSinhVien
																						,NamHoc
																						,HocKy
																						,MaMonHoc
																						,Diem DQT
																						,TyLeDiem
																					FROM SV_DiemChiTiet 
																					WHERE MaSinhVien = @MaSinhVien
																						AND LoaiDiem = 'QT') D
																			ON A.MaSinhVien = D.MaSinhVien
																				AND A.MaMonHoc = D.MaMonHoc
																				AND A.NamHoc = D.NamHoc
																				AND A.HocKy = D.HocKy
																					
ORDER BY NamHoc, HocKy, TenMonHoc
END
GO
----------------------------------------------------------------------------------------------------------------


--Hàm loại bỏ dấu và ký tự đặc biệt
CREATE FUNCTION [dbo].[usp_nosymbol]
(
@input_string NVARCHAR (4000)
)
RETURNS VARCHAR (4000)
AS
BEGIN
DECLARE @l_str NVARCHAR(4000);
SET @l_str = LTRIM(@input_string);
SET @l_str = LOWER(RTRIM(@l_str));

SET @l_str = REPLACE(@l_str, N'á', 'a');

SET @l_str = REPLACE(@l_str, N'à', 'a');
SET @l_str = REPLACE(@l_str, N'ả', 'a');
SET @l_str = REPLACE(@l_str, N'ã', 'a');
SET @l_str = REPLACE(@l_str, N'ạ', 'a');

SET @l_str = REPLACE(@l_str, N'â', 'a');
SET @l_str = REPLACE(@l_str, N'ấ', 'a');
SET @l_str = REPLACE(@l_str, N'ầ', 'a');
SET @l_str = REPLACE(@l_str, N'ẩ', 'a');
SET @l_str = REPLACE(@l_str, N'ẫ', 'a');
SET @l_str = REPLACE(@l_str, N'ậ', 'a');

SET @l_str = REPLACE(@l_str, N'ă', 'a');
SET @l_str = REPLACE(@l_str, N'ắ', 'a');
SET @l_str = REPLACE(@l_str, N'ằ', 'a');
SET @l_str = REPLACE(@l_str, N'ẳ', 'a');
SET @l_str = REPLACE(@l_str, N'ẵ', 'a');
SET @l_str = REPLACE(@l_str, N'ặ', 'a');

SET @l_str = REPLACE(@l_str, N'é', 'e');
SET @l_str = REPLACE(@l_str, N'è', 'e');
SET @l_str = REPLACE(@l_str, N'ẻ', 'e');
SET @l_str = REPLACE(@l_str, N'ẽ', 'e');
SET @l_str = REPLACE(@l_str, N'ẹ', 'e');

SET @l_str = REPLACE(@l_str, N'ê', 'e');
SET @l_str = REPLACE(@l_str, N'ế', 'e');
SET @l_str = REPLACE(@l_str, N'ề', 'e');
SET @l_str = REPLACE(@l_str, N'ể', 'e');
SET @l_str = REPLACE(@l_str, N'ễ', 'e');
SET @l_str = REPLACE(@l_str, N'ệ', 'e');

SET @l_str = REPLACE(@l_str, N'í', 'i');
SET @l_str = REPLACE(@l_str, N'ì', 'i');
SET @l_str = REPLACE(@l_str, N'ỉ', 'i');
SET @l_str = REPLACE(@l_str, N'ĩ', 'i');
SET @l_str = REPLACE(@l_str, N'ị', 'i');

SET @l_str = REPLACE(@l_str, N'ó', 'o');
SET @l_str = REPLACE(@l_str, N'ò', 'o');
SET @l_str = REPLACE(@l_str, N'ỏ', 'o');
SET @l_str = REPLACE(@l_str, N'õ', 'o');
SET @l_str = REPLACE(@l_str, N'ọ', 'o');

SET @l_str = REPLACE(@l_str, N'ô', 'o');
SET @l_str = REPLACE(@l_str, N'ố', 'o');
SET @l_str = REPLACE(@l_str, N'ồ', 'o');
SET @l_str = REPLACE(@l_str, N'ổ', 'o');
SET @l_str = REPLACE(@l_str, N'ỗ', 'o');
SET @l_str = REPLACE(@l_str, N'ộ', 'o');

SET @l_str = REPLACE(@l_str, N'ơ', 'o');
SET @l_str = REPLACE(@l_str, N'ớ', 'o');
SET @l_str = REPLACE(@l_str, N'ờ', 'o');
SET @l_str = REPLACE(@l_str, N'ở', 'o');
SET @l_str = REPLACE(@l_str, N'ỡ', 'o');
SET @l_str = REPLACE(@l_str, N'ợ', 'o');

SET @l_str = REPLACE(@l_str, N'ú', 'u');
SET @l_str = REPLACE(@l_str, N'ù', 'u');
SET @l_str = REPLACE(@l_str, N'ủ', 'u');
SET @l_str = REPLACE(@l_str, N'ũ', 'u');
SET @l_str = REPLACE(@l_str, N'ụ', 'u');

SET @l_str = REPLACE(@l_str, N'ư', 'u');
SET @l_str = REPLACE(@l_str, N'ứ', 'u');
SET @l_str = REPLACE(@l_str, N'ừ', 'u');
SET @l_str = REPLACE(@l_str, N'ử', 'u');
SET @l_str = REPLACE(@l_str, N'ữ', 'u');
SET @l_str = REPLACE(@l_str, N'ự', 'u');

SET @l_str = REPLACE(@l_str, N'ý', 'y');
SET @l_str = REPLACE(@l_str, N'ỳ', 'y');
SET @l_str = REPLACE(@l_str, N'ỷ', 'y');
SET @l_str = REPLACE(@l_str, N'ỹ', 'y');
SET @l_str = REPLACE(@l_str, N'ỵ', 'y');

SET @l_str = REPLACE(@l_str, N'đ', 'd');

--SET @l_str = REPLACE(@l_str, ' ', '-');
--SET @l_str = REPLACE(@l_str, '~', '-');
--SET @l_str = REPLACE(@l_str, '?', '-');
--SET @l_str = REPLACE(@l_str, '@', '-');
--SET @l_str = REPLACE(@l_str, '#', '-');
--SET @l_str = REPLACE(@l_str, '$', '-');
--SET @l_str = REPLACE(@l_str, '^', '-');
--SET @l_str = REPLACE(@l_str, '&', '-');
--SET @l_str = REPLACE(@l_str, '/', '-');

--SET @l_str = REPLACE(@l_str, '(', '');
--SET @l_str = REPLACE(@l_str, ')', '');
--SET @l_str = REPLACE(@l_str, '[', '');
--SET @l_str = REPLACE(@l_str, ']', '');
--SET @l_str = REPLACE(@l_str, '{', '');
--SET @l_str = REPLACE(@l_str, '}', '');
--SET @l_str = REPLACE(@l_str, '<', '');
--SET @l_str = REPLACE(@l_str, '>', '');
--SET @l_str = REPLACE(@l_str, '|', '');
--SET @l_str = REPLACE(@l_str, '"', '');
--SET @l_str = REPLACE(@l_str, '%', '');
--SET @l_str = REPLACE(@l_str, '^', '');
--SET @l_str = REPLACE(@l_str, '*', '');
--SET @l_str = REPLACE(@l_str, '!', '');
--SET @l_str = REPLACE(@l_str, ',', '');
--SET @l_str = REPLACE(@l_str, '.', '');

--SET @l_str = REPLACE(@l_str, '---', '-');
--SET @l_str = REPLACE(@l_str, '--', '-');
SET @l_str = REPLACE(@l_str, ' ', '');
RETURN @l_str;
END
Go
GRANT EXECUTE ON dbo.usp_nosymbol To ws;


--------------------------------------------------------------
-- Bảng điểm tổng hợp toàn khóa sinh viên                 ----*

--Created 06/03/2015
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspBangDiemToanKhoa' ) IS NOT NULL 
    DROP PROCEDURE uspBangDiemToanKhoa;
GO
CREATE PROC dbo.uspBangDiemToanKhoa
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS


Select MaSinhVien,MaMonHoc,TenMonHoc,KL KhoiLuong,NamHoc,Diem DiemThang10, DiemThang4 = CASE WHEN (Diem >=0 and Diem <4)    THEN 0
																									WHEN (Diem >=4 and Diem <5.5) THEN 1
																									WHEN (Diem >=5.5 and Diem <7) THEN 2
																									WHEN (Diem >=7 and Diem <8.5)  THEN 3
																									WHEN (Diem >=8.5 and Diem <=10)THEN 4 END,
																				DiemChu = CASE WHEN (Diem >=0 and Diem <4)    THEN 'F'
																									WHEN (Diem >=4 and Diem <5.5) THEN 'D'
																									WHEN (Diem >=5.5 and Diem <7)   THEN 'C'
																									WHEN (Diem >=7 and Diem <8.5)  THEN 'B'
																									WHEN (Diem >=8.5 and Diem <=10)THEN 'A' END,GhiChu 					       
From (
Select S1.MaSinhVien,S1.MaMonHoc,M.TenMonHoc,S1.KL,S1.GhiChu,MIN(S1.NamHoc)NamHoc, MAX(S1.Diem) Diem
FROM (
SELECT MaSinhVien,MaMonHoc,TenMonHoc,KL,NamHoc,HocKy,Diem= CASE WHEN ISNULL(S.DiemTH1,0)>=ISNULL(S.DiemTH2,0) THEN S.DiemTH1 
																WHEN ISNULL(S.DiemTH2,0)>=ISNULL(S.DiemTH1,0) THEN S.DiemTH2 END,
																CASE WHEN TenMonHoc IS NULL THEN N'Ngoài CT'	END GhiChu    
FROM (
SELECT A.MaSinhVien,A.MaMonHoc,C.TenMonHoc,C.KL,A.NamHoc,A.HocKy,A.DiemTH1,A.DiemTH2
FROM (
SELECT MaSinhVien,MaMonHoc,NamHoc,HocKy ,[1] DiemTH1,[2] DiemTH2
			FROM
				(SELECT MaSinhVien
					,MaMonHoc
					,NamHoc
					,HocKy
					,LanThu
					,Diem
				FROM SV_DiemTrungBinhMonHoc
				WHERE LEFT(Mamonhoc,3) not in ('SWI','FLS','FOO','COS','BAD','APE','NDE','VOL') and MaSinhVien = @Masinhvien) p
			PIVOT
				(
					MAX(Diem)
					FOR LanThu IN ([1], [2])
				) AS pvt1
) A LEFT OUTER JOIN (SELECT DISTINCT MaSinhVien
														  ,MaMonHoc
														  ,TenMonHoc
														  ,TongSo KL
													  FROM QEd_TCKhung
													  WHERE MaSinhVien = @Masinhvien) C
												ON A.MaSinhVien = C.MaSinhVien AND A.MaMonHoc = C.MaMonHoc


) S
) S1
INNER JOIN MonHoc M ON S1.MaMonHoc=M.MaMonHoc
Group by  S1.MaSinhVien,S1.MaMonHoc,M.TenMonHoc,S1.KL,S1.GhiChu
) Diem
ORDER BY NamHoc,MaMonHoc

GO
GRANT EXECUTE ON uspBangDiemToanKhoa To ws;

-----------------------------------------------------------------------------


--Bảng điểm chi tiết sinh viên
DECLARE @Namhoc AS nvarchar(10),@Hocky AS int, @Masinhvien AS nvarchar(10)  
Set @Namhoc='2010-2011'
Set @Hocky=2
Set @Masinhvien='100274'
Select T.MaSinhVien,S.HoDem,S.Ten,S.MaLop,T.MaMonHoc,M.TenMonHoc,L.MaLop AS LopTC,T.NamHoc,T.HocKy,T.DiemQT,T.[1] As DiemThiL1,'DiemL1'= CASE WHEN T.DiemQT IS NOT NULL THEN ROUND(T.DiemQT*30/100+T.[1]*70/100,0) ELSE T.[1] END ,T.[2] AS DiemThi2,'DiemL2'= CASE WHEN T.DiemQT IS NOT NULL THEN ROUND(T.DiemQT*30/100+T.[2]*70/100,0) ELSE T.[2] END
From (Select *
FROM (Select S1.MaSinhVien,S1.MaMonHoc,S1.NamHoc,S1.HocKy,S2.Diem DiemQT,S1.LanThu,S1.Diem
From SV_DiemKiemTra_ThiHK S1
LEFT OUTER JOIN SV_DiemChiTiet S2 ON S1.MaSinhVien=S2.MaSinhVien AND S1.MaMonHoc=S2.MaMonHoc AND S1.NamHoc=S2.NamHoc AND S1.HocKy=S2.HocKy
--Where S1.NamHoc=@Namhoc And S1.HocKy=@Hocky And S1.MaSinhVien=@Masinhvien
Where S1.MaSinhVien=@Masinhvien
) AS TC
PIVOT (AVG(Diem) For LanThu IN ([1],[2]))as AVGDiem
) AS T
LEFT OUTER JOIN LopTinChi_SinhVien L ON T.MaSinhVien=L.MaSinhVien AND T.MaMonHoc=SUBSTRING(LTRIM(RTRIM(L.MaLop)),1,8) AND T.NamHoc=L.NamHoc AND T.HocKy=L.HocKy AND L.HocPhi<>0
INNER JOIN MonHoc M On T.MaMonHoc=M.MaMonHoc
INNER JOIN SinhVien S On T.MaSinhVien=S.MaSinhVien
Order by S.MaLop,T.NamHoc,T.HocKy,S.Ten,M.TenMonHoc
-----------------------------------------------------------------------
--Danh sách các môn sinh viên được phép cải thiện điểm
-----------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonDuocPhepCaiThienDiem' ) IS NOT NULL 
    DROP PROCEDURE uspMonDuocPhepCaiThienDiem;
GO
CREATE PROC dbo.uspMonDuocPhepCaiThienDiem
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaMonHoc,TenMonHoc,NamHoc,HocKy,dieml1
From (Select T.MaSinhVien,S.HoDem,S.Ten,S.MaLop,T.MaMonHoc,M.TenMonHoc,L.MaLop AS LopTC,T.NamHoc,T.HocKy,T.DiemQT,T.[1] As DiemThiL1,'DiemL1'= CASE WHEN T.DiemQT IS NOT NULL THEN ROUND(T.DiemQT*30/100+T.[1]*70/100,0) ELSE T.[1] END ,T.[2] AS DiemThi2,'DiemL2'= CASE WHEN T.DiemQT IS NOT NULL THEN ROUND(T.DiemQT*30/100+T.[2]*70/100,0) ELSE T.[2] END
From (Select *
FROM (Select S1.MaSinhVien,S1.MaMonHoc,S1.NamHoc,S1.HocKy,S2.Diem DiemQT,S1.LanThu,S1.Diem
From SV_DiemKiemTra_ThiHK S1
LEFT OUTER JOIN SV_DiemChiTiet S2 ON S1.MaSinhVien=S2.MaSinhVien AND S1.MaMonHoc=S2.MaMonHoc AND S1.NamHoc=S2.NamHoc AND S1.HocKy=S2.HocKy
--Where S1.NamHoc=@Namhoc And S1.HocKy=@Hocky And S1.MaSinhVien=@Masinhvien
Where S1.MaSinhVien=@Masinhvien
) AS TC
PIVOT (AVG(Diem) For LanThu IN ([1],[2]))as AVGDiem
) AS T
LEFT OUTER JOIN LopTinChi_SinhVien L ON T.MaSinhVien=L.MaSinhVien AND T.MaMonHoc=SUBSTRING(LTRIM(RTRIM(L.MaLop)),1,8) AND T.NamHoc=L.NamHoc AND T.HocKy=L.HocKy AND L.HocPhi<>0
INNER JOIN MonHoc M On T.MaMonHoc=M.MaMonHoc
INNER JOIN SinhVien S On T.MaSinhVien=S.MaSinhVien
) AS BangDiem
Where DiemL1>=5 and DiemL2 is null
Order by NamHoc,HocKy,TenMonHoc
Go
GRANT EXECUTE ON uspMonDuocPhepCaiThienDiem To ws;

---------------------------------------------------------------
-- Tổng số tín chỉ và môn học sinh viên đã đăng ký trong học kỳ 
--------------------------------------------------------------*

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSoTCSinhVienDK' ) IS NOT NULL 
    DROP PROCEDURE uspSoTCSinhVienDK;
GO
CREATE PROC dbo.uspSoTCSinhVienDK
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select L.MaSinhVien,L.NamHoc,L.HocKy,COUNT(*) AS SoMonHoc,SUM(CAST(SUBSTRING(LTRIM(RTRIM(L.MaLop)),7,1) as InT)) sotc
From LopTinChi_SinhVien L
INNER JOIN SinhVien S ON L.MaSinhVien=S.MaSinhVien
Where L.HocPhi<>0 AND L.MaSinhVien=@Masinhvien 
Group by L.MaSinhVien,L.NamHoc,L.HocKy
ORDER BY L.NamHoc,L.HocKy
Go
GRANT EXECUTE ON uspSoTCSinhVienDK To ws;

----------------------------------------------------------------------*
-- Danh sách sách các môn sinh viên đã đăng ký theo năm học, học kỳ---*
----------------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonhocDaDK' ) IS NOT NULL 
    DROP PROCEDURE uspMonhocDaDK;
GO
CREATE PROC dbo.uspMonhocDaDK
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaSinhVien,NamHoc,HocKy,MaMonHoc,TenMonHoc,sotc,HocPhi,TrangThai
From (Select L.MaSinhVien,L.NamHoc,L.HocKy,MonHoc.MaMonHoc,MonHoc.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(LopTinChi.MaMonHoc)),7,1) as InT) sotc,L.HocPhi,N'Đăng ký học' AS TrangThai
From LopTinChi_SinhVien L 
INNER JOIN LopTinChi ON L.MaLop=LopTinChi.MaLop
INNER JOIN SinhVien S ON L.MaSinhVien=S.MaSinhVien
INNER JOIN MonHoc ON LopTinChi.MaMonHoc=MonHoc.MaMonHoc
Where L.HocPhi>0  AND  L.MaSinhVien=@Masinhvien 
Union
Select S.maSinhVien,S.NamHocLai NamHoc,S.HocKyHocLai Hocky,S.maMonHoc,MonHoc.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(S.maMonHoc)),7,1) as InT) sotc,S.HocPhiHocLai HocPhi,N'Học lại, ghép lớp' AS TrangThai
From SV_HocLai S INNER JOIN MonHoc ON S.maMonHoc=MonHoc.MaMonHoc 
Where S.maSinhVien=@Masinhvien 
Union
Select S.maSinhVien,S.NamHoc NamHoc,S.HocKy,S.maMonHoc,MonHoc.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(S.maMonHoc)),7,1) as InT) sotc,S.HocPhi,N'Học bổ sung,ghép lớp' AS TrangThai
From SV_HocBoSung S INNER JOIN MonHoc ON S.maMonHoc=MonHoc.MaMonHoc 
Where S.maSinhVien=@Masinhvien )
AS MonhocDaDK
Order by NamHoc,HocKy,TenMonHoc
GO
GRANT EXECUTE ON uspMonhocDaDK To ws;
-------------------------------------------------------------------------------------------
--Danh sách các lớp theo khóa, hệ, ngành
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopTheoKhoaHeNganh' ) IS NOT NULL 
    DROP PROCEDURE uspLopTheoKhoaHeNganh;
GO
CREATE PROC dbo.uspLopTheoKhoaHeNganh
@MaKhoaHoc AS nvarchar(5),@MaHeDaoTao AS nvarchar(5),@MaNganh AS nvarchar(10)  
WITH ENCRYPTION
AS
Select MaLop
From LopQuanLy L
Where MaKhoaHoc=@MaKhoaHoc AND MaHeDaoTao=@MaHeDaoTao AND MaNganh=@MaNganh
ORDER BY MaLop
GO
GRANT EXECUTE ON uspLopTheoKhoaHeNganh To ws;
-------------------------------------------------------------------------------------------
--Các môn học được mở trong kỳ của lớp hành chính
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonTheoLopHanhChinhHocKyHienTai' ) IS NOT NULL 
    DROP PROCEDURE uspMonTheoLopHanhChinhHocKyHienTai;
GO
CREATE PROC dbo.uspMonTheoLopHanhChinhHocKyHienTai
@Malop AS nvarchar(10)  
WITH ENCRYPTION
AS
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc,RTRIM(M.TenMonHoc) TenMonHoc 
FROM
       LopQuanLy_MonHoc A 
       INNER JOIN MonHoc M ON A.MaMonHoc=M.MaMonHoc
WHERE
        A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
        AND (CASE WHEN (Select HocKy From HocKy Where HienTai=1)=1 THEN A.HocKy1 
				WHEN (Select HocKy From HocKy Where HienTai=1)=2 THEN A.HocKy2 
				ELSE A.HocKy3 
				 END )>0 AND A.MaLop=@Malop
GO
GRANT EXECUTE ON uspMonTheoLopHanhChinhHocKyHienTai To ws;

-------------------------------------------------------------------------------------------
---Điểm môn học theo lớp hành chính
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDiemMonLopHanhChinh' ) IS NOT NULL 
    DROP PROCEDURE uspDiemMonLopHanhChinh;
GO
CREATE PROC dbo.uspDiemMonLopHanhChinh
@malophc AS nvarchar(10),
@mamonhoc AS nvarchar(8)
WITH ENCRYPTION
AS
Select RTRIM(MaSinhVien) MaSinhVien,RTRIM(HoDem) HoDem,RTRIM(Ten) Ten,NgaySinh,MaMonHoc,TenMonHoc,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, D.[1]),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, D.[2]),'') DiemTHL2
From(
Select *
From (
Select B.MaSinhVien,HoDem,Ten,NgaySinh,B.MaMonHoc,B.Malop,B.MaLopHanhChinh,B.TenMonHoc,B.NamHoc,B.HocKy,B.DQT,B.DiemThiL1,B.DiemThiL2,S2.Diem,S2.LanThu
From
(
--Begin B
Select MaSinhVien,HoDem,Ten,NgaySinh,MaMonhoc,Malop,MaLopHanhChinh,TenMonhoc,NamHoc,HocKy,DQT,[1] As DiemThiL1,[2] DiemThiL2
From (
Select MonDKHoc.MaSinhVien,MonDKHoc.HoDem,MonDKHoc.Ten,MonDKHoc.NgaySinh,MonDKHoc.MaMonHoc,MonDKHoc.Malop,MonDKHoc.MaLopHanhChinh,MonDKHoc.TenMonHoc,MonDKHoc.NamHoc,MonDKHoc.HocKy,S.LoaiDiem,S.Diem DQT,S1.Diem DiemThi,S1.LanThu
From (
SELECT DISTINCT C.MaSinhVien,D.HoDem,D.Ten,D.NgaySinh, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
   
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
        A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
        AND (CASE WHEN (Select HocKy From HocKy Where HienTai=1) =1 THEN A.HocKy1 
				WHEN (Select HocKy From HocKy Where HienTai=1) =2 THEN A.HocKy2 
				ELSE A.HocKy3 
				 END )>0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien AND D.MaLop=@malophc INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) as MonDKHoc
LEFT OUTER JOIN SV_DiemChiTiet S ON MonDKHoc.MaSinhVien=S.MaSinhVien AND MonDKHoc.MaMonHoc=S.MaMonHoc AND MonDKHoc.NamHoc=S.NamHoc AND MonDKHoc.HocKy=S.HocKy and S.LoaiDiem not in ('CS1','CS2','CN1','CN2')
LEFT OUTER JOIN SV_DiemKiemTra_ThiHK S1 ON MonDKHoc.MaSinhVien=S1.MaSinhVien AND MonDKHoc.MaMonHoc=S1.MaMonHoc AND MonDKHoc.NamHoc=S1.NamHoc AND MonDKHoc.HocKy=S1.HocKy 

) AS A
PIVOT (AVG(A.DiemThi) For A.LanThu IN ([1],[2]))as AVGDiem
) AS B 
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON B.MaSinhVien=S2.MaSinhVien AND B.MaMonHoc=S2.MaMonHoc AND B.NamHoc=S2.NamHoc AND B.HocKy=S2.HocKy 

) AS C
PIVOT (AVG(C.Diem) For C.LanThu IN ([1],[2]))as AVGDiem
) AS D
Where  RTRIM(MaLopHanhChinh)=@malophc and RTRIM(MaMonHoc)=@mamonhoc
ORDER BY MaLopHanhChinh,TenMonHoc,Ten
Go
GRANT EXECUTE ON uspDiemMonLopHanhChinh To ws;
--------------------------------------------------------------
---Điểm môn học theo lớp tín chỉ
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDiemMonLopTinChi' ) IS NOT NULL 
    DROP PROCEDURE uspDiemMonLopTinChi;
GO
CREATE PROC dbo.uspDiemMonLopTinChi
@maloptc AS nvarchar(12)

WITH ENCRYPTION
AS
Select RTRIM(MaSinhVien) MaSinhVien,RTRIM(HoDem) HoDem,RTRIM(Ten) Ten,NgaySinh,MaMonHoc,TenMonHoc,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, D.[1]),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, D.[2]),'') DiemTHL2
From(
Select *
From (
Select B.MaSinhVien,HoDem,Ten,NgaySinh,B.MaMonHoc,B.Malop,B.MaLopHanhChinh,B.TenMonHoc,B.NamHoc,B.HocKy,B.DQT,B.DiemThiL1,B.DiemThiL2,S2.Diem,S2.LanThu
From
(
--Begin B
Select MaSinhVien,HoDem,Ten,NgaySinh,MaMonhoc,Malop,MaLopHanhChinh,TenMonhoc,NamHoc,HocKy,DQT,[1] As DiemThiL1,[2] DiemThiL2
From (
Select MonDKHoc.MaSinhVien,MonDKHoc.HoDem,MonDKHoc.Ten,MonDKHoc.NgaySinh,MonDKHoc.MaMonHoc,MonDKHoc.Malop,MonDKHoc.MaLopHanhChinh,MonDKHoc.TenMonHoc,MonDKHoc.NamHoc,MonDKHoc.HocKy,S.LoaiDiem,S.Diem DQT,S1.Diem DiemThi,S1.LanThu
From (
SELECT DISTINCT C.MaSinhVien,D.HoDem,D.Ten,D.NgaySinh, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
   SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.MaLop=@maloptc
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       AND A.MaLop NOT LIKE '%-[1-9]-%'  
       --AND A.MaLop = @malop

) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) as MonDKHoc
LEFT OUTER JOIN SV_DiemChiTiet S ON MonDKHoc.MaSinhVien=S.MaSinhVien AND MonDKHoc.MaMonHoc=S.MaMonHoc AND MonDKHoc.NamHoc=S.NamHoc AND MonDKHoc.HocKy=S.HocKy and S.LoaiDiem not in ('CS1','CS2','CN1','CN2')
LEFT OUTER JOIN SV_DiemKiemTra_ThiHK S1 ON MonDKHoc.MaSinhVien=S1.MaSinhVien AND MonDKHoc.MaMonHoc=S1.MaMonHoc AND MonDKHoc.NamHoc=S1.NamHoc AND MonDKHoc.HocKy=S1.HocKy 

) AS A
PIVOT (AVG(A.DiemThi) For A.LanThu IN ([1],[2]))as AVGDiem
) AS B 
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON B.MaSinhVien=S2.MaSinhVien AND B.MaMonHoc=S2.MaMonHoc AND B.NamHoc=S2.NamHoc AND B.HocKy=S2.HocKy 

) AS C
PIVOT (AVG(C.Diem) For C.LanThu IN ([1],[2]))as AVGDiem
) AS D
Where  RTRIM(Malop)=@maloptc 
ORDER BY MaLopHanhChinh,TenMonHoc,Ten
Go
GRANT EXECUTE ON uspDiemMonLopTinChi To ws;
---------------------------------------------------------------
-- Danh sách sách các môn sinh viên đã đăng ký trong học kỳ 1----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHocTrongKy' ) IS NOT NULL 
    DROP PROCEDURE uspMonHocTrongKy;
GO
CREATE PROC dbo.uspMonHocTrongKy
@Masinhvien AS nvarchar(10)
AS
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, RTRIM(E.TenMonHoc) TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(C.MaMonHoc)),7,1) as InT) SoTC
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       AND A.MaLop NOT LIKE '%-[1-9]-%'  
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND (CASE WHEN (Select HocKy From HocKy Where HienTai=1) =1 THEN A.HocKy1 
				WHEN (Select HocKy From HocKy Where HienTai=1) =2 THEN A.HocKy2 
				ELSE A.HocKy3 
				 END )>0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
Where D.MaSinhVien=@Masinhvien 
Go
GRANT EXECUTE ON uspMonHocTrongKy To ws;
--------------------------------------------------------------
-- Hồ sơ sinh viên, giấy tờ sinh viên đã nộp, chưa nộp    ----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspGiayToDaNop' ) IS NOT NULL 
    DROP PROCEDURE uspGiayToDaNop;
GO
CREATE PROC dbo.uspGiayToDaNop
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT S1.MaSinhVien,L1.MaGiayTo,L2.TenGiayTo,convert(varchar, S2.NgayNop, 103) NgayNop,convert(varchar, S2.NgayTra, 103) NgayTra,Case When L2.BanChinh=1 Then N'Bản chính' ELSE N'Bản sao' END AS Ban,Case When S2.NguoiThu IS NULL THEN N'Chưa nộp' ELSE N'Đã nộp' END AS TrangThai
  FROM LoaiGiayToNhapHoc_PhaiNop L1  
   INNER JOIN SinhVien S1 ON L1.MaNganh=S1.MaNganh AND L1.MaHeDaoTao=S1.MaHeDaoTao AND L1.MaKhoaHoc=S1.MaKhoaHoc
   INNER JOIN LoaiGiayToNhapHoc L2 ON L1.MaGiayTo=L2.MaGiayTo
   LEFT OUTER JOIN SV_GiayTo S2 ON S1.MaSinhVien=S2.MaSinhVien AND L1.MaGiayTo=S2.MaGiayTo    
 WHERE S1.MaSinhVien=@Masinhvien
GO
GRANT EXECUTE ON uspGiayToDaNop To ws;
--------------------------------------------------------------
--Danh sách sinh viên theo khóa, hệ, ngành
 USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhVienKhoaHeNganh' ) IS NOT NULL 
    DROP PROCEDURE uspSinhVienKhoaHeNganh;
GO
CREATE PROC dbo.uspSinhVienKhoaHeNganh
@MaKhoaHoc AS nvarchar(10),
@MaHeDaoTao AS nvarchar(5),
@MaNganh AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,N.MaNganh,N.TenNganh,H.MaHeDaoTao,H.TenHeDaoTao,K.MaKhoaHoc,K.TenKhoaHoc, K.NamVaoTruong,K.NamRaTruong
From SinhVien S
INNER JOIN Nganh N ON S.MaNganh=N.MaNganh
INNER JOIN KhoaHoc K ON S.MaKhoaHoc=K.MaKhoaHoc
INNER JOIN HeDaoTao H ON S.MaHeDaoTao=H.MaHeDaoTao
Where K.NamRaTruong>=YEAR(GETDATE()) AND S.TrangThai not in (1,8,12,101) AND S.MaKhoaHoc=@MaKhoaHoc AND S.MaHeDaoTao=@MaHeDaoTao AND S.MaNganh=@MaNganh
ORDER BY K.TenKhoaHoc,H.TenHeDaoTao,N.TenNganh
GO
GRANT EXECUTE ON uspSinhVienKhoaHeNganh To ws;
----------------------------------------------------------------
--Danh sách các khóa đang học tại trường
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspKhoaDangHoc' ) IS NOT NULL 
    DROP PROCEDURE uspKhoaDangHoc;
GO
CREATE PROC dbo.uspKhoaDangHoc

WITH ENCRYPTION
AS
Select K.MaKhoaHoc,K.TenKhoaHoc
From KhoaHoc K 
Where K.NamRaTruong>=YEAR(GETDATE()) 
ORDER BY K.TenKhoaHoc
GO
GRANT EXECUTE ON uspKhoaDangHoc To ws;
----------------------------------------------------------------
--Danh sách các hệ đào tạo tại trường
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspHeDaoTao' ) IS NOT NULL 
    DROP PROCEDURE uspHeDaoTao;
GO
CREATE PROC dbo.uspHeDaoTao
@MaKhoaHoc AS nvarchar(10)
WITH ENCRYPTION
AS
Select DISTINCT K.MaHeDaoTao,H.TenHeDaoTao,K.MaKhoaHoc
From KhoaHoc_HeDaoTao_Nganh K
INNER JOIN Nganh N ON K.MaNganh=N.MaNganh
INNER JOIN HeDaoTao H ON K.MaHeDaoTao=H.MaHeDaoTao
Where K.MaKhoaHoc=@MaKhoaHoc
ORDER BY H.TenHeDaoTao
GO
GRANT EXECUTE ON uspHeDaoTao To ws;
----------------------------------------------------------------
--Danh sách các ngành theo khóa,hệ đào tạo tại trường
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspNganhTheoKhoaHe' ) IS NOT NULL 
    DROP PROCEDURE uspNganhTheoKhoaHe;
GO
CREATE PROC dbo.uspNganhTheoKhoaHe
@MaKhoaHoc AS nvarchar(10),
@MaHeDaoTao AS nvarchar(10)
WITH ENCRYPTION
AS
Select N.MaNganh,N.TenNganh
From KhoaHoc_HeDaoTao_Nganh K
INNER JOIN Nganh N ON K.MaNganh=N.MaNganh
INNER JOIN HeDaoTao H ON K.MaHeDaoTao=H.MaHeDaoTao
Where K.MaKhoaHoc=@MaKhoaHoc AND K.MaHeDaoTao=@MaHeDaoTao
ORDER BY N.TenNganh
GO
GRANT EXECUTE ON uspNganhTheoKhoaHe To ws;
----------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonDaDangKyThiLai' ) IS NOT NULL 
    DROP PROCEDURE MonDaDangKyThiLai;
GO
CREATE PROC dbo.uspMonDaDangKyThiLai
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.maMonHoc,M.TenMonHoc,S.namHoc,S.hocKy,S.LePhiThiLai,S.LePhiThiLaiDaNop
From SV_DangKyThiLai S INNER JOIN MonHoc M ON S.maMonHoc=M.MaMonHoc 
Where S.MaSinhVien=@Masinhvien
ORDER BY S.namHoc,S.hocKy,M.TenMonHoc 
GO
GRANT EXECUTE ON uspMonDaDangKyThiLai To ws;

--------------------------------------------------------------
-- Tình trạng sinh viên                                   ----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTinhTrangSinhVien' ) IS NOT NULL 
    DROP PROCEDURE uspTinhTrangSinhVien;
GO
CREATE PROC dbo.uspTinhTrangSinhVien
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.HoDem,S.Ten,convert(varchar, S.NgaySinh, 103) NgaySinh,'GioiTinh'=Case When S.GioiTinh=0 Then N'Nữ' When S.GioiTinh=1 Then N'Nam' END,S.MaLop,S.DiaChi,S.DienThoai,S.Email,Nganh.TenNganh,KhoaHoc.TenKhoaHoc,HeDaoTao.TenHeDaoTao,LopQuanLy.DaoTaoTheoTinChi,'DaoTao'= Case When LopQuanLy.DaoTaoTheoTinChi=0 Then N'Niên chế' When LopQuanLy.DaoTaoTheoTinChi=1 Then N'Tín chỉ' END,S.TrangThai,
                            'TinhTrang' = Case When TrangThai=0 Then N'Đang học' 
											   When TrangThai= 1 Then N'Đã chuyển trường'
											   When TrangThai= 2 Then N'Đã chuyển lớp'
											   When TrangThai= 3 Then N'Đã chuyển ngành'
											   When TrangThai= 4 Then N'Đã chuyển hệ đào tạo khác'
											   When TrangThai= 5 Then N'Chuyển từ trường khác tới'
											   When TrangThai= 7 Then N'Đang bị đình chỉ học'
											   When TrangThai= 8 Then N'Đang tạm dừng học'
											   When TrangThai= 10 Then N'Đang học(sau khi tạm dừng học)'
											   When TrangThai= 11 Then N'Đang học(trở lại sau khi có quyết định đình chỉ học tập)'
											   When TrangThai= 12 Then N'Thôi học'
											   When TrangThai= 13 Then N'Đang học giảm tiến độ'
											   When TrangThai= 14 Then N'Đang học tăng tiến độ'
											   When TrangThai= 15 Then N'Phải ngừng học'
											   When TrangThai= 16 Then N'Bị buộc thôi học'
											   When TrangThai= 100 Then N'Đang làm tốt nghiệp'
											   When TrangThai= 101 Then N'Đã tốt nghiệp'
											   END
											   
From SinhVien  S INNER JOIN Nganh ON S.MaNganh=Nganh.MaNganh 
INNER JOIN HeDaoTao ON S.MaHeDaoTao=HeDaoTao.MaHeDaoTao
INNER JOIN KhoaHoc ON S.MaKhoaHoc=KhoaHoc.MaKhoaHoc
INNER JOIN LopQuanLy On S.MaLop=LopQuanLy.MaLop
Where S.MaSinhVien=@Masinhvien
GO
GRANT EXECUTE ON uspTinhTrangSinhVien To ws;

--------------------------------------------------------------
-- Thông tin sinh viên                                    ----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspThongTinSinhVien' ) IS NOT NULL 
    DROP PROCEDURE uspThongTinSinhVien;
GO
CREATE PROC dbo.uspThongTinSinhVien
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.HoDem,S.Ten,convert(varchar, S.NgaySinh, 103) NgaySinh,'GioiTinh'=Case When S.GioiTinh=0 Then N'Nữ' When S.GioiTinh=1 Then N'Nam' END,S.MaLop,S.DiaChi,S.DienThoai,S.Email,Nganh.TenNganh,KhoaHoc.TenKhoaHoc,HeDaoTao.TenHeDaoTao,LopQuanLy.DaoTaoTheoTinChi,'DaoTao'= Case When LopQuanLy.DaoTaoTheoTinChi=0 Then N'Niên chế' When LopQuanLy.DaoTaoTheoTinChi=1 Then N'Tín chỉ' END,S.AnhSinhVien,S.TrangThai,
                            'TinhTrang' = Case When TrangThai=0 Then N'Đang học' 
											   When TrangThai= 1 Then N'Đã chuyển trường'
											   When TrangThai= 2 Then N'Đã chuyển lớp'
											   When TrangThai= 3 Then N'Đã chuyển ngành'
											   When TrangThai= 4 Then N'Đã chuyển hệ đào tạo khác'
											   When TrangThai= 5 Then N'Chuyển từ trường khác tới'
											   When TrangThai= 7 Then N'Đang bị đình chỉ học'
											   When TrangThai= 8 Then N'Đang tạm dừng học'
											   When TrangThai= 10 Then N'Đang học(sau khi tạm dừng học)'
											   When TrangThai= 11 Then N'Đang học(trở lại sau khi có quyết định đình chỉ học tập)'
											   When TrangThai= 12 Then N'Thôi học'
											   When TrangThai= 13 Then N'Đang học giảm tiến độ'
											   When TrangThai= 14 Then N'Đang học tăng tiến độ'
											   When TrangThai= 15 Then N'Phải ngừng học'
											   When TrangThai= 16 Then N'Bị buộc thôi học'
											   When TrangThai= 100 Then N'Đang làm tốt nghiệp'
											   When TrangThai= 101 Then N'Đã tốt nghiệp'
											   END
											   
From SinhVien  S INNER JOIN Nganh ON S.MaNganh=Nganh.MaNganh 
INNER JOIN HeDaoTao ON S.MaHeDaoTao=HeDaoTao.MaHeDaoTao
INNER JOIN KhoaHoc ON S.MaKhoaHoc=KhoaHoc.MaKhoaHoc
LEFT OUTER JOIN LopQuanLy On S.MaLop=LopQuanLy.MaLop
Where S.MaSinhVien=@Masinhvien
GO
GRANT EXECUTE ON uspThongTinSinhVien To ws;

-------------------------------------------
--Tìm kiếm thông tin theo tên sinh viên
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTimKiemTheoTen' ) IS NOT NULL 
    DROP PROCEDURE uspTimKiemTheoTen;
GO
CREATE PROC dbo.uspTimKiemTheoTen
@ten AS nvarchar(30),@hodem AS nvarchar(60)
WITH ENCRYPTION
AS
Select MaSinhVien,HoDem,Ten,convert(varchar, NgaySinh, 103) NgaySinh,MaLop
From SinhVien
Where HoDem=@hodem and Ten=@ten
GO
GRANT EXECUTE ON uspTimKiemTheoTen To ws;

-------------------------------------------
-- Các môn sinh viên còn nợ  áp dụng cho Kiểm tra điều kiện----*
-------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonSinhVienNo' ) IS NOT NULL 
    DROP PROCEDURE uspMonSinhVienNo;
GO
CREATE PROC dbo.uspMonSinhVienNo
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.MaMonHoc,M.TenMonHoc,CASE WHEN S.MaMonHoc NOT IN(Select C.MaMonHoc
From SinhVien S1 INNER JOIN ChuongTrinhDaoTaoKhung C ON S1.MaNganh=C.MaNganh AND S1.MaKhoaHoc=C.MaKhoaHoc AND S1.MaHeDaoTao=C.MaHeDaoTao
Where S1.MaSinhVien=@Masinhvien) THEN N'Nằm ngoài CTĐT' ELSE '' END AS ThuocCTDT,MAX(S.Diem) AS DiemMax
From SV_DiemTrungBinhMonHoc S
INNER JOIN MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.MaSinhVien=@Masinhvien 
Group by S.MaSinhVien,S.MaMonHoc,M.TenMonHoc
Having MAX(S.Diem)<5
Order by M.TenMonHoc
GO
GRANT EXECUTE ON uspMonSinhVienNo To ws;
-------------------------------------------
--Các môn sinh viên còn nợ áp dụng cho VP
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonSinhVienNoMon' ) IS NOT NULL 
    DROP PROCEDURE uspMonSinhVienNoMon;
GO
CREATE PROC dbo.uspMonSinhVienNoMon
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,LTRIM(RTRIM(M.TenMonHoc)) TenMonHoc,MAX(S.Diem) AS DiemMax
From SV_DiemTrungBinhMonHoc S
INNER JOIN MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.MaSinhVien=@Masinhvien 
Group by S.MaSinhVien,LTRIM(RTRIM(M.TenMonHoc))
Having MAX(S.Diem)<5
Order by LTRIM(RTRIM(M.TenMonHoc))
GO
GRANT EXECUTE ON uspMonSinhVienNoMon To ws;

-------------------------------------------
-- Các môn sinh viên đã qua ----*
-------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonSinhVienDaQua' ) IS NOT NULL 
    DROP PROCEDURE uspMonSinhVienDaQua;
GO
CREATE PROC dbo.uspMonSinhVienDaQua
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.MaMonHoc,M.TenMonHoc,CASE WHEN S.MaMonHoc NOT IN(Select C.MaMonHoc
From SinhVien S1 INNER JOIN ChuongTrinhDaoTaoKhung C ON S1.MaNganh=C.MaNganh AND S1.MaKhoaHoc=C.MaKhoaHoc AND S1.MaHeDaoTao=C.MaHeDaoTao
Where S1.MaSinhVien=@Masinhvien) THEN N'Nằm ngoài CTĐT' ELSE '' END AS ThuocCTDT,MAX(S.Diem) AS DiemMax
From SV_DiemTrungBinhMonHoc S
INNER JOIN MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.MaSinhVien=@Masinhvien 
Group by S.MaSinhVien,S.MaMonHoc,M.TenMonHoc
Having MAX(S.Diem)>=5
Order by M.TenMonHoc
GO
GRANT EXECUTE ON uspMonSinhVienDaQua To ws;
-------------------------------------------
-- Danh sách các môn sinh viên đã học  ----*
-------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonSinhVienDaHoc' ) IS NOT NULL 
    DROP PROCEDURE uspMonSinhVienDaHoc;
GO
CREATE PROC dbo.uspMonSinhVienDaHoc
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.MaMonHoc,M.TenMonHoc,CASE WHEN S.MaMonHoc NOT IN(Select C.MaMonHoc
From SinhVien S1 INNER JOIN ChuongTrinhDaoTaoKhung C ON S1.MaNganh=C.MaNganh AND S1.MaKhoaHoc=C.MaKhoaHoc AND S1.MaHeDaoTao=C.MaHeDaoTao
Where S1.MaSinhVien=@Masinhvien) THEN N'Nằm ngoài CTĐT' ELSE '' END AS ThuocCTDT,MAX(S.Diem) AS DiemMax
From SV_DiemTrungBinhMonHoc S
INNER JOIN MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.MaSinhVien=@Masinhvien 
Group by S.MaSinhVien,S.MaMonHoc,M.TenMonHoc
Order by M.TenMonHoc
GO
GRANT EXECUTE ON uspMonSinhVienDaHoc To ws;
-------------------------------------------
-- Các môn nằm ngoài CTDT,điều kiện thay thế *
-------------------------------------------
DECLARE  @Masinhvien AS nvarchar(10)  
Set @Masinhvien='500425'
Select MTD.MaSinhVien,MTD.MaMonHoc,MTD.TenMonHoc,MTD.Diem 
From (Select M.MaSinhVien,M.MaMonHoc,M.TenMonHoc,M.Diem, CASE WHEN M.MaMonHoc  NOT IN (Select MaMonHoc2
From HocPhanThayThe
Where MaNganh=(Select Manganh From SinhVien Where MaSinhVien=@Masinhvien) AND MaKhoaHoc=(Select MaKhoaHoc From SinhVien Where MaSinhVien=@Masinhvien)
AND  MaHeDaoTao=(Select MaHeDaoTao From SinhVien Where MaSinhVien=@Masinhvien))THEN 1 ELSE 0 END AS MonTuDo
From (Select S.MaSinhVien,S.MaMonHoc,M.TenMonHoc,CASE WHEN S.MaMonHoc NOT IN(Select C.MaMonHoc
From SinhVien S1 INNER JOIN ChuongTrinhDaoTaoKhung C ON S1.MaNganh=C.MaNganh AND S1.MaKhoaHoc=C.MaKhoaHoc AND S1.MaHeDaoTao=C.MaHeDaoTao
Where S1.MaSinhVien=@Masinhvien) THEN N'Nằm ngoài CTĐT' ELSE '' END AS ThuocCTDT,MAX(S.Diem) Diem
From SV_DiemTrungBinhMonHoc S
INNER JOIN MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.MaSinhVien=@Masinhvien  
Group by S.MaSinhVien,S.MaMonHoc,M.TenMonHoc) M 
Where M.MaMonHoc NOT IN(Select C.MaMonHoc
From SinhVien S1 INNER JOIN ChuongTrinhDaoTaoKhung C ON S1.MaNganh=C.MaNganh AND S1.MaKhoaHoc=C.MaKhoaHoc AND S1.MaHeDaoTao=C.MaHeDaoTao
Where S1.MaSinhVien=@Masinhvien)) AS MTD
WHere MTD.MonTuDo=1
--------------------------------------------------------------------------------------------
--Hoc ky hien tai theo nam hoc
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspHocKyHienTai' ) IS NOT NULL 
    DROP PROCEDURE uspHocKyHienTai;
GO
CREATE PROC dbo.uspHocKyHienTai
AS
SELECT MaNamHoc
      ,HocKy
      ,HienTai
      ,NgayBatDau
      ,NgayKetThuc
FROM HocKy
Where HienTai=1
Go
GRANT EXECUTE ON uspHocKyHienTai To ws;

----------------------------------------------------
--Danh sách lớp hành chính
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopHanhChinh' ) IS NOT NULL 
    DROP PROCEDURE uspLopHanhChinh;
GO
CREATE PROC dbo.uspLopHanhChinh
AS
Select MaLop,MaNganh,MaKhoaHoc,MaHeDaoTao,DaoTaoTheoTinChi
From LopQuanLy
Order by MaKhoaHoc,MaHeDaoTao,MaLop
Go
GRANT EXECUTE ON uspLopHanhChinh To ws;
-------------------------------------------------------------------------------------------
-- TKB sinh viên                                                                       ----*
-------------------------------------------------------------------------------------------*
---HK1 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKB_HK1' ) IS NOT NULL 
    DROP PROCEDURE uspTKB_HK1;
GO
CREATE PROC dbo.uspTKB_HK1
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select T2.TenGiaoVien,T2.MaGiaoVien,T1.MaSinhVien,T2.MaLop,T2.MaMonHoc,T1.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T2.MaMonHoc)),7,1) as InT) sotc,T2.MaPhongHoc,T2.NamHoc,T2.HocKy,T2.SoTuanHoc,T2.TuanHocBatDau,T2.TuNgay,T2.NgayKetThuc,T2.SoTiet,'Thu2'=T2.[2],'Thu3'=T2.[3],'Thu4'=T2.[4],'Thu5'=T2.[5],'Thu6'=T2.[6],'Thu7'=T2.[7],'CN'=T2.[8]
From (
--Begin T1
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy1 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 Where MaSinhVien=@Masinhvien 
) AS T1
--End T1
INNER JOIN (
--Begin T2
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1)) AND TKB_ChiTiet.TietBatDau <7 
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGTietBatDau
Union 
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1)) AND TKB_ChiTiet.TietBatDau between 7 and 10 
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGTietBatDau
) AS T2
--End T2
 ON T1.MaLop=T2.MaLop AND T1.MaMonHoc=T2.MaMonHoc
 Order by TuanHocBatDau,MaLop 
GO
GRANT EXECUTE ON uspTKB_HK1 To ws;
--------------------------------------------------------------------------------------------------------------------------------
--HK2

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKB_HK2' ) IS NOT NULL 
    DROP PROCEDURE uspTKB_HK2;
GO
CREATE PROC dbo.uspTKB_HK2
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select T2.TenGiaoVien,T2.Magiaovien,T1.MaSinhVien,T2.MaLop,T2.MaMonHoc,T1.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T2.MaMonHoc)),7,1) as InT) sotc,T2.MaPhongHoc,T2.NamHoc,T2.HocKy,T2.SoTuanHoc,T2.TuanHocBatDau,T2.TuNgay,T2.NgayKetThuc,T2.SoTiet,'Thu2'=T2.[2],'Thu3'=T2.[3],'Thu4'=T2.[4],'Thu5'=T2.[5],'Thu6'=T2.[6],'Thu7'=T2.[7],'CN'=T2.[8]
From (
--Begin T1
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy2 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 Where MaSinhVien=@Masinhvien 
) AS T1
--End T1
INNER JOIN (
--Begin T2
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1)) AND TKB_ChiTiet.TietBatDau <7 
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGTietBatDau
Union 
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1)) AND TKB_ChiTiet.TietBatDau between 7 and 10 
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGTietBatDau
) AS T2
--End T2
 ON T1.MaLop=T2.MaLop AND T1.MaMonHoc=T2.MaMonHoc
 Order by TuanHocBatDau,MaLop 
GO
GRANT EXECUTE ON uspTKB_HK2 To ws;
-------------------------------------
---HK3 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKB_HK3' ) IS NOT NULL 
    DROP PROCEDURE uspTKB_HK3;
GO
CREATE PROC dbo.uspTKB_HK3
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select T2.TenGiaoVien,T2.MaGiaoVien,T1.MaSinhVien,T2.MaLop,T2.MaMonHoc,T1.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T2.MaMonHoc)),7,1) as InT) sotc,T2.MaPhongHoc,T2.NamHoc,T2.HocKy,T2.SoTuanHoc,T2.TuanHocBatDau,T2.TuNgay,T2.NgayKetThuc,T2.SoTiet,'Thu2'=T2.[2],'Thu3'=T2.[3],'Thu4'=T2.[4],'Thu5'=T2.[5],'Thu6'=T2.[6],'Thu7'=T2.[7],'CN'=T2.[8]
From (
--Begin T1
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy3 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 Where MaSinhVien=@Masinhvien 
) AS T1
--End T1
INNER JOIN (
--Begin T2
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1)) AND TKB_ChiTiet.TietBatDau <7 
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGTietBatDau
Union 
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1)) AND TKB_ChiTiet.TietBatDau between 7 and 10 
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGTietBatDau
) AS T2
--End T2
 ON T1.MaLop=T2.MaLop
 Order by TuanHocBatDau,MaLop 
GO
GRANT EXECUTE ON uspTKB_HK3 To ws;

---------------------------------------------------------------
-----------------------------
--TKB Theo lớp môn học HK1 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKBLopMonHoc_HK1' ) IS NOT NULL 
    DROP PROCEDURE uspTKBLopMonHoc_HK1;
GO
CREATE PROC dbo.uspTKBLopMonHoc_HK1
WITH ENCRYPTION
AS

Select DISTINCT T2.TenGiaoVien,T2.MaGiaoVien,T2.MaLop,T2.MaMonHoc,T1.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T2.MaMonHoc)),7,1) as InT) sotc,T2.MaPhongHoc,T2.NamHoc,T2.HocKy,T2.SoTuanHoc,T2.TuanHocBatDau,T2.TuNgay,T2.NgayKetThuc,T2.SoTiet,'Thu2'=T2.[2],'Thu3'=T2.[3],'Thu4'=T2.[4],'Thu5'=T2.[5],'Thu6'=T2.[6],'Thu7'=T2.[7],'CN'=T2.[8]
From (
--Begin T1
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy1 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 --Where MaSinhVien=@Masinhvien 
) AS T1
--End T1
INNER JOIN (
--Begin T2
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,convert(varchar, NamHoc_ThoiGianTuan.TuNgay, 103) TuNgay,convert(varchar, DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay), 103) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1))
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGSoTuan
) AS T2
--End T2
 ON T1.MaLop=T2.MaLop
 Order by MaLop,TuanHocBatDau
GO
GRANT EXECUTE ON uspTKBLopMonHoc_HK1 To ws;
-------------------------------------------------
-------------------------------------------------
--TKB Theo lớp môn học HK2 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKBLopMonHoc_HK2' ) IS NOT NULL 
    DROP PROCEDURE uspTKBLopMonHoc_HK2;
GO
CREATE PROC dbo.uspTKBLopMonHoc_HK2

WITH ENCRYPTION
AS

Select DISTINCT T2.TenGiaoVien,T2.MaGiaoVien,T2.MaLop,T2.MaMonHoc,T1.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T2.MaMonHoc)),7,1) as InT) sotc,T2.MaPhongHoc,T2.NamHoc,T2.HocKy,T2.SoTuanHoc,T2.TuanHocBatDau,T2.TuNgay,T2.NgayKetThuc,T2.SoTiet,'Thu2'=T2.[2],'Thu3'=T2.[3],'Thu4'=T2.[4],'Thu5'=T2.[5],'Thu6'=T2.[6],'Thu7'=T2.[7],'CN'=T2.[8]
From (
--Begin T1
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy2 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 --Where MaSinhVien=@Masinhvien 
) AS T1
--End T1
INNER JOIN (
--Begin T2
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,convert(varchar, NamHoc_ThoiGianTuan.TuNgay, 103) TuNgay,convert(varchar, DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay), 103) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1))
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGSoTuan
) AS T2
--End T2
 ON T1.MaLop=T2.MaLop
 Order by MaLop,TuanHocBatDau
GO
GRANT EXECUTE ON uspTKBLopMonHoc_HK2 To ws;
-------------------------------------------------
--TKB Theo lớp môn học HK3 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKBLopMonHoc_HK3' ) IS NOT NULL 
    DROP PROCEDURE uspTKBLopMonHoc_HK3;
GO
CREATE PROC dbo.uspTKBLopMonHoc_HK3

WITH ENCRYPTION
AS

Select DISTINCT T2.TenGiaoVien,T2.MaGiaoVien,T2.MaLop,T2.MaMonHoc,T1.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T2.MaMonHoc)),7,1) as InT) sotc,T2.MaPhongHoc,T2.NamHoc,T2.HocKy,T2.SoTuanHoc,T2.TuanHocBatDau,T2.TuNgay,T2.NgayKetThuc,T2.SoTiet,'Thu2'=T2.[2],'Thu3'=T2.[3],'Thu4'=T2.[4],'Thu5'=T2.[5],'Thu6'=T2.[6],'Thu7'=T2.[7],'CN'=T2.[8]
From (
--Begin T1
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy3 > 0
       AND B.TrangThai  IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 --Where MaSinhVien=@Masinhvien 
) AS T1
--End T1
INNER JOIN (
--Begin T2
SELECT *
FROM (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,convert(varchar, NamHoc_ThoiGianTuan.TuNgay, 103) TuNgay,convert(varchar, DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay), 103) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
WHERE     (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1))
) AS LopTKB
PIVOT (AVG(TietBatDau) For Thu IN ([2],[3],[4],[5],[6],[7],[8]))as AVGSoTuan
) AS T2
--End T2
 ON T1.MaLop=T2.MaLop AND T1.MaMonHoc=T2.MaMonHoc
 Order by MaLop,TuanHocBatDau
GO
GRANT EXECUTE ON uspTKBLopMonHoc_HK3 To ws;
---------------------------------------------------

------------------------------------------------------------------
 --Số tiền sinh viên còn nợ theo năm học, học kỳ
------------------------------------------------------------------
DECLARE @Namhoc AS nvarchar(10),@Hocky AS int, @Masinhvien AS nvarchar(10)  
Set @Namhoc='2012-2013'
Set @Hocky=1
Set @Masinhvien='110913'
Select SinhVien.MaSinhVien,SinhVien.HoDem,SinhVien.Ten,SinhVien.NgaySinh,SinhVien.MaLop,HP.SotienQuyDinh,HP.SoTienDaNop,HP.ConThieu
From Sinhvien Inner join (Select maSinhVien,SUM(soTienQuyDinh) As SotienQuyDinh,SUM(SoTienDaThu) AS SoTienDaNop,SUM(soTienQuyDinh)-SUM(SoTienDaThu) AS ConThieu
From SV_CAC_KHOAN_PHAI_THU s1 Where namHoc=@Namhoc and hocKy=@Hocky And s1.MaSinhVien=@Masinhvien Group by maSinhVien
Having SUM(SoTienDaThu)<SUM(soTienQuyDinh)) AS HP 
ON SinhVien.MaSinhVien=HP.maSinhVien Order by SinhVien.MaLop,SinhVien.Ten
------------------------------------------------------------------
 --Danh sách Các khoản sinh viên đã đóng theo năm học, học kỳ
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspCacKhoanDaNop' ) IS NOT NULL 
    DROP PROCEDURE uspCacKhoanDaNop;
GO
CREATE PROC dbo.uspCacKhoanDaNop
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select SoPhieu,SoTien,LTRIM(RTRIM(CONVERT(nvarchar(1000),NoiDung,0))) as NoiDung,NgayThu,NamHoc,HocKy,Huy,CASE WHEN Huy=1 THEN N'Hủy' ELSE '' END AS PhieuHuy
from BienLaiThuTien
Where MaSinhVien=@Masinhvien
Order by NgayThu DESC
GO
GRANT EXECUTE ON uspCacKhoanDaNop To ws;
------------------------------------------------------------------
 --Danh sách Các khoản sinh viên đã được chi trả lại theo năm học, học kỳ
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspCacKhoanDaChi' ) IS NOT NULL 
    DROP PROCEDURE uspCacKhoanDaChi;
GO
CREATE PROC dbo.uspCacKhoanDaChi
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select SoPhieu,SoTien,LTRIM(RTRIM(CONVERT(nvarchar(1000),NoiDung,0)))as NoiDung, NgayChi,namHoc,hocKy,Huy,CASE WHEN Huy=1 THEN N'Hủy' ELSE '' END AS PhieuHuy
From BienLaiChiTien
Where MaSinhVien=@Masinhvien
Order by NgayChi DESC
GO
GRANT EXECUTE ON uspCacKhoanDaChi To ws;
------------------------------------------------------------------
 --Các khoản sinh viên còn nợ theo năm học, học kỳ
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspCacKhoanThieu' ) IS NOT NULL 
    DROP PROCEDURE uspCacKhoanThieu;
GO
CREATE PROC dbo.uspCacKhoanThieu
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S1.maSinhVien,K.Ten,S1.namHoc,S1.hocKy,S1.soTienQuyDinh,S1.SoTienThayDoi,S1.soTienMienGiam,S1.SoTienKyTruocChuyenSang,SoTienDaThu,S1.SoTienPhaiChi,S1.SoTienDaChi,S1.SoTienChuyenSangKySau,
(S1.soTienQuyDinh+S1.SoTienDaChi+S1.SoTienKyTruocChuyenSang+S1.SoTienThayDoi)-(S1.soTienMienGiam+S1.SoTienDaThu) AS Thieu
From SV_CAC_KHOAN_PHAI_THU S1
INNER JOIN KHOAN_THU K ON S1.maKhoanThu=K.Ma
Where S1.namHoc=(Select MaNamhoc From HocKy Where HienTai=1)AND S1.hocKy=(Select HocKy From HocKy Where HienTai=1) AND S1.maSinhVien=@Masinhvien AND (S1.soTienQuyDinh+S1.SoTienDaChi+S1.SoTienKyTruocChuyenSang+S1.SoTienThayDoi)-(S1.soTienMienGiam+S1.SoTienDaThu)<>0
ORDER BY K.Ten
GO
GRANT EXECUTE ON uspCacKhoanThieu To ws;
------------------------------------------------------------------
 --Khoản KSSV sinh viên còn nợ theo năm học
------------------------------------------------------------------
DECLARE @Masinhvien AS nvarchar(10)  
Set @Masinhvien='1212301019'
Select S1.maSinhVien,K.Ten,S1.namHoc,S1.hocKy,S1.soTienQuyDinh,S1.SoTienThayDoi,S1.soTienMienGiam,S1.SoTienKyTruocChuyenSang,SoTienDaThu,S1.SoTienPhaiChi,S1.SoTienDaChi,S1.SoTienChuyenSangKySau,
(S1.soTienQuyDinh+S1.SoTienDaChi+S1.SoTienKyTruocChuyenSang+S1.SoTienThayDoi)-(S1.soTienMienGiam+S1.SoTienDaThu) AS Thieu
From SV_CAC_KHOAN_PHAI_THU S1
INNER JOIN KHOAN_THU K ON S1.maKhoanThu=K.Ma
Where S1.maKhoanThu in('KSSV','CN-KSSV') AND S1.namHoc=(Select MaNamhoc From HocKy Where HienTai=1) AND S1.maSinhVien=@Masinhvien 
ORDER BY K.Ten
---------------------------------------------------------------------
--Sinh viên còn nợ tiền KSSV
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspThieuTienKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspThieuTienKSSV;
GO
CREATE PROC dbo.uspThieuTienKSSV
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S1.maSinhVien,K.Ten,S1.namHoc,S1.soTienQuyDinh,S1.SoTienThayDoi,S1.soTienMienGiam,S1.SoTienKyTruocChuyenSang,SoTienDaThu,S1.SoTienPhaiChi,S1.SoTienDaChi,S1.SoTienChuyenSangKySau,
(S1.soTienQuyDinh+S1.SoTienDaChi+S1.SoTienKyTruocChuyenSang+S1.SoTienThayDoi)-(S1.soTienMienGiam+S1.SoTienDaThu) AS Thieu
From SV_CAC_KHOAN_PHAI_THU S1
INNER JOIN KHOAN_THU K ON S1.maKhoanThu=K.Ma
Where S1.maKhoanThu in('KSSV') AND S1.namHoc=(Select MaNamhoc From HocKy Where HienTai=1) AND (S1.soTienQuyDinh+S1.SoTienDaChi+S1.SoTienKyTruocChuyenSang+S1.SoTienThayDoi)-(S1.soTienMienGiam+S1.SoTienDaThu)>0 AND S1.maSinhVien=@Masinhvien 
ORDER BY K.Ten
GO
GRANT EXECUTE ON uspThieuTienKSSV To ws;
------------------------------------------------------------------
--Kiem tra tinh trang sinh vien o KSSV
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhvienKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspSinhvienKSSV;
GO
CREATE PROC dbo.uspSinhvienKSSV
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaSinhVien,NamHoc,MaPhong,convert(varchar, NgayVao, 103) NgayVao,convert(varchar, NgayRa, 103) NgayRa,chiSoDienKhiVao,chiSoNuocLanhKhiVao,chiSoNuocNongKhiVao,chiSoDienKhiRa,chiSoNuocLanhKhiRa,chiSoNuocNongKhiRa,'TrangThai'=Case WHEN trangthai=1 THEN N'Đang ở'  WHEN TrangThai=2 THEN N'Đã chuyển phòng'  WHEN TrangThai=3 THEN N'Đã ra' END 																							 
From KTX_Phong_SinhVien
Where maSinhVien=@Masinhvien
ORDER BY NgayVao
GO
GRANT EXECUTE ON uspSinhvienKSSV To ws;
-------------------------------------------------------------------
--Danh sách các sinh viên của phòng trong KSSV
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspPhongSV' ) IS NOT NULL 
    DROP PROCEDURE uspPhongSV;
GO
CREATE PROC dbo.uspPhongSV
@Maphong AS nvarchar(10)  
WITH ENCRYPTION
AS
SELECT S.MaSinhVien,S.HoDem,S.Ten,convert(varchar, S.NgaySinh, 103) NgaySinh,'GioiTinh'=Case When S.GioiTinh=0 Then N'Nữ' Else N'Nam' End,S.MaLop,S.AnhSinhVien
  FROM KTX_Phong_SinhVien K
  INNER JOIN SinhVien S On S.MaSinhVien=K.MaSinhVien
  Where K.TrangThai=1 and K.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)And K.MaPhong=@Maphong
  Order by S.Ten
GO
GRANT EXECUTE ON uspPhongSV To ws;

--------------------------------------------------------------------
-- Số phòng còn trống tại KSSV
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspKssvPhongTrong' ) IS NOT NULL 
    DROP PROCEDURE uspKssvPhongTrong;
GO
CREATE PROC dbo.uspKssvPhongTrong

AS
Select K.MaPhong,K.soSinhVien SoGiuong,'LoaiPhong'=CASE When DanhChoNuGioi=1 Then N'Nữ' Else N'Nam' End,ISNULL(S.SoSVDangO,0) AS SoSVDangO,K.soSinhVien- ISNULL(S.SoSVDangO,0) AS SoGiuongTrong  
From KTX_Phong K 
Left Outer JOIN (SELECT MaPhong,COUNT(*) AS SoSVDangO
  FROM KTX_Phong_SinhVien
  Where trangthai=1 and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)
  Group by MaPhong) AS S On K.MaPhong=S.MaPhong   
Where K.soSinhVien- ISNULL(S.SoSVDangO,0)>0
Order by K.MaPhong
Go
GRANT EXECUTE ON uspKssvPhongTrong To ws;
------------------------------------------------------------------
--Thống kê số chỗ còn trống tại KSSV theo nam, nữ
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSoChoTrongKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspSoChoTrongKSSV;
GO
CREATE PROC dbo.uspSoChoTrongKSSV

AS
Select S1.Loai,S1.SoSVDangO,S2.SoChoTrong,TongSoCho=S1.SoSVDangO+S2.SoChoTrong
From (
Select CASE WHEN S.DanhChoNuGioi=1 THEN N'Nữ' ELSE N'Nam' END AS 'Loai',S.SoSVDangO
From ( 
SELECT K1.DanhChoNuGioi,COUNT(*) AS SoSVDangO
  FROM KTX_Phong_SinhVien K
  INNER JOIN KTX_Phong K1 On K.MaPhong=K1.MaPhong 
  Where K.TrangThai=1 and K.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)
  Group by K1.DanhChoNuGioi
) AS S 
) AS S1 
INNER JOIN (Select T.LoaiPhong,SUM(T.SoGiuongTrong) SoChoTrong
From (
Select K.MaPhong,K.soSinhVien SoGiuong,'LoaiPhong'=CASE When DanhChoNuGioi=1 Then N'Nữ' Else N'Nam' End,ISNULL(S.SoSVDangO,0) AS SoSVDangO,K.soSinhVien- ISNULL(S.SoSVDangO,0) AS SoGiuongTrong  
From KTX_Phong K 
Left Outer JOIN (SELECT MaPhong,COUNT(*) AS SoSVDangO
  FROM KTX_Phong_SinhVien
  Where trangthai=1 and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)
  Group by MaPhong) AS S On K.MaPhong=S.MaPhong   
Where K.soSinhVien- ISNULL(S.SoSVDangO,0)>0
) AS T
Group by T.LoaiPhong) AS S2 ON S1.Loai=S2.LoaiPhong
Go
GRANT EXECUTE ON uspSoChoTrongKSSV To ws;

------------------------------------------------------------------
--Diem ren luyen theo nam
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhvienDiemRenLuyen' ) IS NOT NULL 
    DROP PROCEDURE uspSinhvienDiemRenLuyen;
GO
CREATE PROC dbo.uspSinhvienDiemRenLuyen
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaSinhVien,NamHoc,HocKy,Diem
From SV_DiemRenLuyen_HocKy
Where maSinhVien=@Masinhvien
Order by NamHoc DESC,HocKy DESC
GO
GRANT EXECUTE ON uspSinhvienDiemRenLuyen To ws;
------------------------------------------------------------------
--Chuong trinh dao tao cua sinh vien
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspKhungChuongTrinh' ) IS NOT NULL 
    DROP PROCEDURE uspKhungChuongTrinh;
GO
CREATE PROC dbo.uspKhungChuongTrinh
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT   C.MaHeDaoTao, C.MaKhoaHoc, C.MaNganh,C.MaMonHoc, dbo.MonHoc.TenMonHoc,C.ThamGiaTinhDiemTrungBinh,C.TongSo,C.MaKhoiKienThuc,K.TenKhoiKienThuc,C.DonVi,C.TuChon,C.BatBuoc,C.ThayThe, Nganh.TenNganh,C2.TenNHom,C2.TongSoMonTuChon,C2.SoMonPhaiChon,C2.BatBuoc,D.URL
FROM         dbo.ChuongTrinhDaoTaoKhung C INNER JOIN dbo.Nganh ON C.MaNganh = dbo.Nganh.MaNganh INNER JOIN dbo.MonHoc ON C.MaMonHoc = dbo.MonHoc.MaMonHoc
INNER JOIN KhoiKienThuc K ON C.MaKhoiKienThuc=K.MaKhoiKienThuc
LEFT OUTER JOIN ChuongTrinhDaoTaoKhung_NhomTuChon C2 ON C.NhomTuChon=C2.MaNhom
LEFT OUTER JOIN DanhMucMonHoc D ON C.MaMonHoc=D.Mamonhoc
WHERE     C.MaKhoaHoc =(select MaKhoaHoc from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaHeDaoTao =(select MaHeDaoTao from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaNganh =(select MaNganh from SinhVien Where MaSinhVien=@Masinhvien)
ORDER BY dbo.MonHoc.TenMonHoc
GO
GRANT EXECUTE ON uspKhungChuongTrinh To ws;

------------------------------------------------------------------
--Nhóm tự chọn sinh viên
------------------------------------------------------------------

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDangKyNhomTuChon' ) IS NOT NULL 
    DROP PROCEDURE uspDangKyNhomTuChon;
GO
CREATE PROC dbo.uspDangKyNhomTuChon
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select maNhom,maHeDaoTao,maNganhHoc,maKhoaHoc
From NhomTuChon_SinhVien
Where maSinhVien=@Masinhvien
GO
GRANT EXECUTE ON uspDangKyNhomTuChon To ws;

------------------------------------------------------------------
--Khung CTĐT để đăng ký làm TTTN
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDangKyTTTN' ) IS NOT NULL 
    DROP PROCEDURE uspDangKyTTTN;
GO
CREATE PROC dbo.uspDangKyTTTN
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select *
From (SELECT   C.MaHeDaoTao, C.MaKhoaHoc, C.MaNganh,C.MaMonHoc, dbo.MonHoc.TenMonHoc,C.TongSo,C.MaKhoiKienThuc,K.TenKhoiKienThuc,C.DonVi,C.TuChon,C.BatBuoc,C.ThayThe, Nganh.TenNganh,'TenNhom'=CASE WHEN C2.TenNHom IS NOT NULL THEN C2.TenNHom ELSE 'NoGroup' END,'MaNhom'=CASE WHEN C2.MaNhom IS NOT NULL THEN C2.MaNhom ELSE 'NoGroup' END,ISNULL(C2.TongSoMonTuChon,0) TongSoMonTuChon,ISNULL(C2.SoMonPhaiChon,0) SoMonPhaiChon,ISNULL(C2.BatBuoc,0) BatBuocChon
FROM         dbo.ChuongTrinhDaoTaoKhung C INNER JOIN dbo.Nganh ON C.MaNganh = dbo.Nganh.MaNganh INNER JOIN dbo.MonHoc ON C.MaMonHoc = dbo.MonHoc.MaMonHoc
INNER JOIN KhoiKienThuc K ON C.MaKhoiKienThuc=K.MaKhoiKienThuc
LEFT OUTER JOIN ChuongTrinhDaoTaoKhung_NhomTuChon C2 ON C.NhomTuChon=C2.MaNhom
WHERE     C.MaKhoaHoc =(select MaKhoaHoc from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaHeDaoTao =(select MaHeDaoTao from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaNganh =(select MaNganh from SinhVien Where MaSinhVien=@Masinhvien)
AND C.MaMonHoc not in ('PSS31011','CSK31011','TWS31011','FLS31011','COS31011','SES31011','PSK31011','PCS31021','SWI31011','VOL31011','FOO31011','BAD31011','APE31011','NDE31051',
'SWI21011','VOL21011','FOO21011','BAD21011','NDE21041','PSS21011','CSK21011','TWS21011','FLS21011','COS21011','SES21011','PSK21011','PCS21021','APE21011') AND C.MaKhoiKienThuc not in (4,6,7,8) 
) AS T1
Where MaNhom in (Select maNhom From NhomTuChon_SinhVien Where maSinhVien=@Masinhvien) OR MaNhom='NoGroup'

ORDER BY TenMonHoc
GO
GRANT EXECUTE ON uspDangKyTTTN To ws;

------------------------------------------------------------------
--Khung CTĐT để đăng ký làm TN
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDangKyLTN' ) IS NOT NULL 
    DROP PROCEDURE uspDangKyLTN;
GO
CREATE PROC dbo.uspDangKyLTN
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select *
From (SELECT   C.MaHeDaoTao, C.MaKhoaHoc, C.MaNganh,C.MaMonHoc, dbo.MonHoc.TenMonHoc,C.TongSo,C.MaKhoiKienThuc,K.TenKhoiKienThuc,C.DonVi,C.TuChon,C.BatBuoc,C.ThayThe, Nganh.TenNganh,'TenNhom'=CASE WHEN C2.TenNHom IS NOT NULL THEN C2.TenNHom ELSE 'NoGroup' END,'MaNhom'=CASE WHEN C2.MaNhom IS NOT NULL THEN C2.MaNhom ELSE 'NoGroup' END,ISNULL(C2.TongSoMonTuChon,0) TongSoMonTuChon,ISNULL(C2.SoMonPhaiChon,0) SoMonPhaiChon,ISNULL(C2.BatBuoc,0) BatBuocChon
FROM         dbo.ChuongTrinhDaoTaoKhung C INNER JOIN dbo.Nganh ON C.MaNganh = dbo.Nganh.MaNganh INNER JOIN dbo.MonHoc ON C.MaMonHoc = dbo.MonHoc.MaMonHoc
INNER JOIN KhoiKienThuc K ON C.MaKhoiKienThuc=K.MaKhoiKienThuc
LEFT OUTER JOIN ChuongTrinhDaoTaoKhung_NhomTuChon C2 ON C.NhomTuChon=C2.MaNhom
WHERE     C.MaKhoaHoc =(select MaKhoaHoc from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaHeDaoTao =(select MaHeDaoTao from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaNganh =(select MaNganh from SinhVien Where MaSinhVien=@Masinhvien)
 AND C.MaKhoiKienThuc not in (6,7,8) 
) AS T1
Where MaNhom in (Select maNhom From NhomTuChon_SinhVien Where maSinhVien=@Masinhvien) OR MaNhom='NoGroup'

ORDER BY TenMonHoc
GO
GRANT EXECUTE ON uspDangKyLTN To ws;

------------------------------------------------------------------
--Điều kiện môn trước sau của ngành
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDieuKienTruocSau' ) IS NOT NULL 
    DROP PROCEDURE uspDieuKienTruocSau;
GO
CREATE PROC dbo.uspDieuKienTruocSau
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT H.MaHeDaoTao,H.MaKhoaHoc,H.MaNganh,H.MaMonHoc1,H.MaMonHoc2
FROM HocPhanTruoc H
WHERE   H.MaKhoaHoc =(SELECT MaKhoaHoc from SinhVien Where MaSinhVien=@Masinhvien) AND MaHeDaoTao =(select MaHeDaoTao from SinhVien Where MaSinhVien=@Masinhvien) AND MaNganh =(select MaNganh from SinhVien Where MaSinhVien=@Masinhvien) 
GO
GRANT EXECUTE ON uspDieuKienTruocSau To ws;

------------------------------------------------------------------
--Môn thay thế
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonThayThe' ) IS NOT NULL 
    DROP PROCEDURE uspMonThayThe;
GO
CREATE PROC dbo.uspMonThayThe
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT H.MaHeDaoTao,H.MaKhoaHoc,H.MaNganh,H.MaMonHoc1,H.MaMonHoc2,H.MaHeDaoTao2,H.MaKhoaHoc2,H.MaNganh2
FROM HocPhanThayThe H
WHERE   H.MaKhoaHoc =(SELECT MaKhoaHoc from SinhVien Where MaSinhVien=@Masinhvien) AND H.MaHeDaoTao =(select MaHeDaoTao from SinhVien Where MaSinhVien=@Masinhvien) AND H.MaNganh =(select MaNganh from SinhVien Where MaSinhVien=@Masinhvien) 
GO
GRANT EXECUTE ON uspMonThayThe To ws;
------------------------------------------------------------------
--Danh sách các môn thay thế theo khóa hệ ngành
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonThayTheKhoaHeNganh' ) IS NOT NULL 
    DROP PROCEDURE uspMonThayTheKhoaHeNganh;
GO
CREATE PROC dbo.uspMonThayTheKhoaHeNganh
WITH ENCRYPTION
AS
Select C.MaMonHoc,M.TenMonHoc,C.MaHeDaoTao,C.MaKhoaHoc,C.MaNganh,H.MaMonHoc2,H.MaNganh2,H.MaHeDaoTao2,H.MaKhoaHoc2
From ChuongTrinhDaoTaoKhung C
INNER JOIN MonHoc M ON C.MaMonHoc=M.MaMonHoc
INNER JOIN HocPhanThayThe H ON C.MaMonHoc=H.MaMonHoc1 AND C.MaKhoaHoc=H.MaKhoaHoc AND C.MaHeDaoTao=H.MaHeDaoTao AND C.MaNganh=H.MaNganh
INNER JOIN KhoaHoc K ON C.MaKhoaHoc =K.MaKhoaHoc
Where K.NamRaTruong>=YEAR(GETDATE())
Order by C.MaMonHoc,C.MaHeDaoTao,C.MaKhoaHoc,C.MaNganh
GO
GRANT EXECUTE ON uspMonThayTheKhoaHeNganh To ws;
------------------------------------------------------------------
--Danh sách các môn có ở các khóa hệ ngành khác
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDanhSachCacMonTheoKhoaHeNganh' ) IS NOT NULL 
    DROP PROCEDURE uspDanhSachCacMonTheoKhoaHeNganh;
GO
CREATE PROC dbo.uspDanhSachCacMonTheoKhoaHeNganh
WITH ENCRYPTION
AS
Select C.MaMonHoc,M.TenMonHoc,C.MaHeDaoTao,C.MaKhoaHoc,C.MaNganh
From ChuongTrinhDaoTaoKhung C
INNER JOIN MonHoc M ON C.MaMonHoc=M.MaMonHoc
INNER JOIN KhoaHoc K ON C.MaKhoaHoc =K.MaKhoaHoc
Where K.NamRaTruong>=YEAR(GETDATE())
Order by C.MaMonHoc,C.MaHeDaoTao,C.MaKhoaHoc,C.MaNganh
GO
GRANT EXECUTE ON uspDanhSachCacMonTheoKhoaHeNganh To ws;
------------------------------------------------------------------
--Môn học
------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHoc' ) IS NOT NULL 
    DROP PROCEDURE uspMonHoc;
GO
CREATE PROC dbo.uspMonHoc
@Mamonhoc AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaMonHoc,TenMonHoc
From MonHoc
Where MaMonHoc=@Mamonhoc
GO
GRANT EXECUTE ON uspMonHoc To ws;

------------------------------
--Danh sach lop mon hoc trong ky
----------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopMonHoc' ) IS NOT NULL 
    DROP PROCEDURE uspLopMonHoc;
GO
CREATE PROC dbo.uspLopMonHoc
WITH ENCRYPTION
AS
Select MaLop,MaMonHoc,MaSinhVien,MaLopHanhChinh,TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamHoc From HocKy Where HienTai=1)
       AND A.HocKy1 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
 ) AS MHTK
 
 ORDER BY MaLop,TenMonHoc
GO
GRANT EXECUTE ON uspLopMonHoc To ws;

----------------------------
--Xep lich thi danh sach cac mon thi
-----------------------------
Select MaMonHoc,TenMonHoc,SUM(Sosinhvien) AS SiSoSV
From (Select MonHoc.MaMonHoc,MonHoc.TenMonHoc,COUNT(*) Sosinhvien
From LopTinChi_SinhVien S1
INNER JOIN MonHoc ON LEFT(LTRIM(RTRIM(S1.MaLop)),8)=LTRIM(RTRIM(MonHoc.MaMonHoc))
Where S1.namHoc=(Select MaNamhoc From HocKy Where HienTai=1)AND S1.hocKy=(Select HocKy From HocKy Where HienTai=1) AND S1.HocPhi>0
Group by MonHoc.MaMonHoc,MonHoc.TenMonHoc
Union
---Si so sinh vien dang ky tho hoc lai, ghep lop
Select MonHoc.MaMonHoc,MonHoc.TenMonHoc,COUNT(*) Sosinhvien
From SV_HocLai S1
INNER JOIN MonHoc ON S1.MaMonGhep=MonHoc.MaMonHoc
Where S1.NamHocLai=(Select MaNamhoc From HocKy Where HienTai=1)AND S1.HocKyHocLai=(Select HocKy From HocKy Where HienTai=1) 
Group by MonHoc.MaMonHoc,MonHoc.TenMonHoc
Union
-- Si so sinh dang ky tho hoc bo sung
Select MonHoc.MaMonHoc,MonHoc.TenMonHoc,COUNT(*) Sosinhvien
From SV_HocBoSung S1
INNER JOIN MonHoc ON S1.MaMonGhep=MonHoc.MaMonHoc
Where S1.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)AND S1.HocKy=(Select HocKy From HocKy Where HienTai=1) 
Group by MonHoc.MaMonHoc,MonHoc.TenMonHoc
) SiSo
Group by MaMonHoc,TenMonHoc
Order by TenMonHoc
-- ======================================================================
-- Author:	Do Van Tuyen
-- Create date: 13/03/2013
-- Description: Thủ tục lấy danh sách cố vấn học tập của sinh viên trong kỳ hiện tại
-- ======================================================================
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspCoVanHocTap' ) IS NOT NULL 
    DROP PROCEDURE uspCoVanHocTap;
GO
CREATE PROC dbo.uspCoVanHocTap
@Masinhvien AS nvarchar(10)
AS
Select DISTINCT LTRIM(RTRIM(GiaoVien.HoDem)) +' '+LTRIM(RTRIM(Giaovien.Ten)) AS TenGiaoVien,GiaoVien.DienThoai,GiaoVien.Email
From CoVanHocTap_Lop C1 
INNER JOIN CoVanHocTap C2 ON C1.MaCoVan=C2.MaCoVan
INNER JOIN GiaoVien ON C2.MaGiaoVien=GiaoVien.MaGiaoVien
Where C1.MaLop =(select MaLop from SinhVien where MaSinhVien=@Masinhvien) AND C2.NamHoc=(Select MaNamHoc From HocKy Where HienTai=1) AND C2.HocKy=(Select HocKy From HocKy Where HienTai=1)
Go
GRANT EXECUTE ON uspCoVanHocTap To ws;
-- ======================================================================
-- Author:	Do Van Tuyen
-- Create date: 13/03/2013
-- Description: Thủ tục lấy danh sách cố vấn học tập lớp trong kỳ hiện tại
-- ======================================================================
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspCoVanHocTapTrongHocKy' ) IS NOT NULL 
    DROP PROCEDURE uspCoVanHocTapTrongHocKy;
GO
CREATE PROC dbo.uspCoVanHocTapTrongHocKy
AS
SET NOCOUNT ON
Select C1.MaLop,GiaoVien.MaGiaoVien,LTRIM(RTRIM(GiaoVien.HoDem)) +' '+LTRIM(RTRIM(Giaovien.Ten)) AS TenGiaoVien,GiaoVien.DienThoai,GiaoVien.Email
From CoVanHocTap_Lop C1 
INNER JOIN CoVanHocTap C2 ON C1.MaCoVan=C2.MaCoVan 
INNER JOIN GiaoVien ON C2.MaGiaoVien=GiaoVien.MaGiaoVien
Where C2.NamHoc=(Select MaNamHoc From HocKy Where HienTai=1) AND C2.HocKy=(Select HocKy From HocKy Where HienTai=1)
Go
GRANT EXECUTE ON uspCoVanHocTapTrongHocKy To ws;

-----------------------------------------------
--Miễn giảm học phí
-----------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMienGiamHP' ) IS NOT NULL 
    DROP PROCEDURE uspMienGiamHP;
GO
CREATE PROC dbo.uspMienGiamHP
@Masinhvien AS nvarchar(10)
AS
Select maSinhVien,NamHoc,SoTienMienGiam,ghiChu
From SV_MienGiamHocPhi
Where  MaSinhVien=@Masinhvien
ORDER BY NamHoc
Go
GRANT EXECUTE ON uspMienGiamHP To ws;
-----------------------------------------------
--Xếp hạng năm đào tạo
-----------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspXepHangNam' ) IS NOT NULL 
    DROP PROCEDURE uspXepHangNam;
GO
CREATE PROC dbo.uspXepHangNam
@Masinhvien AS nvarchar(10)
AS
SELECT MaSinhVien,MAX(SoTinChiTichLuy)SoTinChiTichLuy,MAX(NamThu) NamThu
  FROM SV_XepHangNamDaoTao
Where  MaSinhVien=@Masinhvien
Group by MaSinhVien
Go
GRANT EXECUTE ON uspXepHangNam To ws;

--------------------------------------------------
--Dữ liệu sinh viên
-------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhVien' ) IS NOT NULL 
    DROP PROCEDURE uspSinhVien;
GO
CREATE PROC dbo.uspSinhVien
AS
SELECT     TOP (100) PERCENT dbo.SinhVien.MaSinhVien, LTRIM(RTRIM(dbo.SinhVien.MaLop)) AS Lop, LTRIM(RTRIM(dbo.SinhVien.HoDem)) AS Hodem, 
                      LTRIM(RTRIM(dbo.SinhVien.Ten)) AS Ten, dbo.SinhVien.GioiTinh, dbo.SinhVien.NgaySinh, LTRIM(RTRIM(CASE WHEN DAY(dbo.SinhVien.NgaySinh) 
                      < 10 THEN '0' + CAST(DAY(dbo.SinhVien.NgaySinh) AS CHAR(1)) ELSE CAST(DAY(dbo.SinhVien.NgaySinh) AS CHAR(2)) 
                      END + CASE WHEN Month(dbo.SinhVien.NgaySinh) < 10 THEN '0' + CAST(Month(dbo.SinhVien.NgaySinh) AS CHAR(1)) ELSE CAST(Month(dbo.SinhVien.NgaySinh) 
                      AS CHAR(2)) END + CAST(YEAR(dbo.SinhVien.NgaySinh) AS CHAR(4)))) AS MatKhauKhoiTao,KhoaHoc.TenKhoaHoc, dbo.HeDaoTao.TenHeDaoTao, dbo.SinhVien.MaNganh, dbo.Nganh.TenNganh, dbo.SinhVien.TrangThai,Email
FROM         dbo.SinhVien INNER JOIN
                      dbo.Nganh ON dbo.SinhVien.MaNganh = dbo.Nganh.MaNganh INNER JOIN
                      dbo.HeDaoTao ON dbo.SinhVien.MaHeDaoTao = dbo.HeDaoTao.MaHeDaoTao
                      INNER JOIN KhoaHoc ON SinhVien.MaKhoaHoc=KhoaHoc.MaKhoaHoc
WHERE      (dbo.SinhVien.TrangThai not in (12,1,7,8,15,16)) 
ORDER BY dbo.SinhVien.MaHeDaoTao, dbo.SinhVien.MaNganh, dbo.SinhVien.MaLop
Go
GRANT EXECUTE ON uspSinhVien To ws;
---------------------------------------------------
--Sinh viên đang học
-------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhVienDangHoc' ) IS NOT NULL 
    DROP PROCEDURE uspSinhVienDangHoc;
GO
CREATE PROC dbo.uspSinhVienDangHoc
AS
SELECT     TOP (100) PERCENT dbo.SinhVien.MaSinhVien, LTRIM(RTRIM(dbo.SinhVien.MaLop)) AS Lop, LTRIM(RTRIM(dbo.SinhVien.HoDem)) AS Hodem, 
                      LTRIM(RTRIM(dbo.SinhVien.Ten)) AS Ten, dbo.SinhVien.GioiTinh, dbo.SinhVien.NgaySinh, LTRIM(RTRIM(CASE WHEN DAY(dbo.SinhVien.NgaySinh) 
                      < 10 THEN '0' + CAST(DAY(dbo.SinhVien.NgaySinh) AS CHAR(1)) ELSE CAST(DAY(dbo.SinhVien.NgaySinh) AS CHAR(2)) 
                      END + CASE WHEN Month(dbo.SinhVien.NgaySinh) < 10 THEN '0' + CAST(Month(dbo.SinhVien.NgaySinh) AS CHAR(1)) ELSE CAST(Month(dbo.SinhVien.NgaySinh) 
                      AS CHAR(2)) END + CAST(YEAR(dbo.SinhVien.NgaySinh) AS CHAR(4)))) AS MatKhauKhoiTao,KhoaHoc.TenKhoaHoc, dbo.HeDaoTao.TenHeDaoTao, dbo.SinhVien.MaNganh, dbo.Nganh.TenNganh, dbo.SinhVien.TrangThai,Email,LopQuanLy.DaoTaoTheoTinChi
FROM         dbo.SinhVien INNER JOIN
                      dbo.Nganh ON dbo.SinhVien.MaNganh = dbo.Nganh.MaNganh INNER JOIN
                      dbo.HeDaoTao ON dbo.SinhVien.MaHeDaoTao = dbo.HeDaoTao.MaHeDaoTao
                      INNER JOIN KhoaHoc ON SinhVien.MaKhoaHoc=KhoaHoc.MaKhoaHoc
                      INNER JOIN LopQuanLy On dbo.SinhVien.MaLop=LopQuanLy.MaLop
WHERE      (dbo.SinhVien.TrangThai not in (12,1,7,8,15,16,101)) 
ORDER BY dbo.SinhVien.MaHeDaoTao, dbo.SinhVien.MaNganh, dbo.SinhVien.MaLop
Go
GRANT EXECUTE ON uspSinhVienDangHoc To ws;
-------------------------------------------------------
--Trung bình chung học tập lần 1 theo năm học, học kỳ--
-------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTBCHTNamHocHK_lan1' ) IS NOT NULL 
    DROP PROCEDURE uspTBCHTNamHocHK_lan1;
GO
CREATE PROC dbo.uspTBCHTNamHocHK_lan1
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.NamHoc,S.HocKy,ROUND(S.Diem,2) Diem,X2.Ten XepLoai10,ROUND(S.Diem4,2) Diem4,X1.TenXepLoai XepLoai4
From SV_DiemTrungBinhHocKy S 
INNER JOIN XepLoaiHocTap_TinChi X1 ON S.XepLoai4=X1.XepLoai
INNER JOIN XepLoaiHocTap_NienChe X2 ON S.XepLoai=X2.XepLoai
Where S.MaSinhVien=@masinhvien And S.LanThu=1 and S.HocKy<>3
ORDER BY S.NamHoc,S.HocKy,S.LanThu
GO
GRANT EXECUTE ON uspTBCHTNamHocHK_lan1 To ws;
-------------------------------------------------------
--Trung bình chung học tập lần 1 theo năm học, học kỳ--
-------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTBCHTNamHocHK_lan2' ) IS NOT NULL 
    DROP PROCEDURE uspTBCHTNamHocHK_lan2;
GO
CREATE PROC dbo.uspTBCHTNamHocHK_lan2
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.NamHoc,S.HocKy,ROUND(S.Diem,2) Diem,X2.Ten XepLoai10,ROUND(S.Diem4,2) Diem4,X1.TenXepLoai XepLoai4
From SV_DiemTrungBinhHocKy S 
INNER JOIN XepLoaiHocTap_TinChi X1 ON S.XepLoai4=X1.XepLoai
INNER JOIN XepLoaiHocTap_NienChe X2 ON S.XepLoai=X2.XepLoai
Where S.MaSinhVien=@masinhvien And S.LanThu=2 and S.HocKy<>3
ORDER BY S.NamHoc,S.HocKy,S.LanThu
GO
GRANT EXECUTE ON uspTBCHTNamHocHK_lan2 To ws;

-----------------------------------------------------------   
--Tổng số môn học, Số tín chỉ đã học theo năm học, học kỳ--
-----------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSoMonHocTheoNamHocKy' ) IS NOT NULL 
    DROP PROCEDURE uspSoMonHocTheoNamHocKy;
GO
CREATE PROC dbo.uspSoMonHocTheoNamHocKy
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaSinhVien,NamHoc,HocKy,COUNT(*) SoMonHoc,SUM(CAST(SUBSTRING(LTRIM(RTRIM(MaMonHoc)),7,1) as InT)) AS TongSoTC 
From SV_DiemTrungBinhMonHoc
Where MaSinhVien=@masinhvien and LanThu=1
Group by MaSinhVien,NamHoc,HocKy
Order by NamHoc,HocKy
GO
GRANT EXECUTE ON uspSoMonHocTheoNamHocKy To ws;

-----------------------------------------------------------   
--Thống kê số môn sinh viên đăng ký học theo học ký chính: Tổng số môn DK, Đã qua, chưa qua--
-----------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspThongKeMonHocHK' ) IS NOT NULL 
    DROP PROCEDURE uspThongKeMonHocHK;
GO
CREATE PROC dbo.uspThongKeMonHocHK
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select A1.MaSinhVien,A1.NamHoc,A1.HocKy,A1.SoMon,A1.SoTC,ISNULL(A2.DaQua,0) DaQua,ISNULL(A2.Chuaqua,0) Chuaqua
From (
--Begin A1
--Số môn đăng ký học kỳ chính
Select MaSinhVien,NamHoc,HocKy,COUNT(*) AS SoMon,SUM(CAST(SUBSTRING(LTRIM(RTRIM(MaMonHoc)),7,1) as InT)) AS SoTC
From SV_DiemKiemTra_ThiHK S
Where MaSinhVien=@Masinhvien and HocKy<>3 and S.LanThu=1
Group by MaSinhVien,NamHoc,HocKy
--End A1
) A1
LEFT OUTER JOIN 
(
--Begin A2
---Số môn qua và chưa
Select MaSinhVien,NamHoc,HocKy,ISNULL([Daqua],0) DaQua,ISNULL([Chuaqua],0) Chuaqua
From (
Select  *
From (
Select MaSinhVien,NamHoc,HocKy,TrangThai,COUNT(*) as SoMon
From(
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,Case WHEN MAX(S.Diem)<5 THEN 'ChuaQua' ELSE 'DaQua' END TrangThai
From SV_DiemTrungBinhMonHoc S
Where S.MaSinhVien=@Masinhvien and S.HocKy<>3 
Group by S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc
) T
Group by MaSinhVien,NamHoc,HocKy,TrangThai
) Mon
PIVOT (AVG(SoMon) For TrangThai IN ([DaQua],[ChuaQua]))as AVGDiem
) Mon1
--End A2
) A2 
On A1.MaSinhVien=A2.MaSinhVien And A1.NamHoc=A2.NamHoc And A1.HocKy=A2.HocKy
Order by NamHoc,HocKy
GO
GRANT EXECUTE ON uspThongKeMonHocHK To ws;

------------------------------------------------------------------------   
--Tổng số môn học, Số tín chỉ đã đăng ký theo năm học, học kỳ hiện tại--
------------------------------------------------------------------------
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSoMonHocTheoNamHocKyHienTai' ) IS NOT NULL 
    DROP PROCEDURE uspSoMonHocTheoNamHocKyHienTai;
GO
CREATE PROC dbo.uspSoMonHocTheoNamHocKyHienTai
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select MaSinhVien,NamHoc,HocKy,Count(*) AS SoMon,SUM(SoTC) AS TongTC
From (Select L.MaSinhVien,L.NamHoc,L.HocKy,MonHoc.MaMonHoc,MonHoc.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(LopTinChi.MaMonHoc)),7,1) as InT) sotc,L.HocPhi,N'Đăng ký học' AS TrangThai
From LopTinChi_SinhVien L 
INNER JOIN LopTinChi ON L.MaLop=LopTinChi.MaLop
INNER JOIN SinhVien S ON L.MaSinhVien=S.MaSinhVien
INNER JOIN MonHoc ON LEFT(LTRIM(RTRIM(L.MaLop)),8)=MonHoc.MaMonHoc
Where L.HocPhi>0  AND  L.MaSinhVien=@Masinhvien 
Union
Select S.maSinhVien,S.NamHocLai NamHoc,S.HocKyHocLai Hocky,S.maMonHoc,MonHoc.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(S.maMonHoc)),7,1) as InT) sotc,S.HocPhiHocLai HocPhi,N'Học lại, ghép lớp' AS TrangThai
From SV_HocLai S INNER JOIN MonHoc ON S.maMonHoc=MonHoc.MaMonHoc 
Where S.maSinhVien=@Masinhvien
Union
Select S.maSinhVien,S.NamHoc NamHoc,S.HocKy,S.maMonHoc,MonHoc.TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(S.maMonHoc)),7,1) as InT) sotc,S.HocPhi,N'Học bổ sung,ghép lớp' AS TrangThai
From SV_HocBoSung S INNER JOIN MonHoc ON S.maMonHoc=MonHoc.MaMonHoc 
Where S.maSinhVien=@Masinhvien)
AS MonhocDaDK
Where NamHoc=(Select MaNamHoc From HocKy Where HienTai=1) AND HocKy=(Select HocKy From HocKy Where HienTai=1)
Group by MaSinhVien,NamHoc,HocKy
Order by NamHoc,HocKy
GO
GRANT EXECUTE ON uspSoMonHocTheoNamHocKyHienTai To ws;
---------------------------------------------------
--Theo dõi tình hình sử dụng điện nước của phòng theo tháng 
IF OBJECT_ID ( 'uspDienNuocKSSVTheoThang' ) IS NOT NULL 
    DROP PROCEDURE uspDienNuocKSSVTheoThang;
GO
CREATE PROC dbo.uspDienNuocKSSVTheoThang
@MaPhong AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT MaPhong
      ,YEAR(ngay) Nam
      ,MONTH(ngay) Thang
      ,MAX(ChiSoDien) ChiSoDien 
      ,MAX(ChiSoNuocNong) ChiSoNuocNong
      ,MAX(ChiSoNuocLanh) ChiSoNuocLanh
  FROM KTX_ChiSoDienNuoc 
  Where YEAR(ngay) Between YEAR(getdate())-1 and YEAR(getdate()) AND MaPhong =@maphong
  Group by MaPhong,YEAR(ngay),MONTH(ngay)
  Order by MaPhong,YEAR(ngay),MONTH(ngay)
GO
GRANT EXECUTE ON uspDienNuocKSSVTheoThang To ws;
-----------------------------------------------------------
 --Danh sách các phòng tại KSSV 
IF OBJECT_ID ( 'uspDanhSachPhongKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspDanhSachPhongKSSV;
GO
CREATE PROC dbo.uspDanhSachPhongKSSV

WITH ENCRYPTION
AS
Select MaPhong,MaToaNha,soSinhVien SoGiuong,'LoaiPhong'= CASE WHEN DanhChoNuGioi=1 THEN N'Nữ' ELSE N'Nam' END
From KTX_Phong
ORDER BY MaPhong
GO
GRANT EXECUTE ON uspDanhSachPhongKSSV To ws;
-----------------------------------------------------------------
--Sử dụng điện nước KSSV theo phòng
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSuDungDienNuocKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspSuDungDienNuocKSSV;
GO
CREATE PROC dbo.uspSuDungDienNuocKSSV
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select K.NamHoc,K.MaPhong,K.MaSinhVien,K.TrangThai,K.NgayVao,K.NgayRa,K.chiSoDienKhiVao,K.chiSoNuocLanhKhiVao,K.chiSoNuocNongKhiVao,K.chiSoDienKhiRa,K.chiSoNuocLanhKhiRa,K.chiSoNuocNongKhiRa
From (
Select MaPhong,NgayVao,NgayRa
From KTX_Phong_SinhVien
Where MaSinhVien=@masinhvien and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and TrangThai in (2,3)
) S 
INNER JOIN KTX_Phong_SinhVien K ON S.MaPhong=K.MaPhong
Where K.NgayVao between S.NgayVao and S.NgayRa
ORDER BY K.NgayVao,K.MaPhong
GO
GRANT EXECUTE ON uspSuDungDienNuocKSSV To ws;
---------------------------------------------------------------
--Bảng giá điện, nước, phòng KSSV
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspGiaDienNuocKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspGiaDienNuocKSSV;
GO
CREATE PROC dbo.uspGiaDienNuocKSSV
WITH ENCRYPTION
AS
Select giaDien,giaNuocLanh,giaNuocNong,giaPhongO,apDungTuNgay
From BangGiaDienNuocPhongO
Order by apDungTuNgay DESC
GO
GRANT EXECUTE ON uspGiaDienNuocKSSV To ws;
---------------------------------------------------------------------------
--Theo dõi Số lượng sinh viên của phòng tại KSSV 
IF OBJECT_ID ( 'uspSoLuongSinhVienPhongKSSV' ) IS NOT NULL 
    DROP PROCEDURE uspSoLuongSinhVienPhongKSSV;
GO
CREATE PROC dbo.uspSoLuongSinhVienPhongKSSV
@MaPhong AS nvarchar(10)
WITH ENCRYPTION
AS
Select NamHoc,MaPhong,MaSinhVien,TrangThai,NgayVao,NgayRa
From KTX_Phong_SinhVien
Where NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and MaPhong=@MaPhong
ORDER BY NgayVao,TrangThai
GO
GRANT EXECUTE ON uspSoLuongSinhVienPhongKSSV To ws;

----------------------------------------------------------------------------------

--Tính tiền điện, nước lạnh, nước nóng, nhà của sinh viên 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSuDungDienNuocKSSVTheoSinhVien' ) IS NOT NULL 
    DROP PROCEDURE uspSuDungDienNuocKSSVTheoSinhVien;
GO
CREATE PROC dbo.uspSuDungDienNuocKSSVTheoSinhVien
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaPhong,S.MaSinhVien,S.NgayVao,S.NgayRa,K.TienDien,K.TienNuocLanh,K.TienNuocNong,(K.TongCong-K.TienDien-K.TienNuocLanh-K.TienNuocNong) AS TienNha,K.TongCong
From 
(Select MaPhong,MaSinhVien,NgayVao,NgayRa
From KTX_Phong_SinhVien
--Where MaSinhVien=@Masinhvien and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and TrangThai =3
Where MaSinhVien=@Masinhvien and TrangThai =3
) S 
INNER JOIN KTX_CongNo K ON S.MaSinhVien=K.MaSinhVien
Where K.Ngay =S.NgayRa
ORDER BY S.NgayVao
GO
GRANT EXECUTE ON uspSuDungDienNuocKSSVTheoSinhVien To ws;
----------------------------------------------------------------------------------------------
--Danh sách giáo viên, cố vấn
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDanhCanBoGiaoVien' ) IS NOT NULL 
    DROP PROCEDURE uspDanhCanBoGiaoVien;
GO
CREATE PROC dbo.uspDanhCanBoGiaoVien
WITH ENCRYPTION
AS
SELECT [MaNguoiDung]
      ,[TenDangNhap]
      ,[HoVaTen]
      ,[MaGiaoVien]
      ,[Email]
  FROM [EduMngNew].[dbo].[Q_NguoiDung]
  Where DangBiKhoa=0 and Email<>' '
ORDER BY TenDangNhap
GO
GRANT EXECUTE ON uspDanhCanBoGiaoVien To ws;
---------------------------------------------------------------
--Danh sách Cán bộ, Giảng viên toàn trường
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDanhSachCanBoGiangVien' ) IS NOT NULL 
    DROP PROCEDURE uspDanhSachCanBoGiangVien;
GO
CREATE PROC dbo.uspDanhSachCanBoGiangVien
WITH ENCRYPTION
AS
Select G.MaGiaoVien,Q.MaNguoiDung,Q.TenDangNhap,G.HoDem,G.Ten,G.MaHocHam,G.MaHocVi,CASE WHEN G.LoaiGiaoVien =1 THEN N'Cơ hữu' WHEN G.LoaiGiaoVien =2 THEN N'Thỉnh giảng HP' WHEN G.LoaiGiaoVien =3 THEN N'Thỉnh giảng HN' END LoaiGiaoVien,G.MaKhoa,K.TenKhoa,G.MaBoMon,B.TenBoMon,G.Email,T.TenTrangThai,Q.DangBiKhoa
,G.ToTruong QuyenDuyet
From GiaoVien G
LEFT OUTER JOIN Q_NguoiDung Q ON G.MaGiaoVien=Q.MaGiaoVien
INNER JOIN TrangThaiGiaoVien T On G.TrangThai=T.MaTrangThai
LEFT OUTER JOIN BoMon B ON G.MaBoMon=B.MaBoMon
LEFT OUTER JOIN Khoa K On B.MaKhoa=K.MaKhoa
Where G.MaGiaoVien<>'' and T.MaTrangThai not in (2, 4) 
Order by G.MaBoMon,Q.TenDangNhap

GO
GRANT EXECUTE ON uspDanhSachCanBoGiangVien To ws;

---------------------------------------------------------------
-- Điểm môn học trong học, áp dụng cho học kỳ 1  ----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDiemMonHocTrongKy1' ) IS NOT NULL 
    DROP PROCEDURE uspDiemMonHocTrongKy1;
GO
CREATE PROC dbo.uspDiemMonHocTrongKy1
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT DISTINCT *
FROM
(--Begin BangDiem 
Select MaMonHoc,TenMonHoc,Case WHEN TyLeDiemDQT IS NULL THEN CONVERT(varchar, TyLeDiemThi) ELSE CONVERT(varchar, TyLeDiemDQT)+'/'+ CONVERT(varchar, TyLeDiemThi) END TyLeDiem ,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, DiemTHL1),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, DiemTHL2),'') DiemTHL2
From (
-- Điểm môn học trong kỳ
Select MaMonHoc,TenMonHoc,TyLeDiemDQT,ISNULL(CONVERT(Nvarchar, DQT),'') DQT,TyLeDiemThi, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, D.[1]),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, D.[2]),'') DiemTHL2
From(
Select *
From (
Select B.MaSinhVien,B.MaMonHoc,B.Malop,B.TenMonHoc,B.NamHoc,B.HocKy,B.TyLeDiemDQT,B.DQT,B.TyLeDiemThi,B.DiemThiL1,B.DiemThiL2,S2.Diem,S2.LanThu
From
(
--Begin B
Select MaSinhVien,MaMonhoc,Malop,TenMonhoc,NamHoc,HocKy,TyLeDiemDQT,DQT,TyLeDiemThi,[1] As DiemThiL1,[2] DiemThiL2
From (
Select MonDKHoc.MaSinhVien,MonDKHoc.MaMonHoc,MonDKHoc.Malop,MonDKHoc.TenMonHoc,MonDKHoc.NamHoc,MonDKHoc.HocKy,S.LoaiDiem,S.TyLeDiem TyLeDiemDQT,S.Diem DQT,S1.TyLeDiem TyLeDiemThi,CASE WHEN S1.ApDungDiemPhucKhao=1 THEN S1.DiemPhucKhao ELSE S1.Diem END DiemThi,S1.LanThu
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocLai) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy1 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) as MonDKHoc
LEFT OUTER JOIN SV_DiemChiTiet S ON MonDKHoc.MaSinhVien=S.MaSinhVien AND MonDKHoc.MaMonHoc=S.MaMonHoc AND MonDKHoc.NamHoc=S.NamHoc AND MonDKHoc.HocKy=S.HocKy and S.LoaiDiem not in ('CS1','CS2','CN1','CN2')
LEFT OUTER JOIN SV_DiemKiemTra_ThiHK S1 ON MonDKHoc.MaSinhVien=S1.MaSinhVien AND MonDKHoc.MaMonHoc=S1.MaMonHoc AND MonDKHoc.NamHoc=S1.NamHoc AND MonDKHoc.HocKy=S1.HocKy 

Where MonDKHoc.MaSinhVien=@Masinhvien 
) AS A
PIVOT (AVG(A.DiemThi) For A.LanThu IN ([1],[2]))as AVGDiem
) AS B 
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON B.MaSinhVien=S2.MaSinhVien AND B.MaMonHoc=S2.MaMonHoc AND B.NamHoc=S2.NamHoc AND B.HocKy=S2.HocKy 
Where S2.MaMonHoc not in (select MaMonHoc from SV_DiemChiTiet where MaSinhVien=@Masinhvien and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and HocKy=(Select HocKy From HocKy Where HienTai=1) and LoaiDiem in ('CS1','CS2','CN1','CN2'))
--So diem End
) AS C
PIVOT (AVG(C.Diem) For C.LanThu IN ([1],[2]))as AVGDiem
) AS D
UNION ALL 
--Điểm thi môn tốt nghiệp
Select MaMonHoc,TenMonHoc,'50' AS TyLeDiemDQT ,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, '50' AS TyLeDiemThi,ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, DiemTHL1),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, DiemTHL2),'') DiemTHL2
From (
Select A.MaMonHoc,A.TenMonHoc,A.CS1 DQT,A.CS2 DiemThiL1,S2.Diem DiemTHL1,Null 'DiemThiL2' ,Null 'DiemTHL2' 
From (
Select *
From (
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,M.TenMonHoc,S.LoaiDiem,S.Diem
From SV_DiemChiTiet S
inner join MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.LoaiDiem in ('CS1','CS2') and S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and S.HocKy=(Select HocKy From HocKy Where HienTai=1) and S.MaSinhVien=@Masinhvien
) as CS
PIVOT (AVG(Diem) For LoaiDiem IN ([CS1],[CS2]))as AVGDiem
) as A
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON A.MaSinhVien=S2.MaSinhVien AND A.MaMonHoc=S2.MaMonHoc AND A.NamHoc=S2.NamHoc AND A.HocKy=S2.HocKy 
Union all
Select A.MaMonHoc,A.TenMonHoc,A.CN1 DQT,A.CN2 DiemThiL1,S2.Diem DiemTHL1,Null 'DiemThiL2',Null 'DiemTHL2' 
From (
Select *
From (
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,M.TenMonHoc,S.LoaiDiem,S.Diem
From SV_DiemChiTiet S
inner join MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.LoaiDiem in ('CN1','CN2') and S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and S.HocKy=(Select HocKy From HocKy Where HienTai=1) and S.MaSinhVien=@Masinhvien
) as CN
PIVOT (AVG(Diem) For LoaiDiem IN ([CN1],[CN2]))as AVGDiem
) as A
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON A.MaSinhVien=S2.MaSinhVien AND A.MaMonHoc=S2.MaMonHoc AND A.NamHoc=S2.NamHoc AND A.HocKy=S2.HocKy
) AS DiemTN
) AS Diem
)AS BangDiem
--End BangDiem
ORDER BY TenMonHoc 
Go
GRANT EXECUTE ON uspDiemMonHocTrongKy1 To ws;
--------------------------------------------------------------------------------------------
---------------------------------------------------------------
-- Điểm môn học trong học, áp dụng cho học kỳ 2  ----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDiemMonHocTrongKy2' ) IS NOT NULL 
    DROP PROCEDURE uspDiemMonHocTrongKy2;
GO
CREATE PROC dbo.uspDiemMonHocTrongKy2
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT DISTINCT *
FROM
(--Begin BangDiem 
Select MaMonHoc,TenMonHoc,Case WHEN TyLeDiemDQT IS NULL THEN CONVERT(varchar, TyLeDiemThi) ELSE CONVERT(varchar, TyLeDiemDQT)+'/'+ CONVERT(varchar, TyLeDiemThi) END TyLeDiem ,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, DiemTHL1),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, DiemTHL2),'') DiemTHL2
From (
-- Điểm môn học trong kỳ
Select MaMonHoc,TenMonHoc,TyLeDiemDQT,ISNULL(CONVERT(Nvarchar, DQT),'') DQT,TyLeDiemThi, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, D.[1]),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, D.[2]),'') DiemTHL2
From(
Select *
From (
Select B.MaSinhVien,B.MaMonHoc,B.Malop,B.TenMonHoc,B.NamHoc,B.HocKy,B.TyLeDiemDQT,B.DQT,B.TyLeDiemThi,B.DiemThiL1,B.DiemThiL2,S2.Diem,S2.LanThu
From
(
--Begin B
Select MaSinhVien,MaMonhoc,Malop,TenMonhoc,NamHoc,HocKy,TyLeDiemDQT,DQT,TyLeDiemThi,[1] As DiemThiL1,[2] DiemThiL2
From (
Select MonDKHoc.MaSinhVien,MonDKHoc.MaMonHoc,MonDKHoc.Malop,MonDKHoc.TenMonHoc,MonDKHoc.NamHoc,MonDKHoc.HocKy,S.LoaiDiem,S.TyLeDiem TyLeDiemDQT,S.Diem DQT,S1.TyLeDiem TyLeDiemThi,CASE WHEN S1.ApDungDiemPhucKhao=1 THEN S1.DiemPhucKhao ELSE S1.Diem END DiemThi,S1.LanThu
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocLai) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy2 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) as MonDKHoc
LEFT OUTER JOIN SV_DiemChiTiet S ON MonDKHoc.MaSinhVien=S.MaSinhVien AND MonDKHoc.MaMonHoc=S.MaMonHoc AND MonDKHoc.NamHoc=S.NamHoc AND MonDKHoc.HocKy=S.HocKy and S.LoaiDiem not in ('CS1','CS2','CN1','CN2')
LEFT OUTER JOIN SV_DiemKiemTra_ThiHK S1 ON MonDKHoc.MaSinhVien=S1.MaSinhVien AND MonDKHoc.MaMonHoc=S1.MaMonHoc AND MonDKHoc.NamHoc=S1.NamHoc AND MonDKHoc.HocKy=S1.HocKy 

Where MonDKHoc.MaSinhVien=@Masinhvien 
) AS A
PIVOT (AVG(A.DiemThi) For A.LanThu IN ([1],[2]))as AVGDiem
) AS B 
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON B.MaSinhVien=S2.MaSinhVien AND B.MaMonHoc=S2.MaMonHoc AND B.NamHoc=S2.NamHoc AND B.HocKy=S2.HocKy 
Where S2.MaMonHoc not in (select MaMonHoc from SV_DiemChiTiet where MaSinhVien=@Masinhvien and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and HocKy=(Select HocKy From HocKy Where HienTai=1) and LoaiDiem in ('CS1','CS2','CN1','CN2'))
--So diem End
) AS C
PIVOT (AVG(C.Diem) For C.LanThu IN ([1],[2]))as AVGDiem
) AS D
UNION ALL 
--Điểm thi môn tốt nghiệp
Select MaMonHoc,TenMonHoc,'50' AS TyLeDiemDQT ,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, '50' AS TyLeDiemThi,ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, DiemTHL1),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, DiemTHL2),'') DiemTHL2
From (
Select A.MaMonHoc,A.TenMonHoc,A.CS1 DQT,A.CS2 DiemThiL1,S2.Diem DiemTHL1,Null 'DiemThiL2' ,Null 'DiemTHL2' 
From (
Select *
From (
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,M.TenMonHoc,S.LoaiDiem,S.Diem
From SV_DiemChiTiet S
inner join MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.LoaiDiem in ('CS1','CS2') and S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and S.HocKy=(Select HocKy From HocKy Where HienTai=1) and S.MaSinhVien=@Masinhvien
) as CS
PIVOT (AVG(Diem) For LoaiDiem IN ([CS1],[CS2]))as AVGDiem
) as A
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON A.MaSinhVien=S2.MaSinhVien AND A.MaMonHoc=S2.MaMonHoc AND A.NamHoc=S2.NamHoc AND A.HocKy=S2.HocKy 
Union all
Select A.MaMonHoc,A.TenMonHoc,A.CN1 DQT,A.CN2 DiemThiL1,S2.Diem DiemTHL1,Null 'DiemThiL2',Null 'DiemTHL2' 
From (
Select *
From (
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,M.TenMonHoc,S.LoaiDiem,S.Diem
From SV_DiemChiTiet S
inner join MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.LoaiDiem in ('CN1','CN2') and S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and S.HocKy=(Select HocKy From HocKy Where HienTai=1) and S.MaSinhVien=@Masinhvien
) as CN
PIVOT (AVG(Diem) For LoaiDiem IN ([CN1],[CN2]))as AVGDiem
) as A
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON A.MaSinhVien=S2.MaSinhVien AND A.MaMonHoc=S2.MaMonHoc AND A.NamHoc=S2.NamHoc AND A.HocKy=S2.HocKy
) AS DiemTN
) AS Diem
) AS BangDiem
--End BangDiem
ORDER BY TenMonHoc 
Go
GRANT EXECUTE ON uspDiemMonHocTrongKy2 To ws;
--------------------------------------------------------------------------------------------
---------------------------------------------------------------
-- Điểm môn học trong học, áp dụng cho học kỳ 3  ----*
--------------------------------------------------------------*
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDiemMonHocTrongKy3' ) IS NOT NULL 
    DROP PROCEDURE uspDiemMonHocTrongKy3;
GO
CREATE PROC dbo.uspDiemMonHocTrongKy3
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
SELECT DISTINCT *
FROM
(--Begin BangDiem 
Select MaMonHoc,TenMonHoc,Case WHEN TyLeDiemDQT IS NULL THEN CONVERT(varchar, TyLeDiemThi) ELSE CONVERT(varchar, TyLeDiemDQT)+'/'+ CONVERT(varchar, TyLeDiemThi) END TyLeDiem ,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, DiemTHL1),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, DiemTHL2),'') DiemTHL2
From (
-- Điểm môn học trong kỳ
Select MaMonHoc,TenMonHoc,TyLeDiemDQT,ISNULL(CONVERT(Nvarchar, DQT),'') DQT,TyLeDiemThi, ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, D.[1]),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, D.[2]),'') DiemTHL2
From(
Select *
From (
Select B.MaSinhVien,B.MaMonHoc,B.Malop,B.TenMonHoc,B.NamHoc,B.HocKy,B.TyLeDiemDQT,B.DQT,B.TyLeDiemThi,B.DiemThiL1,B.DiemThiL2,S2.Diem,S2.LanThu
From
(
--Begin B
Select MaSinhVien,MaMonhoc,Malop,TenMonhoc,NamHoc,HocKy,TyLeDiemDQT,DQT,TyLeDiemThi,[1] As DiemThiL1,[2] DiemThiL2
From (
Select MonDKHoc.MaSinhVien,MonDKHoc.MaMonHoc,MonDKHoc.Malop,MonDKHoc.TenMonHoc,MonDKHoc.NamHoc,MonDKHoc.HocKy,S.LoaiDiem,S.TyLeDiem TyLeDiemDQT,S.Diem DQT,S1.TyLeDiem TyLeDiemThi,CASE WHEN S1.ApDungDiemPhucKhao=1 THEN S1.DiemPhucKhao ELSE S1.Diem END DiemThi,S1.LanThu
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocLai) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy3 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) as MonDKHoc
LEFT OUTER JOIN SV_DiemChiTiet S ON MonDKHoc.MaSinhVien=S.MaSinhVien AND MonDKHoc.MaMonHoc=S.MaMonHoc AND MonDKHoc.NamHoc=S.NamHoc AND MonDKHoc.HocKy=S.HocKy and S.LoaiDiem not in ('CS1','CS2','CN1','CN2')
LEFT OUTER JOIN SV_DiemKiemTra_ThiHK S1 ON MonDKHoc.MaSinhVien=S1.MaSinhVien AND MonDKHoc.MaMonHoc=S1.MaMonHoc AND MonDKHoc.NamHoc=S1.NamHoc AND MonDKHoc.HocKy=S1.HocKy 

Where MonDKHoc.MaSinhVien=@Masinhvien 
) AS A
PIVOT (AVG(A.DiemThi) For A.LanThu IN ([1],[2]))as AVGDiem
) AS B 
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON B.MaSinhVien=S2.MaSinhVien AND B.MaMonHoc=S2.MaMonHoc AND B.NamHoc=S2.NamHoc AND B.HocKy=S2.HocKy 
Where S2.MaMonHoc not in (select MaMonHoc from SV_DiemChiTiet where MaSinhVien=@Masinhvien and NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and HocKy=(Select HocKy From HocKy Where HienTai=1) and LoaiDiem in ('CS1','CS2','CN1','CN2'))
--So diem End
) AS C
PIVOT (AVG(C.Diem) For C.LanThu IN ([1],[2]))as AVGDiem
) AS D
UNION ALL 
--Điểm thi môn tốt nghiệp
Select MaMonHoc,TenMonHoc,'50' AS TyLeDiemDQT ,ISNULL(CONVERT(Nvarchar, DQT),'') DQT, '50' AS TyLeDiemThi,ISNULL(CONVERT(Nvarchar, DiemThiL1),'') DiemThiL1,ISNULL(CONVERT(Nvarchar, DiemTHL1),'') DiemTHL1 ,ISNULL(CONVERT(Nvarchar, DiemThiL2),'') DiemThiL2,ISNULL(CONVERT(Nvarchar, DiemTHL2),'') DiemTHL2
From (
Select A.MaMonHoc,A.TenMonHoc,A.CS1 DQT,A.CS2 DiemThiL1,S2.Diem DiemTHL1,Null 'DiemThiL2' ,Null 'DiemTHL2' 
From (
Select *
From (
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,M.TenMonHoc,S.LoaiDiem,S.Diem
From SV_DiemChiTiet S
inner join MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.LoaiDiem in ('CS1','CS2') and S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and S.HocKy=(Select HocKy From HocKy Where HienTai=1) and S.MaSinhVien=@Masinhvien
) as CS
PIVOT (AVG(Diem) For LoaiDiem IN ([CS1],[CS2]))as AVGDiem
) as A
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON A.MaSinhVien=S2.MaSinhVien AND A.MaMonHoc=S2.MaMonHoc AND A.NamHoc=S2.NamHoc AND A.HocKy=S2.HocKy 
Union all
Select A.MaMonHoc,A.TenMonHoc,A.CN1 DQT,A.CN2 DiemThiL1,S2.Diem DiemTHL1,Null 'DiemThiL2',Null 'DiemTHL2' 
From (
Select *
From (
Select S.MaSinhVien,S.NamHoc,S.HocKy,S.MaMonHoc,M.TenMonHoc,S.LoaiDiem,S.Diem
From SV_DiemChiTiet S
inner join MonHoc M ON S.MaMonHoc=M.MaMonHoc
Where S.LoaiDiem in ('CN1','CN2') and S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) and S.HocKy=(Select HocKy From HocKy Where HienTai=1) and S.MaSinhVien=@Masinhvien
) as CN
PIVOT (AVG(Diem) For LoaiDiem IN ([CN1],[CN2]))as AVGDiem
) as A
LEFT OUTER JOIN SV_DiemTrungBinhMonHoc S2 ON A.MaSinhVien=S2.MaSinhVien AND A.MaMonHoc=S2.MaMonHoc AND A.NamHoc=S2.NamHoc AND A.HocKy=S2.HocKy
) AS DiemTN
) AS Diem
) AS BangDiem
--End BangDiem
ORDER BY TenMonHoc 
Go
GRANT EXECUTE ON uspDiemMonHocTrongKy3 To ws;
---------------------------------------------------------------
-- Học bổng theo năm học
--------------------------------------------------------------*

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspHocBongSinhVien' ) IS NOT NULL 
    DROP PROCEDURE uspHocBongSinhVien;
GO
CREATE PROC dbo.uspHocBongSinhVien
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.NamHoc,S.diemTBCHT,X.Ten XepLoaiHocTap,X2.TenXepLoai XepLoaiRenLuyen,X1.Ten XepLoaiHocBong
From SV_DuKienNhanHocBong S
INNER JOIN XepLoaiHocTap_NienChe X ON S.xepLoaiHocTap=X.XepLoai
INNER JOIN XEP_LOAI_HOC_BONG X1 ON S.xepLoaiHocBong=X1.Ma
INNER JOIN XepLoaiRenLuyen X2 ON S.xepLoaiRenLuyen=X2.XepLoai
Where S.MaSinhVien=@Masinhvien
ORDER BY S.NamHoc
Go
GRANT EXECUTE ON uspHocBongSinhVien To ws;

----------------------------------------------------------------------*
---------------------------------------------------------------------
--Trung binh chung tich luy va xep loai hoc tap
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTBCTL_XepLoai' ) IS NOT NULL 
    DROP PROCEDURE uspTBCTL_XepLoai;
GO
CREATE PROC dbo.uspTBCTL_XepLoai
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,S.NamHoc,S.HocKy,ROUND(S.Diem,2) Diem10,X2.Ten XepLoai10,ROUND(S.Diem4,2) Diem4,X1.TenXepLoai XepLoai4
From SV_DiemTrungBinhTichLuy_NamHoc S 
INNER JOIN XepLoaiHocTap_TinChi X1 ON S.XepLoai4=X1.XepLoai
INNER JOIN XepLoaiHocTap_NienChe X2 ON S.XepLoai=X2.XepLoai
Where S.MaSinhVien=@masinhvien 
ORDER BY S.NamHoc,S.HocKy
GO
GRANT EXECUTE ON uspTBCTL_XepLoai To ws;
-----------------------------------------------------------------------
--Trung binh trung tích lũy, toàn khóa, xep loai tích lũy, toan khoa
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTBCTLXepLoai_TK' ) IS NOT NULL 
    DROP PROCEDURE uspTBCTLXepLoai_TK;
GO
CREATE PROC dbo.uspTBCTLXepLoai_TK
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select S.MaSinhVien,ROUND(S.Diem,2) Diem10,X1.Ten XepLoai10,ROUND(S.Diem4,2) Diem4,X.TenXepLoai XepLoai4, S1.Diem10 TBTK_Diem10,S1.Diem4 TBTK_Diem4,S1.XepLoai10 TBTK_XepLoai10,S1.XepLoai4 TBTK_XepLoai4
From SV_DiemTrungBinhTichLuy S 
INNER JOIN XepLoaiHocTap_TinChi X ON S.XepLoai4=X.XepLoai
INNER JOIN XepLoaiHocTap_NienChe X1 ON S.XepLoai=X1.XepLoai
LEFT OUTER JOIN (Select S.MaSinhVien,ROUND(S.Diem,2) Diem10,X1.Ten XepLoai10,ROUND(S.Diem4,2) Diem4,X.TenXepLoai XepLoai4
From SV_DiemTrungBinhToanKhoaHoc S 
INNER JOIN XepLoaiHocTap_TinChi X ON S.XepLoai4=X.XepLoai
INNER JOIN XepLoaiHocTap_NienChe X1 ON S.XepLoai=X1.XepLoai
Where S.MaSinhVien=@masinhvien) S1 ON S.MaSinhVien=S1.MaSinhVien  
Where S.MaSinhVien=@masinhvien
 
GO
GRANT EXECUTE ON uspTBCTLXepLoai_TK To ws;

--------------------------------------------------------------------------------------------
-- Danh sách các khóa học đang học
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspKhoaHoc' ) IS NOT NULL 
    DROP PROCEDURE uspKhoaHoc;
GO
CREATE PROC dbo.uspKhoaHoc
@Masinhvien AS nvarchar(10)
WITH ENCRYPTION
AS
Select RTRIM(MaKhoaHoc) MaKhoaHoc,RTRIM(TenKhoaHoc) TenKhoaHoc 
From KhoaHoc
Where NamVaoTruong+5>YEAR(GETDATE())
ORDER BY TenKhoaHoc 
GO
GRANT EXECUTE ON uspKhoaHoc To ws;
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
---Procedures Sổ đầu bài
--1. Phân công giảng dạy Giảng viên theo các lớp môn học 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopMonGiangVien' ) IS NOT NULL 
    DROP PROCEDURE uspLopMonGiangVien;
GO
CREATE PROC dbo.uspLopMonGiangVien
WITH ENCRYPTION
AS
Select DISTINCT TenGiaoVien,LTRIM(RTRIM(MaGiaoVien)) MaGiaoVien,LTRIM(RTRIM(MaLop)) MaLop,LTRIM(RTRIM(MaMonHoc)) MamonHoc,LTRIM(RTRIM(TenMonHoc)) TenMonHoc,TuanHocBatDau
From (
SELECT     LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc,M.TenMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
INNER JOIN MonHoc M ON TKB_ChiTiet.MaMonHoc=M.MaMonHoc
WHERE    (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1))
) AS L
--Where MaLop not like '%-[0-9]-%'
Order by TenMonHoc
GO
GRANT EXECUTE ON uspLopMonGiangVien To ws;
Execute uspLopMonGiangVien;
-------------------------------------------------------------------------------------------

--2.Thời khóa biểu chi tiết các buổi học của Giảng viên 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKBGiangVien' ) IS NOT NULL 
    DROP PROCEDURE uspTKBGiangVien;
GO
CREATE PROC dbo.uspTKBGiangVien

WITH ENCRYPTION
AS
SELECT  DISTINCT   LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,LTRIM(RTRIM(GiaoVien.MaGiaoVien)) MaGiaoVien,LTRIM(RTRIM(TKB_ChiTiet.MaLop)) MaLop,LTRIM(RTRIM(TKB_ChiTiet.MaMonHoc))MaMonHoc,M.TenMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
INNER JOIN MonHoc M ON TKB_ChiTiet.MaMonHoc=M.MaMonHoc
WHERE (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1))
GO
GRANT EXECUTE ON uspTKBGiangVien To ws;
-----------------------------------------------------------------------------------------------
--3.Thời khóa biểu chi tiết các buổi học 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspTKBTheoGiaiDoan' ) IS NOT NULL 
    DROP PROCEDURE uspTKBTheoGiaiDoan;
GO
CREATE PROC dbo.uspTKBTheoGiaiDoan
WITH ENCRYPTION
AS
SELECT  DISTINCT   LTRIM(RTRIM(GiaoVien.HoDem))+' '+LTRIM(RTRIM(GiaoVien.Ten)) AS TenGiaoVien,GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,LTRIM(RTRIM(TKB_ChiTiet.MaMonHoc)) MaMonHoc,LTRIM(RTRIM(M.TenMonHoc)) TenMonHoc,TKB_ChiTiet.MaPhongHoc,TKB.NamHoc, TKB.HocKy,TKB_ChiTiet.SoTiet,TKB_ChiTiet.TuanHocBatDau,NamHoc_ThoiGianTuan.TuNgay,DATEADD(DD,(TKB_ChiTiet.SoTuanHoc)*7,NamHoc_ThoiGianTuan.TuNgay) NgayKetThuc,TKB_ChiTiet.SoTuanHoc,TKB_ChiTiet.TietBatDau,TKB_ChiTiet.Thu
FROM         TKB_ChiTiet
INNER JOIN  TKB ON TKB_ChiTiet.MaTKB = TKB.MaTKB
INNER JOIN NamHoc_ThoiGianTuan ON TKB.NamHoc=NamHoc_ThoiGianTuan.MaNamHoc AND TKB_ChiTiet.TuanHocBatDau=NamHoc_ThoiGianTuan.Tuan
LEFT OUTER JOIN TKB_ChiTiet_GiaoVien On TKB_ChiTiet.MaTKBChiTiet=TKB_ChiTiet_GiaoVien.MaTKBChiTiet
INNER JOIN GiaoVien On TKB_ChiTiet_GiaoVien.MaGiaoVien=GiaoVien.MaGiaoVien
INNER JOIN MonHoc M ON TKB_ChiTiet.MaMonHoc=M.MaMonHoc
WHERE   (TKB.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)) AND (TKB.HocKy = (Select HocKy From HocKy Where HienTai=1))
--ORDER BY GiaoVien.MaGiaoVien,TKB_ChiTiet.MaLop,TKB_ChiTiet.MaMonHoc
GO
GRANT EXECUTE ON uspTKBTheoGiaiDoan To ws;
-----------------------------------------------------------------------------------------------
---4. Lớp môn học sinh viên theo học kỳ 1
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopMonHocSinhVienHK1' ) IS NOT NULL 
    DROP PROCEDURE uspLopMonHocSinhVienHK1;
GO
CREATE PROC dbo.uspLopMonHocSinhVienHK1
WITH ENCRYPTION
AS
Select   LTRIM(RTRIM(SVLopMon.MaSinhVien)) MaSinhVien,LTRIM(RTRIM(S.HoDem)) Hodem,LTRIM(RTRIM(S.Ten)) Ten,LTRIM(RTRIM(SVLopMon.MaMonHoc)) MaMonHoc,SVLopMon.Malop,LTRIM(RTRIM(SVLopMon.MaLopHanhChinh)) MaLopHanhChinh,LTRIM(RTRIM(SVLopMon.TenMonHoc)) TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy1 > 0
       AND B.TrangThai IN (0,2,3,5,10)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) AS SVLopMon
INNER JOIN SinhVien S ON SVLopMon.MaSinhVien= S.MaSinhVien 
Where LTRIM(RTRIM(SVLopMon.MaSinhVien))+ LTRIM(RTRIM(SVLopMon.MaMonHoc)) Not in ( Select LTRIM(RTRIM(MaSinhVien))+ LTRIM(RTRIM(MaMonHoc)) From SV_MienHoc Where NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) And HocKy=(Select HocKy From HocKy Where HienTai=1))   
ORDER BY SVLopMon.MaSinhVien,SVLopMon.TenMonHoc
GO
GRANT EXECUTE ON uspLopMonHocSinhVienHK1 To ws;
-----------------------------------------------------------------------------------------------
----Lớp môn học sinh viên theo học kỳ 2
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopMonHocSinhVienHK2' ) IS NOT NULL 
    DROP PROCEDURE uspLopMonHocSinhVienHK2;
GO
CREATE PROC dbo.uspLopMonHocSinhVienHK2
WITH ENCRYPTION
AS
Select LTRIM(RTRIM(SVLopMon.MaSinhVien)) MaSinhVien,LTRIM(RTRIM(S.HoDem)) Hodem,LTRIM(RTRIM(S.Ten)) Ten,LTRIM(RTRIM(SVLopMon.MaMonHoc)) MaMonHoc,SVLopMon.Malop,LTRIM(RTRIM(SVLopMon.MaLopHanhChinh)) MaLopHanhChinh,LTRIM(RTRIM(SVLopMon.TenMonHoc)) TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy2 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) AS SVLopMon
INNER JOIN SinhVien S ON SVLopMon.MaSinhVien= S.MaSinhVien 
Where LTRIM(RTRIM(SVLopMon.MaSinhVien))+ LTRIM(RTRIM(SVLopMon.MaMonHoc)) Not in ( Select LTRIM(RTRIM(MaSinhVien))+ LTRIM(RTRIM(MaMonHoc)) From SV_MienHoc Where NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) And HocKy=(Select HocKy From HocKy Where HienTai=1))   
ORDER BY SVLopMon.MaSinhVien,SVLopMon.TenMonHoc
GO
GRANT EXECUTE ON uspLopMonHocSinhVienHK2 To ws;
-----------------------------------------------------------------------------------------------
----Lớp môn học sinh viên theo học kỳ 3
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopMonHocSinhVienHK3' ) IS NOT NULL 
    DROP PROCEDURE uspLopMonHocSinhVienHK3;
GO
CREATE PROC dbo.uspLopMonHocSinhVienHK3
WITH ENCRYPTION
AS
Select LTRIM(RTRIM(SVLopMon.MaSinhVien)) MaSinhVien,LTRIM(RTRIM(S.HoDem)) Hodem,LTRIM(RTRIM(S.Ten)) Ten,LTRIM(RTRIM(SVLopMon.MaMonHoc)) MaMonHoc,SVLopMon.Malop,LTRIM(RTRIM(SVLopMon.MaLopHanhChinh)) MaLopHanhChinh,LTRIM(RTRIM(SVLopMon.TenMonHoc)) TenMonHoc
From (
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy3 > 0
       AND B.TrangThai IN (0,2,3,5,10)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
) AS SVLopMon
INNER JOIN SinhVien S ON SVLopMon.MaSinhVien= S.MaSinhVien 
Where LTRIM(RTRIM(SVLopMon.MaSinhVien))+ LTRIM(RTRIM(SVLopMon.MaMonHoc)) Not in ( Select LTRIM(RTRIM(MaSinhVien))+ LTRIM(RTRIM(MaMonHoc)) From SV_MienHoc Where NamHoc=(Select MaNamhoc From HocKy Where HienTai=1) And HocKy=(Select HocKy From HocKy Where HienTai=1))   
ORDER BY SVLopMon.MaSinhVien,SVLopMon.TenMonHoc
GO
GRANT EXECUTE ON uspLopMonHocSinhVienHK3 To ws;
----------------------------------------------------------------
-- Thời gian theo tuần học
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspThoiGianTuan' ) IS NOT NULL 
    DROP PROCEDURE uspThoiGianTuan;
GO
CREATE PROC dbo.uspThoiGianTuan
WITH ENCRYPTION
AS
Select T.Tuan,T.TuNgay,T.DenNgay
From NamHoc_ThoiGianTuan T 
Where T.MaNamHoc=(Select MaNamHoc From HocKy Where HienTai=1) 
Order by T.Tuan
Go
GRANT EXECUTE ON uspThoiGianTuan To ws;
-------------------------------------------------------
--Lop ghep trong hoc ky 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopGhepHK' ) IS NOT NULL 
    DROP PROCEDURE uspLopGhepHK;
GO
CREATE PROC dbo.uspLopGhepHK
WITH ENCRYPTION
AS
Select DISTINCT S.MaSinhVien,L.MaLopGhep,L.NamHoc,L.HocKy,L1.MaLop,L3.MaMonHoc
From LopGhep L
INNER JOIN LopGhep_ChiTiet L1 ON L.MaGhepLop=L1.MaGhepLop
INNER JOIN LopGhep_MonHoc L3 ON L.MaGhepLop=L3.MaGhepLop
INNER JOIN SinhVien S ON L1.MaLop=S.MaLop
Where L.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)and L.HocKy=(Select HocKy From HocKy Where HienTai=1) AND S.TrangThai IN (0,2,3,5,10,11,13,14,100)
Order by MaLopGhep,MaLop
GO
GRANT EXECUTE ON uspLopGhepHK To ws;
----------------------------------------------
--Danh sách Lớp Quản Lý
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopQuanLy' ) IS NOT NULL 
    DROP PROCEDURE uspLopQuanLy;
GO
CREATE PROC dbo.uspLopQuanLy
WITH ENCRYPTION
AS
Select MaLop,MaNganh,MaKhoaHoc,MaHeDaoTao,DaoTaoTheoTinChi
From LopQuanLy
Order by MaKhoaHoc,MaHeDaoTao,MaLop
GO
GRANT EXECUTE ON uspLopQuanLy To ws;
-----------------------------------------------
--Danh sách phòng học, phòng máy
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspPhongHoc' ) IS NOT NULL 
    DROP PROCEDURE uspPhongHoc;
GO
CREATE PROC dbo.uspPhongHoc
WITH ENCRYPTION
AS
SELECT MaPhongHoc
      ,TenPhongHoc
      ,MaViTri
      ,MaToaNha
      ,ChiSoTang
      ,SoBan
      ,HeSoHoc
      ,HeSoThi
      ,KieuPhong
FROM PhongHoc
Where KhongSuDung=0
ORDER BY MaToaNha,MaPhongHoc
GO
GRANT EXECUTE ON uspPhongHoc To ws;
-----------------------------------------------
--Danh mục môn học
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspDanhMucMonHoc' ) IS NOT NULL 
    DROP PROCEDURE uspDanhMucMonHoc;
GO
CREATE PROC dbo.uspDanhMucMonHoc
WITH ENCRYPTION
AS
Select distinct MaMonHoc,TenMonHoc
From MonHoc
Order by TenMonHoc,MaMonHoc
GO
GRANT EXECUTE ON uspDanhMucMonHoc To ws;
---------------------------------------------

-- Lịch thi học kỳ 1--------------------------

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLichThiHK1' ) IS NOT NULL 
    DROP PROCEDURE uspLichThiHK1;
GO
CREATE PROC uspLichThiHK1
@Masinhvien AS nvarchar(10),
@Namhoc AS nvarchar(10),
@Hocky int,
@LanThi int 
WITH ENCRYPTION
AS

Select H.NamHoc,H.HocKy,MonDK.Malop,MonDK.TenMonHoc,H.ngay,H.gio,H.DD_thi,H.HT_Thi,H.LanThi,ISNULL(H.GhiChu,'') GhiChu
From ( 
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=@namhoc,@Hocky
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy1 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
Where D.MaSinhVien=@Masinhvien
) AS MonDK
LEFT OUTER JOIN HPU_LichThi H ON RTRIM(MonDK.Malop)=RTRIM(H.Lop)
and RTRIM(MonDK.TenMonHoc) like RTRIM(H.Tenmonhoc)AND MonDK.NamHoc=H.NamHoc AND MonDK.HocKy=H.HocKy 
Where H.Ngay is not null and H.LanThi=@LanThi
Order by H.Ngay,H.gio 
Go
GRANT EXECUTE ON uspLichThiHK1 To ws;

--------------------------------------------------------------------
-- Lịch thi học kỳ 2

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLichThiHK2' ) IS NOT NULL 
    DROP PROCEDURE uspLichThiHK2;
GO
CREATE PROC uspLichThiHK2
@Masinhvien AS nvarchar(10),
@Namhoc AS nvarchar(10),
@Hocky int,
@LanThi int 
WITH ENCRYPTION
AS

Select H.NamHoc,H.HocKy,MonDK.Malop,MonDK.TenMonHoc,H.ngay,H.gio,H.DD_thi,H.HT_Thi,H.LanThi,ISNULL(H.GhiChu,'') GhiChu
From ( 
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=@namhoc,@Hocky
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy2 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
Where D.MaSinhVien=@Masinhvien
) AS MonDK
LEFT OUTER JOIN HPU_LichThi H ON RTRIM(MonDK.Malop)=RTRIM(H.Lop)
and RTRIM(MonDK.TenMonHoc) like RTRIM(H.Tenmonhoc)AND MonDK.NamHoc=H.NamHoc AND MonDK.HocKy=H.HocKy 
Where H.Ngay is not null and H.LanThi=@LanThi
Order by H.Ngay,H.gio 
Go
GRANT EXECUTE ON uspLichThiHK2 To ws;
---------------------------------------------------------------    

-- Lịch thi học kỳ 3--------------------------

USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLichThiHK3' ) IS NOT NULL 
    DROP PROCEDURE uspLichThiHK3;
GO
CREATE PROC uspLichThiHK3
@Masinhvien AS nvarchar(10),
@Namhoc AS nvarchar(10),
@Hocky int,
@LanThi int 
WITH ENCRYPTION
AS

Select H.NamHoc,H.HocKy,MonDK.Malop,MonDK.TenMonHoc,H.ngay,H.gio,H.DD_thi,H.HT_Thi,H.LanThi,ISNULL(H.GhiChu,'') GhiChu
From ( 
SELECT DISTINCT C.MaSinhVien, C.MaMonHoc, C.MaLopMonHoc Malop, RTRIM(D.MaLop) MaLopHanhChinh, RTRIM(E.TenMonHoc) TenMonHoc,NamHoc,HocKy
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       AND A.MaLop NOT LIKE '%-bt%'
       --AND A.MaLop = @malop
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy = @Hocky
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=@namhoc,@Hocky
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = @namhoc
       AND A.HocKy3 > 0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
       --AND A.MaLop = @malop
       --AND A.MaMonHoc = @mamonhoc
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
Where D.MaSinhVien=@Masinhvien
) AS MonDK
LEFT OUTER JOIN HPU_LichThi H ON RTRIM(MonDK.Malop)=RTRIM(H.Lop)
and RTRIM(MonDK.TenMonHoc) like RTRIM(H.Tenmonhoc)AND MonDK.NamHoc=H.NamHoc AND MonDK.HocKy=H.HocKy 
Where H.Ngay is not null and H.LanThi=@LanThi
Order by H.Ngay,H.gio 
Go
GRANT EXECUTE ON uspLichThiHK3 To ws;

-- ======================================================================
-- Author:	Do Van Tuyen
-- Create date: 12/03/2013
-- Description: Thủ tục lấy danh sách môn học của sinh viên trong kỳ hiện tại
-- ======================================================================
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspPhanMonCuaSinhVienTheoKyHienTai' ) IS NOT NULL 
    DROP PROCEDURE uspPhanMonCuaSinhVienTheoKyHienTai;
GO
CREATE PROC dbo.uspPhanMonCuaSinhVienTheoKyHienTai

WITH ENCRYPTION
AS
SET NOCOUNT ON
SELECT DISTINCT C.MaSinhVien,D.HoDem,D.Ten,NgaySinh,CASE WHEN D.GioiTinh=1 THEN N'Nam' ELSE N'Nữ' END GioiTinh,D.MaLop LopQuanLy,MaLopMonHoc,C.MaMonHoc, RTRIM(E.TenMonHoc) TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(C.MaMonHoc)),7,1) as InT) SoTC
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLop NOT LIKE '%-[1-9]-%'  
      
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
     
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND (CASE WHEN (Select HocKy From HocKy Where HienTai=1) =1 THEN A.HocKy1 
				WHEN (Select HocKy From HocKy Where HienTai=1) =2 THEN A.HocKy2 
				ELSE A.HocKy3 
				 END )>0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
     
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
  --Where C.MaSinhVien=@Masinhvien AND LEFT(RTRIM(C.MaMonHoc),8)=@Mamonhoc     
GO
GRANT EXECUTE ON uspPhanMonCuaSinhVienTheoKyHienTai To ws;


-- ======================================================================
-- Author:	Do Van Tuyen
-- Create date: 12/03/2013
-- Description: Thủ tục lấy danh sách môn học của sinh viên trong kỳ hiện tại
-- ======================================================================
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspPhanMonCuaSinhVienTheoKyHienTai_VP' ) IS NOT NULL 
    DROP PROCEDURE uspPhanMonCuaSinhVienTheoKyHienTai_VP;
GO
CREATE PROC dbo.uspPhanMonCuaSinhVienTheoKyHienTai_VP
@Masinhvien AS nvarchar(10),
@Mamonhoc AS nvarchar(50)
WITH ENCRYPTION
AS
SET NOCOUNT ON
SELECT DISTINCT C.MaSinhVien,D.HoDem,D.Ten,NgaySinh,CASE WHEN D.GioiTinh=1 THEN N'Nam' ELSE N'Nữ' END GioiTinh,D.MaLop LopQuanLy,MaLopMonHoc,C.MaMonHoc , RTRIM(E.TenMonHoc) TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(C.MaMonHoc)),7,1) as InT) SoTC
--INTO ThamDo_LopMon
FROM
(
SELECT DISTINCT
       RTRIM(B.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien ,B.NamHoc,B.HocKy
FROM
       LopTinChi A INNER JOIN LopTinChi_SinhVien B ON
       A.MaLop = B.MaLop
       AND A.NamHoc = B.NamHoc
       AND A.HocKy = B.HocKy
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       AND A.MaLop NOT LIKE '%-[1-9]-%'  
      
UNION        
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonHocGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien, A.NamHoc,A.HocKy
FROM
       SV_GhepLop A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
     
UNION
SELECT DISTINCT
       RTRIM(A.MaLopGhep) MaLopMonHoc, RTRIM(A.MaMonGhep) MaMonHoc, RTRIM(A.MaSinhVien) MaSinhVien,A.NamHoc,A.HocKy
FROM
       SV_HocBoSung A
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND A.HocKy = (Select HocKy From HocKy Where HienTai=1)
       --AND A.MaLopGhep = @malop
UNION
SELECT DISTINCT
       RTRIM(A.MaLop) MaLopMonHoc, RTRIM(A.MaMonHoc) MaMonHoc, RTRIM(B.MaSinhVien) MaSinhVien,NamHoc=(Select MaNamhoc From HocKy Where HienTai=1),HocKy=(Select HocKy From HocKy Where HienTai=1)
FROM
       LopQuanLy_MonHoc A INNER JOIN SinhVien B ON
       A.MaLop = B.MaLop
WHERE
       A.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
       AND (CASE WHEN (Select HocKy From HocKy Where HienTai=1) =1 THEN A.HocKy1 
				WHEN (Select HocKy From HocKy Where HienTai=1) =2 THEN A.HocKy2 
				ELSE A.HocKy3 
				 END )>0
       AND B.TrangThai IN (0,2,3,5,10,11,13,14,100,101)
     
) C INNER JOIN SinhVien D ON
       C.MaSinhVien = D.MaSinhVien INNER JOIN MonHoc E ON
       C.MaMonHoc = E.MaMonHoc
  Where C.MaSinhVien=@Masinhvien AND LEFT(RTRIM(C.MaMonHoc),8)=@Mamonhoc     
GO
GRANT EXECUTE ON uspPhanMonCuaSinhVienTheoKyHienTai_VP To ws;
-------------------------------------------------------------------------------------------
--Danh lớp niên chế được phân công trong học kỳ  
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopNienCheCoPhanMon' ) IS NOT NULL 
    DROP PROCEDURE uspLopNienCheCoPhanMon;
GO
CREATE PROC dbo.uspLopNienCheCoPhanMon
@NamHoc AS Nvarchar(10),
@Hocky AS int
WITH ENCRYPTION
AS
SELECT DISTINCT
       RTRIM(A.MaLop)MaLop
FROM
       LopQuanLy_MonHoc A 
WHERE
       A.NamHoc = @NamHoc
       AND (CASE WHEN @Hocky =1 THEN A.HocKy1 
				WHEN @Hocky =2 THEN A.HocKy2 
				ELSE A.HocKy3 
				 END )>0
Order by MaLop
GO
GRANT EXECUTE ON uspLopNienCheCoPhanMon To ws;
------------------------------------------------
---Hàm kiểm tra lớp tín chỉ đã tồn tại
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspKiemTraLopTinChi' ) IS NOT NULL 
    DROP PROCEDURE uspKiemTraLopTinChi;
GO

CREATE FUNCTION uspKiemTraLopTinChi
(
@Namhoc AS nvarchar(10),@Hocky AS int, @Malop AS nvarchar(20) 
)
RETURNS int 
AS
BEGIN
DECLARE @check INT
	SELECT @check=COUNT(*) FROM loptinchi WHERE Namhoc=@Namhoc and Hocky=@Hocky and malop=@Malop
	IF @check>0
		Set @check =1
	ELSE
		SET @check=0
	RETURN @check
END
Go
GRANT EXECUTE ON uspKiemTraLopTinChi To ws;

------------------------------------------------
---Hàm kiểm tra điểm môn học 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspKiemTraDiemMonHoc' ) IS NOT NULL 
    DROP PROCEDURE uspKiemTraDiemMonHoc;
GO

CREATE FUNCTION uspKiemTraDiemMonHoc
(
@Namhoc AS nvarchar(10),@Hocky AS int, @Mamonhoc AS nvarchar(20),@Masinhvien AS nvarchar(20)
)
RETURNS int 
AS
BEGIN
DECLARE @check INT
	SELECT @check= COUNT(*)
From (Select *
FROM (Select S1.MaSinhVien,S1.MaMonHoc,S1.NamHoc,S1.HocKy,S2.Diem DiemQT,S1.LanThu,S1.Diem
From SV_DiemKiemTra_ThiHK S1
LEFT OUTER JOIN SV_DiemChiTiet S2 ON S1.MaSinhVien=S2.MaSinhVien AND S1.MaMonHoc=S2.MaMonHoc AND S1.NamHoc=S2.NamHoc AND S1.HocKy=S2.HocKy
Where S1.NamHoc=@Namhoc And S1.HocKy=@Hocky And S1.MaSinhVien=@Masinhvien and S1.MaMonHoc=@Mamonhoc
) AS TC
PIVOT (AVG(Diem) For LanThu IN ([1],[2]))as AVGDiem
) AS T
LEFT OUTER JOIN LopTinChi_SinhVien L ON T.MaSinhVien=L.MaSinhVien AND T.MaMonHoc=SUBSTRING(LTRIM(RTRIM(L.MaLop)),1,8) AND T.NamHoc=L.NamHoc AND T.HocKy=L.HocKy AND L.HocPhi<>0
INNER JOIN MonHoc M On T.MaMonHoc=M.MaMonHoc
INNER JOIN SinhVien S On T.MaSinhVien=S.MaSinhVien
	IF @check>0
		Set @check =1
	ELSE
		SET @check=0
	RETURN @check
END
Go
GRANT EXECUTE ON uspKiemTraDiemMonHoc To ws;
--------------------------------------------------------------------------------------------------------

--Danh sách môn được phân công trong học kỳ theo lớp niên chế 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHocLopNienChe' ) IS NOT NULL 
    DROP PROCEDURE uspMonHocLopNienChe;
GO
CREATE PROC dbo.uspMonHocLopNienChe

@Namhoc AS nvarchar(10),@Hocky AS int, @Malop AS nvarchar(10)  
WITH ENCRYPTION
AS
Select S.NamHoc,S.HocKy,S.MaLop,S.MaKhoaHoc,S.MaHeDaoTao,S.MaMon,S.TenMonHoc,S.SoTinChi,S.GiaTinChi,dbo.uspKiemTraLopTinChi(@Namhoc,@Hocky,S.MaLop+'-'+S.MaMon) AS TrangThai
From (
Select DISTINCT T.NamHoc,HocKy=@Hocky,RTRIM(T.MaLop) MaLop,L.MaKhoaHoc,L.MaHeDaoTao,RTRIM(T.MaMonHoc) MaMon,RTRIM(M.TenMonHoc) TenMonHoc,CAST(SUBSTRING(LTRIM(RTRIM(T.MaMonHoc)),7,1) as InT) AS SoTinChi,
CASE WHEN L.MaHeDaoTao in ('12') THEN (SELECT GiaTri FROM ThamSo Where MaThamSo='HocPhiMoiTinChiDH')
     WHEN L.MaHeDaoTao in ('08','15') THEN (SELECT GiaTri FROM ThamSo Where MaThamSo='HocPhiMoiTinChiCD')
     WHEN L.MaHeDaoTao in ('13') THEN (SELECT GiaTri FROM ThamSo Where MaThamSo='HocPhiMoiTinChiLT') END GiaTinChi
     
From LopQuanLy_MonHoc T 
INNER JOIN LopQuanLy L ON T.MaLop=L.MaLop
INNER JOIN MonHoc M ON T.MaMonHoc=M.MaMonHoc
Where T.NamHoc=@Namhoc and (CASE WHEN @Hocky =1 THEN T.HocKy1 
				WHEN @Hocky =2 THEN T.HocKy2 
				ELSE T.HocKy3 
				 END )>0 AND T.MaLop =@Malop
) S 

GO
GRANT EXECUTE ON uspMonHocLopNienChe To ws;
-------------------------------------------------------------------------------------------
--Cập nhật, tính toán lại học phí sinh viên tín chỉ
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspUpdateHocPhiTinChi' ) IS NOT NULL 
    DROP PROCEDURE uspUpdateHocPhiTinChi;
GO
CREATE PROC dbo.uspUpdateHocPhiTinChi
@MaSinhVien AS Nvarchar(20)
WITH ENCRYPTION
AS
BEGIN
	DECLARE @check1 INT
	DECLARE @check2 INT
	DECLARE @Namhoc Nvarchar(20)
	DECLARE @Hocky INT
	SET NOCOUNT ON;
	SET @Namhoc=(Select MaNamhoc From HocKy Where HienTai=1)
	SET @Hocky=(Select HocKy From HocKy Where HienTai=1)
	SELECT @check1=COUNT(*)From SV_CAC_KHOAN_PHAI_THU Where namHoc=@Namhoc and hocKy=@Hocky and maSinhVien=@Masinhvien and maKhoanThu='HP'
	IF @check1 = 0
		BEGIN
			INSERT INTO SV_CAC_KHOAN_PHAI_THU(namHoc,hocKy,maSinhVien,maKhoanThu,soTienQuyDinh,SoTienThayDoi,soTienMienGiam,
			SoTienKyTruocChuyenSang,SoTienDaThu,DaThu,SoTienPhaiChi,SoTienDaChi,SoTienChuyenSangKySau) VALUES(@Namhoc,@Hocky,@Masinhvien,'HP',0,0,0,0,0,0,0,0,0)
			SELECT @check2=COUNT(*) From LopTinChi_SinhVien Where namHoc=@Namhoc and hocKy=@Hocky and maSinhVien=@Masinhvien 
			IF @check2 = 0
			UPDATE SV_CAC_KHOAN_PHAI_THU SET soTienQuyDinh=0 Where namHoc=@Namhoc and hocKy=@Hocky and maSinhVien=@Masinhvien and maKhoanThu='HP'
			ELSE 
			Update SV_CAC_KHOAN_PHAI_THU
			Set SV_CAC_KHOAN_PHAI_THU.soTienQuyDinh=t.HP  
			From SV_CAC_KHOAN_PHAI_THU INNER JOIN 
			(SELECT masinhvien, SUM(Hocphi) HP     
			FROM         LopTinChi_SinhVien
			WHERE     (NamHoc = @Namhoc) AND (HocKy = @Hocky) AND MaSinhVien in (select masinhvien
			from SinhVien
			Where MaSinhVien =@Masinhvien)
			Group by MaSinhVien) AS T ON SV_CAC_KHOAN_PHAI_THU.maSinhVien=t.MaSinhVien
			WHERE     (SV_CAC_KHOAN_PHAI_THU.namHoc = @Namhoc) AND (SV_CAC_KHOAN_PHAI_THU.hocKy = @Hocky) and SV_CAC_KHOAN_PHAI_THU.maKhoanThu='HP'
		END

	ELSE
		BEGIN
			SELECT @check2=COUNT(*) FROM  LopTinChi_SinhVien Where namHoc=@Namhoc and hocKy=@Hocky and maSinhVien=@Masinhvien 
			IF @check2 = 0
			UPDATE SV_CAC_KHOAN_PHAI_THU SET soTienQuyDinh=0 Where namHoc=@Namhoc and hocKy=@Hocky and maSinhVien=@Masinhvien and maKhoanThu='HP'
			ELSE 
			Update SV_CAC_KHOAN_PHAI_THU
			Set SV_CAC_KHOAN_PHAI_THU.soTienQuyDinh=t.HP  
			From SV_CAC_KHOAN_PHAI_THU INNER JOIN 
			(SELECT masinhvien, SUM(Hocphi) HP     
			FROM         LopTinChi_SinhVien
			WHERE     (NamHoc = @Namhoc) AND (HocKy = @Hocky) AND MaSinhVien in (select masinhvien
			from SinhVien
			Where MaSinhVien =@Masinhvien)
			Group by MaSinhVien) AS T ON SV_CAC_KHOAN_PHAI_THU.maSinhVien=t.MaSinhVien
			WHERE     (SV_CAC_KHOAN_PHAI_THU.namHoc = @Namhoc) AND (SV_CAC_KHOAN_PHAI_THU.hocKy = @Hocky) and SV_CAC_KHOAN_PHAI_THU.maKhoanThu='HP'
		END
END
GO
GRANT EXECUTE ON uspUpdateHocPhiTinChi To ws;
-------------------------------------------------------------------------------------------
--Danh sách sinh viên theo lớp niên chế 
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhVienLopNienChe' ) IS NOT NULL 
    DROP PROCEDURE uspSinhVienLopNienChe;
GO
CREATE PROC dbo.uspSinhVienLopNienChe
@Malop AS Nvarchar(20)
WITH ENCRYPTION
AS
Select RTRIM(MaSinhVien) MaSinhVien,RTRIM(HoDem) HoDem,RTRIM(Ten) Ten,convert(varchar, NgaySinh, 103) NgaySinh,GioiTinh,RTRIM(MaLop) Malop,
CASE WHEN MaHeDaoTao in ('12') THEN (SELECT GiaTri FROM ThamSo Where MaThamSo='HocPhiMoiTinChiDH')
     WHEN MaHeDaoTao in ('08','15') THEN (SELECT GiaTri FROM ThamSo Where MaThamSo='HocPhiMoiTinChiCD')
     WHEN MaHeDaoTao in ('13') THEN (SELECT GiaTri FROM ThamSo Where MaThamSo='HocPhiMoiTinChiLT') END GiaTinChi 
From SinhVien
Where TrangThai not in (1,8,12,15,16,101) and MaLop=@Malop
ORDER BY Ten
GO
GRANT EXECUTE ON uspSinhVienLopNienChe To ws;

-------------------------------------------------------------------------------------------
--Danh sách sinh viên theo lớp tín chỉ
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspSinhVienLopTinChi' ) IS NOT NULL 
    DROP PROCEDURE uspSinhVienLopTinChi;
GO
CREATE PROC dbo.uspSinhVienLopTinChi
@Namhoc AS nvarchar(10),@Hocky AS int, @Malop AS nvarchar(20) 
WITH ENCRYPTION
AS
Select RTRIM(S.MaSinhVien) MaSinhVien,S.HoDem,S.Ten,convert(varchar, S.NgaySinh, 103) NgaySinh ,S.GioiTinh,RTRIM(S.MaLop) LopQuanLy,RTRIM(L.MaLop) LopMonHoc,L1.MaMonHoc,M.TenMonHoc,L.NamHoc,L.HocKy,L1.KhoiLuong KhoiLuong,dbo.uspKiemTraDiemMonHoc(@Namhoc,@Hocky,L1.MaMonHoc,S.MaSinhVien) AS TrangThaiDiem
From LopTinChi_SinhVien L
INNER JOIN SinhVien S ON L.MaSinhVien=S.MaSinhVien
INNER JOIN LopTinChi L1 ON L.MaLop=L1.MaLop and L.NamHoc=L1.NamHoc and L.HocKy=L1.HocKy
INNER JOIN MonHoc M On L1.MaMonHoc=M.MaMonHoc 
Where L.NamHoc=@Namhoc and L.HocKy=@Hocky and L.MaLop=@Malop
ORDER BY L.MaLop,S.Ten
GO
GRANT EXECUTE ON uspSinhVienLopTinChi To ws;

-------------------------------------------------------------------------------------------
--Lớp tín chỉ trong kỳ
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopTinChiTrongKy' ) IS NOT NULL 
    DROP PROCEDURE uspLopTinChiTrongKy;
GO
CREATE PROC dbo.uspLopTinChiTrongKy
@Namhoc AS nvarchar(10),@Hocky AS int 
WITH ENCRYPTION
AS
Select RTRIM(L1.MaLop) LopMonHoc,RTRIM(L1.MaMonHoc) MaMonHoc,M.TenMonHoc,L1.NamHoc,L1.HocKy,L1.KhoiLuong KhoiLuong
From  LopTinChi L1 
INNER JOIN MonHoc M On L1.MaMonHoc=M.MaMonHoc 
Where L1.NamHoc=@Namhoc and L1.HocKy=@Hocky 
ORDER BY L1.MaLop
GO
GRANT EXECUTE ON uspLopTinChiTrongKy To ws;
-------------------------------------------------------------------------
--Update tên lớp tín chỉ
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopTinChi_SinhVien_DoiLop' ) IS NOT NULL 
    DROP PROCEDURE uspLopTinChi_SinhVien_DoiLop;
GO
CREATE PROCEDURE uspLopTinChi_SinhVien_DoiLop
	@MaLop NVARCHAR(20),
	@MaSinhVien NVARCHAR(12),
	@MaLopMoi NVARCHAR(20),
	@NamHoc NVARCHAR(9),
	@HocKy INT
	
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT OFF;
	UPDATE LopTinChi_SinhVien
	SET MaLop = @MaLopMoi
	WHERE NamHoc = @NamHoc AND HocKy = @HocKy
		AND Malop = @MaLop AND MaSinhVien = @MaSinhVien
	
END
GO
GRANT EXECUTE ON uspLopTinChi_SinhVien_DoiLop TO ws;
--------------------------------------------------------------------------
--Lớp tín chỉ sẽ được tách trong kỳ
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspLopTinChiTach' ) IS NOT NULL 
    DROP PROCEDURE uspLopTinChiTach;
GO
CREATE PROC dbo.uspLopTinChiTach
@Namhoc AS nvarchar(10),@Hocky AS int 
WITH ENCRYPTION
AS
select L.MaLop,L.MaMonHoc,L1.SoLopTach
From LopTinChi L
INNER JOIN (SELECT RTRIM(T.MaLop)+'-'+RTRIM(T.MaMonHoc) Malop,T.SoLopTach,T.NamHoc,T.HocKy
FROM TachLop T Where T.NamHoc=@Namhoc and T.HocKy=@Hocky) AS  
L1 ON RTRIM(L.Malop)=L1.Malop AND L.NamHoc=L1.NamHoc AND L.HocKy=L1.HocKy 
Where L.NamHoc=@Namhoc and L.HocKy=@Hocky and LEN(RTRIM(L.Malop))>=15
ORDER BY L1.MaLop
GO
GRANT EXECUTE ON uspLopTinChiTach To ws;

--------------------------------------------------------------------------
--Tìm kiếm môn học của sinh viên theo khung chương trình đào tạo
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHocTheoKhungChuongTrinh' ) IS NOT NULL 
    DROP PROCEDURE uspMonHocTheoKhungChuongTrinh;
GO
CREATE PROC uspMonHocTheoKhungChuongTrinh
@Masinhvien AS nvarchar(10), @mamon AS nvarchar(3),@stt int   
WITH ENCRYPTION
AS
SELECT   C.MaMonHoc
FROM         dbo.ChuongTrinhDaoTaoKhung C 
WHERE    LEFT(RTRIM(C.MaMonHoc),3)=@mamon AND RIGHT(RTRIM(C.MaMonHoc),1)=@stt AND C.MaKhoaHoc =(select MaKhoaHoc from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaHeDaoTao =(select MaHeDaoTao from SinhVien Where MaSinhVien=@Masinhvien) AND C.MaNganh =(select MaNganh from SinhVien Where MaSinhVien=@Masinhvien) 
GO
GRANT EXECUTE ON uspMonHocTheoKhungChuongTrinh To ws;
----------------------------------------------------

-------------------------------------------------------------------------
--Danh sách các môn học còn thiếu tiền
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHocConThieuTien' ) IS NOT NULL 
    DROP PROCEDURE uspMonHocConThieuTien;
GO
CREATE PROCEDURE uspMonHocConThieuTien
	@MaSinhVien NVARCHAR(12)	
	
WITH ENCRYPTION
AS
BEGIN
	select DISTINCT L.MaSinhVien,L.MaLop,L1.MaMonHoc,RTRIM(M.TenMonHoc) TenMonHoc,L1.KhoiLuong,L.NamHoc,L.HocKy,L.HocPhi,L.soTienDaNop
	From LopTinChi_SinhVien L
	INNER JOIN LopTinChi L1 ON L.NamHoc=L1.NamHoc AND L.HocKy=L1.HocKy AND L.MaLop=L1.MaLop
	INNER JOIN MonHoc M ON L1.MaMonHoc=M.MaMonHoc
	Where L.NamHoc = (Select MaNamhoc From HocKy Where HienTai=1)
          AND L.HocKy = (Select HocKy From HocKy Where HienTai=1)
	      AND L.MaSinhVien=@MaSinhVien 
	      AND L.soTienDaNop<L.HocPhi
	ORDER BY L1.MaMonHoc
	
END
GO
GRANT EXECUTE ON uspMonHocConThieuTien TO ws;
----------------------------------------------
--Danh sách các môn học học lại còn thiếu tiền
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHocLaiConThieuTien' ) IS NOT NULL 
    DROP PROCEDURE uspMonHocLaiConThieuTien;
GO
CREATE PROCEDURE uspMonHocLaiConThieuTien
	@MaSinhVien NVARCHAR(12)	
	
WITH ENCRYPTION
AS
BEGIN
	SELECT S.MaSinhVien,S.MaLopGhep,S.maMonHoc,RTRIM(M.TenMonHoc) TenMonHoc,S.NamHocLai,S.HocKyHocLai,S.HocPhiHocLai,S.HocPhiDaNop
	FROM SV_HocLai S
	INNER JOIN MonHoc M ON S.maMonHoc=M.MaMonHoc
	WHERE S.NamHocLai=(Select MaNamhoc From HocKy Where HienTai=1)
	AND S.HocKyHocLai=(Select HocKy From HocKy Where HienTai=1)
	AND S.HocPhiHocLai>S.HocPhiDaNop
	AND S.maSinhVien=@MaSinhVien 
	ORDER BY S.maMonHoc
END
GO
GRANT EXECUTE ON uspMonHocLaiConThieuTien TO ws;
--------------------------------------------------------------

--Danh sách các môn học bổ sung còn thiếu tiền
USE EduMngNew;
GO
IF OBJECT_ID ( 'uspMonHocBoSungConThieuTien' ) IS NOT NULL 
    DROP PROCEDURE uspMonHocBoSungConThieuTien;
GO
CREATE PROCEDURE uspMonHocBoSungConThieuTien
	@MaSinhVien NVARCHAR(12)	
	
WITH ENCRYPTION
AS
BEGIN
	SELECT S.MaSinhVien,S.MaLopGhep,S.maMonHoc,RTRIM(M.TenMonHoc) TenMonHoc,S.NamHoc,S.HocKy,S.HocPhi,S.HocPhiDaNop
	FROM SV_HocBoSung S
	INNER JOIN MonHoc M ON S.maMonHoc=M.MaMonHoc
	WHERE S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)
	AND S.HocKy=(Select HocKy From HocKy Where HienTai=1)
	AND S.HocPhi>S.HocPhiDaNop
	AND S.maSinhVien=@MaSinhVien 
	ORDER BY S.maMonHoc
END
GO
GRANT EXECUTE ON uspMonHocBoSungConThieuTien TO ws;
-----------------------------------------------
--Chi tiết thiếu tiền học lại kỳ phụ
USE EduMngNew;
GO
IF OBJECT_ID ('uspHocLaiKyPhuThieuTien') IS NOT NULL 
    DROP PROCEDURE uspHocLaiKyPhuThieuTien;
GO
CREATE PROCEDURE uspHocLaiKyPhuThieuTien
	@MaSinhVien NVARCHAR(12)	
	
WITH ENCRYPTION
AS
BEGIN
	SELECT A.maSinhVien,A.namHoc,A.hocKy,A.soTienQuyDinh,A.SoTienThayDoi,A.soTienMienGiam,A.SoTienKyTruocChuyenSang,A.SoTienDaThu,A.SoTienPhaiChi,A.SoTienDaChi,A.SoTienChuyenSangKySau,
	(A.soTienQuyDinh+A.SoTienDaChi+A.SoTienKyTruocChuyenSang+A.SoTienThayDoi)-(A.soTienMienGiam+A.SoTienDaThu) AS Thieu,B.ChiTietMonThieuTien
		FROM SV_CAC_KHOAN_PHAI_THU A
		INNER JOIN (
		SELECT maSinhVien,NamHocLai,HocKyHocLai,
		   STUFF((SELECT ' ;' + replace(replace(convert(varchar,convert(Money, S.HocPhiHocLai-S.HocPhiDaNop),1),'.00',''),',','.') + N'đ # ' + RTRIM(S.maMonHoc)+ ' # ' + RTRIM(M.TenMonHoc)
				  FROM SV_HocLai S
				  INNER JOIN MonHoc M ON S.maMonHoc=M.MaMonHoc 
				  WHERE S.NamHocLai=(Select MaNamhoc From HocKy Where HienTai=1)
				  and S.HocKyHocLai=3 
				  and S.maSinhVien=@MaSinhVien
				  AND S.HocPhiHocLai>S.HocPhiDaNop
				  FOR XML PATH('')), 1, 1, '') [ChiTietMonThieuTien]
		FROM SV_HocLai
		WHERE NamHocLai=(Select MaNamhoc From HocKy Where HienTai=1)
			 and HocKyHocLai=3 and maSinhVien=@MaSinhVien
		GROUP BY maSinhVien,NamHocLai,HocKyHocLai
	) AS B ON A.maSinhVien=B.maSinhVien AND A.namHoc=B.NamHocLai AND A.hocKy=B.HocKyHocLai AND A.maKhoanThu='HPHL'
	AND((A.soTienQuyDinh+A.SoTienDaChi+A.SoTienKyTruocChuyenSang+A.SoTienThayDoi)-(A.soTienMienGiam+A.SoTienDaThu)) >0  
END
GO
GRANT EXECUTE ON uspHocLaiKyPhuThieuTien TO ws;
----------------------------------------------------------------------
--Chi tiết thiếu tiền học bổ sung kỳ phụ
USE EduMngNew;
GO
IF OBJECT_ID ('uspHocBoSungKyPhuThieuTien') IS NOT NULL 
    DROP PROCEDURE uspHocBoSungKyPhuThieuTien;
GO
CREATE PROCEDURE uspHocBoSungKyPhuThieuTien
	@MaSinhVien NVARCHAR(12)	
	
WITH ENCRYPTION
AS
BEGIN
	SELECT A.maSinhVien,A.namHoc,A.hocKy,A.soTienQuyDinh,A.SoTienThayDoi,A.soTienMienGiam,A.SoTienKyTruocChuyenSang,A.SoTienDaThu,A.SoTienPhaiChi,A.SoTienDaChi,A.SoTienChuyenSangKySau,
	(A.soTienQuyDinh+A.SoTienDaChi+A.SoTienKyTruocChuyenSang+A.SoTienThayDoi)-(A.soTienMienGiam+A.SoTienDaThu) AS Thieu,B.ChiTietMonThieuTien
		FROM SV_CAC_KHOAN_PHAI_THU A
		INNER JOIN (
		SELECT maSinhVien,NamHoc,HocKy,
		   STUFF((SELECT ' ;' + replace(replace(convert(varchar,convert(Money, S.HocPhi-S.HocPhiDaNop),1),'.00',''),',','.') + N'đ # ' + RTRIM(S.maMonHoc)+ ' # ' + RTRIM(M.TenMonHoc)
				  FROM SV_HocBoSung S
				  INNER JOIN MonHoc M ON S.maMonHoc=M.MaMonHoc 
				  WHERE S.NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)
				  and S.HocKy=3 
				  and S.maSinhVien=@MaSinhVien
				  AND S.HocPhi>S.HocPhiDaNop
				  FOR XML PATH('')), 1, 1, '') [ChiTietMonThieuTien]
		FROM SV_HocBoSung
		WHERE NamHoc=(Select MaNamhoc From HocKy Where HienTai=1)
			 and HocKy=3 and maSinhVien=@MaSinhVien
		GROUP BY maSinhVien,NamHoc,HocKy
	) AS B ON A.maSinhVien=B.maSinhVien AND A.namHoc=B.NamHoc AND A.hocKy=B.HocKy AND A.maKhoanThu='HPHBS'
	AND((A.soTienQuyDinh+A.SoTienDaChi+A.SoTienKyTruocChuyenSang+A.SoTienThayDoi)-(A.soTienMienGiam+A.SoTienDaThu)) >0 
END
GO
GRANT EXECUTE ON uspHocBoSungKyPhuThieuTien TO ws;