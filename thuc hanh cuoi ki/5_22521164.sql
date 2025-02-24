CREATE DATABASE QLBH_22521164
USE QLHD_22521164
GO
SET DATEFORMAT dmy
--CAU 1
CREATE TABLE KhachHang
(
	MAKH CHAR(4) PRIMARY KEY, /* Ma khach hang dung de phan biet cac khach hang voi nhau */
	HOTEN VARCHAR(40), /* Ho ten cua moi khach hang */
	DCHI VARCHAR(50), /* Dia chi cua khach hang */
	SODT VARCHAR(20), /* So dien thoai cua khach hang */
	NGSINH SMALLDATETIME, /* Ngay thang nam sinh cua khach hang */
	DOANHSO MONEY, /* Doanh so cua nguoi nay da mua */
	NGDK SMALLDATETIME, /* Ngay dang ki lam khach hang */
	DIEMTHUONG MONEY /* Cho biet so diem thiem cua khach hang */
)

CREATE TABLE NhanVien
(
	MANV CHAR(4) PRIMARY KEY, /* Ma nhan vien dung de phan biet cac nhan vien voi nhau */
	HOTEN VARCHAR(40), /* Ho ten cua tung nhan vien */
	SODT VARCHAR(20), /* So dien thoai cua tung nhan dien */
	NGVL SMALLDATETIME /* Ngay vao lam cua moi nhan vien */
)

CREATE TABLE SanPham
(
	MASP CHAR(4) PRIMARY KEY,/* Ma san pham dung de phan biet cac san pham voi nhau */
	TENSP VARCHAR(40), /* Ten cua moi san pham */
	DVT VARCHAR(20), /* Cac don vi tinh cua moi san pham */
	NUOCSX VARCHAR(40), /* Nuoc san xuat ra san pham do */
	NHASX VARCHAR(40), /* Cho biet nha san xuat cua san pham */
	VAT MONEY, /*Cho biet thue cua san pham*/
	GIA MONEY /* Gia tien cua san pham */
)

CREATE TABLE HoaDon
(
	MAHD INT PRIMARY KEY, /* Ma hoa don dung de phan biet cac hoa don voi nhau */
	NGHD SMALLDATETIME, /* Ngay hoa don duoc tao */
	MAKH CHAR(4) FOREIGN KEY REFERENCES KhachHang(MAKH), /* Ma khach hang duoc lay tu bang KHACHHANG nham cho biet day la hoa don cua khach hang nao */
	MANV CHAR(4) FOREIGN KEY REFERENCES NhanVien(MANV), /* Ma nhan vien duoc lay tu bang NHANVIEN nham cho biet day la hoa don do nhan vien nao thanh toan */
	TRIGIA MONEY /* Cho biet tong gia tri cua cac san pham trong hoa don */
)

CREATE TABLE CTHoaDon
(
	MAHD INT FOREIGN KEY REFERENCES HoaDon(MAHD), /* Ma hoa don duoc lay tu bang HOADON nham cho biet san pham nay thuoc hoa don nao */
	MASP CHAR(4) FOREIGN KEY REFERENCES SanPham(MASP), /* Ma san pham duoc lay tu bang SANPHAM nham cho biet day la san pham gi */
	SL INT, /* Cho biet da mua so luong bao nhieu cua san pham nay trong hoa don */
	CONSTRAINT	PK_CTHoaDon PRIMARY KEY (MAHD,MASP)
)

--CAU 2: Gia ban cua cac san pham phai tu 1000 VND tro len
ALTER TABLE SanPham ADD CONSTRAINT CK_GIA_SAN_PHAM CHECK (GIA >= 1000 )

--CAU 3: Ngay mua hang cua mot khach hang thanh vien se lon hon hoac bang ngay khach hang do dang ki thanh vien 
/* 
BANG TAM ANH HUONG:
BANG	    |THEM|XOA|	SUA	   |
KhachHang	| -  | - | +(NGDK) |
HoaDon	    | +	 | - | +(NGHD) |
*/

--UPDATE KHACHHANG
CREATE TRIGGER CheckNgayMuaHangKH_Update
ON KhachHang
FOR UPDATE
AS
BEGIN
    DECLARE 
		@NGHD smalldatetime, 
		@NGDK smalldatetime;
    
	SELECT 
		@NGHD = HD.NGHD, 
		@NGDK = IST.NGDK
    
	FROM INSERTED IST, HoaDon HD
    
	WHERE IST.MAKH = HD.MAKH;
   
    IF (@NGHD < @NGDK)
    BEGIN
        ROLLBACK TRAN;
        RAISERROR('NGHD phai >= NGDK', 16, 1);
        RETURN;
    END
