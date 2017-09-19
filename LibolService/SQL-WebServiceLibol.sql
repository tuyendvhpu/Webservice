
-- Ban doc muon sach qua han
USE LIBOL60; 
GO 
IF OBJECT_ID ( 'uspBanDocMuonQuaHan' ) IS NOT NULL 
    DROP PROCEDURE uspBanDocMuonQuaHan; 
GO 
CREATE PROC uspBanDocMuonQuaHan
@Code AS nvarchar(10) 
WITH ENCRYPTION 
AS
SELECT      dbo.CIR_PATRON.Code MaBanDoc, dbo.CIR_LOAN.DueDate NgayPhaiTra, 
                      dbo.CIR_LOAN.CheckOutDate NgayMuonSach, dbo.CIR_LOAN.CopyNumber MaAnPham,LTRIM(REPLACE(LEFT(RTRIM(dbo.FIELD200S.[Content]),CHARINDEX('/',dbo.FIELD200S.[Content])),'$a','')) AS TenAnPham, CASE WHEN GETDATE()> dbo.CIR_LOAN.DueDate THEN DATEDIFF ( day,dbo.CIR_LOAN.DueDate,GETDATE()) ELSE 0 END SoNgayQuaHan
FROM         dbo.CIR_LOAN INNER JOIN
                      dbo.CIR_PATRON ON dbo.CIR_LOAN.PatronID = dbo.CIR_PATRON.ID LEFT OUTER JOIN
                      dbo.FIELD200S ON dbo.CIR_LOAN.ItemID = dbo.FIELD200S.ItemID
  Where dbo.FIELD200S.FieldCode ='245' and dbo.CIR_PATRON.Code=@Code 
  ORDER BY dbo.CIR_LOAN.CheckOutDate
GO 

-- Loc danh sach ban doc sap den han tra sach

DECLARE @SoNgay AS int  
Set @SoNgay=30
Select *
FROM (
SELECT      dbo.CIR_PATRON.Code MaBanDoc,RTRIM(dbo.CIR_PATRON.FirstName)+ ' ' + RTRIM(dbo.CIR_PATRON.MiddleName)+' ' + RTRIM(dbo.CIR_PATRON.LastName) Name,CIR_PATRON_GROUP.Name DoiTuong, dbo.CIR_LOAN.DueDate NgayPhaiTra, 
            dbo.CIR_LOAN.CheckOutDate NgayMuonSach, dbo.CIR_LOAN.CopyNumber MaAnPham,RTRIM(dbo.FIELD200S.[Content]) TenSach,DATEDIFF ( day,GETDATE(),dbo.CIR_LOAN.DueDate)AS SoNgayDenHanTra
            ,CASE WHEN GETDATE()> dbo.CIR_LOAN.DueDate THEN DATEDIFF ( day,dbo.CIR_LOAN.DueDate,GETDATE()) ELSE 0 END SoNgayQuaHan ,CIR_PATRON.Note
           
FROM         dbo.CIR_LOAN INNER JOIN
                      dbo.CIR_PATRON ON dbo.CIR_LOAN.PatronID = dbo.CIR_PATRON.ID LEFT OUTER JOIN
                      dbo.FIELD200S ON dbo.CIR_LOAN.ItemID = dbo.FIELD200S.ItemID
 INNER JOIN CIR_PATRON_GROUP ON CIR_PATRON.PatronGroupID=CIR_PATRON_GROUP.ID                     
Where dbo.FIELD200S.FieldCode ='245'and DATEDIFF ( day,GETDATE(),dbo.CIR_LOAN.DueDate)<=@SoNgay
) S
ORDER BY S.SoNgayDenHanTra DESC
------------------------------------------------------------


           