END;

--INSERT HOADON
CREATE TRIGGER CheckNgayMuaHang_Insert
ON HoaDon
FOR INSERT
AS
BEGIN
    DECLARE 
		@NGHD smalldatetime, 
		@NGDK smalldatetime;
    
	SELECT 
		@NGHD = IST.NGHD, 
		@NGDK = KH.NGDK
    
	FROM INSERTED IST, KhachHang KH
    
	WHERE IST.MAKH = KH.MAKH;
   
    IF (@NGHD < @NGDK)
    BEGIN
        ROLLBACK TRAN;
        RAISERROR('NGHD phai >= NGDK', 16, 1);
        RETURN;
    END
END;


--UPDATE HOADON
CREATE TRIGGER CheckNgayMuaHangHD_Update
ON HoaDon
FOR UPDATE
AS
BEGIN
    DECLARE 
		@NGHD smalldatetime, 
		@NGDK smalldatetime;
    
	SELECT 
		@NGHD = IST.NGHD, 
		@NGDK = KH.NGDK
    
	FROM INSERTED IST, KhachHang KH
    
	WHERE IST.MAKH = KH.MAKH;
   
    IF (@NGHD < @NGDK)
    BEGIN
        ROLLBACK TRAN;
        RAISERROR('NGHD phai >= NGDK', 16, 1);
        RETURN;
    END
END;

--THEM DU LIEU
INSERT INTO NhanVien(MANV,HOTEN,SODT,NGVL) VALUES ('NV01','NGUYEN NHU NHUT','0927345678','13/04/2006')
INSERT INTO NhanVien(MANV,HOTEN,SODT,NGVL) VALUES ('NV02','LE THI PHI YEN','0987567390','21/04/2006')
INSERT INTO NhanVien(MANV,HOTEN,SODT,NGVL) VALUES ('NV03','NGUYEN VAN B','0997047382','27/04/2006')
INSERT INTO NhanVien(MANV,HOTEN,SODT,NGVL) VALUES ('NV04','NGO THANH TUAN','0913758498','24/06/2006')
INSERT INTO NhanVien(MANV,HOTEN,SODT,NGVL) VALUES ('NV05','NGUYEN THI TRUC THANH','0918590387','20/07/2006')

INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH01','NGUYEN VAN A','731TRAN HUNG DAO,Q5,THHCM','08823451','22/10/1960','22/07/2006',13060000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH02','TRAN NGOC HAN','23/5NGUYEN TRAI,Q5,TPHCM','0908256478','03/04/1974','30/07/2006',280000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH03','TRAN NGOC LINH','45NGUYEN CANH CHAN,Q1,TPHCM','0938776266','10/06/1980','05/05/2006',3860000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH04','TRAN MINH LONG','50/34LE DAI HANH,Q10,TPHCM','0917325476','09/03/1965','02/10/2006',250000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH05','LE NHAT MINH','34TRUONG DINH,Q3,TPHCM','08246108','10/03/1950','28/10/2006',21000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH06','LE HOAI THUONG','227NGUYEN VAN CU,Q5,TPHCM','08631738','31/12/1981','24/11/2006',915000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH07','NGUYEN VAN TAM','32/3 TRAN BINH TRONG,Q5,TPHCM','0916783565','06/06/1971','01/12/2006',12500,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH08','PHAN THI THANH','45/2 AN DUONG VUONG,Q5,TPHCM','0938435756','10/01/1971','13/12/2006',365000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH09','LE HA VINH','837 LE HONG PHONG,Q5,TPHCM','08654763','03/03/1979','14/01/2007',70000,'0')
INSERT INTO KhachHang(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO,DIEMTHUONG) VALUES ('KH10','HA DUY LAP','34/34B NGUYEN TRAI,Q5,TPHCM','08768904','02/05/1983','16/01/2007',67500,'0')

INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BC01','BUT CHI','CAY','SINGAPORE','PENCIL',0.1,3000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BC02','BUT CHI','CAY','SINGAPORE','PENCIL',0.2,5000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BC03','BUT CHI','CAY','VIETNAM','KIM DONG',0.2,3500)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BC04','BUT CHI','HOP','VIETNAM','KIM DONG',0.2 ,30000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BB01','BUT BI','CAY','VIETNAM','TRANGGIAYTRANG',0.1,5000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BB02','BUT BI','CAY','TRUNGQUOC','NIHAO',0.2,7000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('BB03','BUT BI','HOP','THAILAN','SAWADIKHAP',0.1,100000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TV01','TAP 100 TRANG GIAY MONG','QUYEN','TRUNGQUOC','CHOTSO',0.15,2500)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TR01','BOT GIAT OMO','BICH','VIETNAM','OMO',0.2,20000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('AV01','KEO BICHBABON','CAY','VIETNAM','BICHBABON',0.1,3000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('AV02','KEO ALPHA','CAY','VIETNAM','ALPHALIBE',0.1,4500)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TT01','COI XAY GIO MO HINH','CAI','TRUNGQUOC','NIHAOS',0.15,200000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TT03','CAI SUNG MO HINH','CAI','VIETNAM','TROIOI',0.1,300000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('G01','GAO TAM','BICH','VIETNAM','DATVIET',0.2,75000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TP01','XOAI TU QUY','KG','VIETNAM','DATVIET',0.1,10700)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TV02','TAP 200 TRANG GIAY MONG','QUYEN','TRUNGQUOC','ALAHUA',0.2,4500)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TV03','TAP 100 TRANG GIAY TOT','QUYEN','VIETNAM','KIM DONG',0.2,3000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TV04','TAP 200 TRANG GIAY TOT','QUYEN','VIETNAM','CAYBUT',0.2,5500)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TV05','TAP 100 TRANG ','CHUC','VIETNAM','TRANGGIAYTRANG',0.2,23000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('TV06','TAP 200 TRANG ','CHUC','VIETNAM','OMO',0.2,53000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST01','SO TAY 500 TRANG','QUYEN','TRUNGQUOC','ALAHUA',0.2,40000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST02','SO TAY LOAI 1','QUYEN','VIETNAM','AMA',0.2,55000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST03','SO TAY LOAI 2','QUYEN','VIETNAM','EME',0.2,51000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST04','SO TAY','QUYEN','THAILAN','HIZ',0.2,55000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST05','SO TAY MONG','QUYEN','THAILAN','DAS',0.2,20000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST06','PHAN VIET BANG','HOP','VIETNAM','DACHAOTHAY',0.2,5000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST07','PHAN KHONG BUI','HOP','VIETNAM','MOTHAIBA',0.2,7000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST08','BONG BAMG','CAI','VIETNAM','CHAOEM',0.2,1000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST09','BUT LONG','CAY','VIETNAM','NAMNAM',0.2,5000)
INSERT INTO SanPham(MASP,TENSP,DVT,NUOCSX,NHASX,VAT,GIA) VALUES ('ST10','BUT LONG','CAY','TRUNGQUOC','ALAHUA',0.2,7000)

INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1001,'27/07/2022','KH01','NV01',320000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1002,'10/08/2022','KH01','NV05',840000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1003,'23/08/2022','KH02','NV01',100000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1004,'01/09/2022','KH02','NV01',180000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1005,'20/10/2022','KH01','NV02',3800000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1006,'16/10/2022','KH01','NV03',2430000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1007,'28/10/2022','KH03','NV03',510000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1008,'28/10/2022','KH01','NV03',440000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1009,'28/10/2022','KH03','NV04',200000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1010,'01/11/2022','KH01','NV01',5200000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1011,'04/11/2022','KH04','NV04',250000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1012,'30/11/2022','KH05','NV03',21000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1013,'12/12/2022','KH06','NV01',5000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1014,'31/12/2023','KH03','NV02',3150000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1015,'01/01/2023','KH06','NV01',910000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1016,'01/01/2023','KH07','NV02',12500)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1017,'02/01/2023','KH08','NV03',35000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1018,'13/01/2023','KH08','NV02',330000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1019,'13/01/2023','KH01','NV03',30000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1020,'14/01/2023','KH09','NV04',70000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1021,'16/01/2023','KH10','NV01',67500)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1022,'16/01/2023',NULL,'NV01',7000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1023,'17/01/2023',NULL,'NV01',330000)
INSERT INTO HoaDon(MAHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1024,'17/01/2023',NULL,'NV03',330000)

INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1001,'TV02',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1001,'ST01',5)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1001,'BC01',5)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1001,'BC02',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1001,'ST08',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1002,'TR01',20)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1002,'BB01',20)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1002,'BB02',20)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1003,'BB03',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1004,'TV01',20)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1004,'TV02',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1004,'TV03',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1004,'TV04',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1005,'TV05',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1005,'TV06',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1006,'TV06',20)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1006,'ST01',30)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1006,'ST02',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1007,'ST03',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1008,'TR01',8)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1009,'ST05',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1010,'TV06',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1010,'ST07',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1010,'ST08',100)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1010,'ST04',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1010,'TV03',100)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1011,'ST06',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1012,'ST07',3)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1013,'ST08',5)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1014,'BC02',80)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1014,'BB02',100)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1014,'BC04',60)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1014,'BB01',50)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1015,'BB02',30)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1015,'BB03',7)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1016,'TV01',5)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1017,'TV02',1)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1017,'TV03',1)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1017,'TV04',5)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1018,'ST04',6)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1019,'TR01',1)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1019,'ST06',2)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1020,'TV06',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1021,'ST08',5)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1021,'TV01',7)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1021,'TV02',10)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1022,'ST07',1)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1023,'ST04',6)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1024,'TR01',15)
INSERT INTO CTHoaDon(MAHD,MASP,SL) VALUES (1024,'TV06',20)

--CAU 4
SELECT KH.MAKH,KH.HOTEN
FROM KhachHang KH
JOIN HoaDon HD ON KH.MAKH = HD.MAKH
JOIN CTHoaDon CT ON CT.MAHD = HD.MAHD
JOIN SanPham SP ON SP.MASP = CT.MASP
WHERE SP.TENSP LIKE 'C%' OR SP.TENSP ='%KEO%'

--Cau 5
SELECT TOP 10 WITH TIES SP.MASP, SP.TENSP, SUM(CTHD.SL) AS TONGSOLUONG
FROM SanPham AS SP
JOIN CTHoaDon AS CTHD
ON SP.MASP = CTHD.MASP
JOIN HoaDon AS HD
ON HD.MAHD = CTHD.MAHD
WHERE YEAR(HD.NGHD) = 2023
GROUP BY SP.MASP, SP.TENSP
ORDER BY SUM(CTHD.SL) DESC;


--Cau 6
SELECT TOP 1 WITH TIES SUM(CTHD.SL * SP.GIA) AS TONGTIENMUA
FROM CTHoaDon AS CTHD
JOIN HoaDon AS HD
ON CTHD.MAHD = HD.MAHD
JOIN KhachHang AS KH
ON KH.MAKH = HD.MAKH
JOIN SanPham AS SP
ON CTHD.MASP = SP.MASP
WHERE YEAR(HD.NGHD) = 2023 
GROUP BY KH.MAKH
ORDER BY SUM(CTHD.SL * SP.GIA) DESC;

--CAU 7
-- CAU A: T? 1 tri?u � 20 tri?u m?i tri?u s? ???c 100 ?i?m.
UPDATE KhachHang
SET DIEMTHUONG =
    CASE  
        WHEN DOANHSO BETWEEN 1000000 AND 20000000 THEN (DOANHSO/1000000) * 100
		ELSE 0
    END;

-- CAU B: Tr�n 20 tri?u th� m?i tri?u s? ???c 110 ?i?m
UPDATE KHACHHANG
SET DIEMTHUONG = 
    CASE
        WHEN DOANHSO > 20000000 THEN (DOANHSO/ 1000000) * 110
    END;


--CAU 8
SELECT TOP 3 WITH TIES MAKH, HOTEN, DIEMTHUONG
FROM KHACHHANG
ORDER BY DIEMTHUONG DESC;

--CAU 9
SELECT KH.MAKH, KH.HOTEN
FROM KhachHang AS KH
JOIN HoaDon AS HD
ON KH.MAKH = HD.MAKH
WHERE NOT EXISTS (
	SELECT *
	FROM SanPham AS SP
	WHERE NOT EXISTS (
		SELECT *
		FROM CTHoaDon AS CTHD
		WHERE CTHD.MASP = SP.MASP AND CTHD.MAHD = HD.MAHD AND SP.TENSP = 'OMO'
)
)
