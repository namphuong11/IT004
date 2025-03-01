CREATE DATABASE QUAN_LY_CUA_HANG;
USE QUAN_LY_CUA_HANG;


DELETE FROM SANPHAM
DROP TABLE SANPHAM

-- Tuần 1:
-- I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language)
-- CAU 1:
CREATE TABLE KhachHang
(
	MAKH CHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(40),
	DCHI VARCHAR(50),
	SODT VARCHAR(20),
	NGSINH SMALLDATETIME,
	DOANHSO MONEY,
	NGDK SMALLDATETIME,
);

CREATE TABLE NhanVien
(
	MANV CHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(40),
	SODT VARCHAR(20),
	NGVL SMALLDATETIME,
);

CREATE TABLE SanPham
(
	MASP CHAR(4) PRIMARY KEY,
	TENSP VARCHAR(40),
	DVT VARCHAR(20),
	NUOCSX VARCHAR(40),
	GIA MONEY,
);

CREATE TABLE HoaDon
(
	SOHD INT PRIMARY KEY,
	NGHD SMALLDATETIME,
	MAKH CHAR(4) FOREIGN KEY REFERENCES KhachHang(MAKH),
	MANV CHAR(4) FOREIGN KEY REFERENCES NhanVien(MANV),
	TRIGIA MONEY,
);

CREATE TABLE CTHoaDon
(
	SOHD INT FOREIGN KEY REFERENCES HoaDon(SOHD),
	MASP CHAR(4) FOREIGN KEY REFERENCES SanPham(MASP),
	SL INT,
	CONSTRAINT PK_CTHoaDon PRIMARY KEY (SOHD, MASP),
);

--CAU 2:
ALTER TABLE SanPham ADD GHICHU VARCHAR(20);

--CAU 3:
ALTER TABLE KhachHang ADD LOAIKH TINYINT;

--CAU 4:
ALTER TABLE SanPham
ALTER COLUMN GHICHU VARCHAR(100);

--CAU 5:
ALTER TABLE SanPham DROP COLUMN GHICHU;

--CAU 6:
ALTER TABLE KhachHang
ALTER COLUMN LOAIKH VARCHAR(100);

--CAU 7:
ALTER TABLE SanPham
ADD CONSTRAINT CK_DVT CHECK (DVT IN ('cay', 'cai', 'hop', 'quyen', 'chuc'));

--CAU 8:
ALTER TABLE SanPham
ADD CONSTRAINT CK_GIA CHECK (GIA >= 500);

--CAU 9:

--CAU 10:
ALTER TABLE KhachHang
ADD CONSTRAINT CK_NGAY CHECK (NGDK > NGSINH);

-- Tuần 2:
-- II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language)
-- CAU 1:
-- Tasks -> Import Data
SELECT * FROM SanPham
SELECT * FROM NhanVien
SELECT * FROM KhachHang
SELECT * FROM HoaDon
SELECT * FROM CTHoaDon


-- CAU 2:
SELECT * INTO SanPham1 FROM SanPham;
SELECT * INTO KhachHang1 FROM KhachHang;
SELECT * FROM KhachHang1
SELECT * FROM SanPham1
-- CAU 3:
UPDATE SanPham1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'Thai Lan';

-- CAU 4:
UPDATE SanPham1
SET GIA = GIA * 0.95
WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000;

--CAU 5:
SET DATEFORMAT DMY
UPDATE KhachHang1
SET LOAIKH = 'Vip'
WHERE	((NGDK < '1-1-2007' AND DOANHSO >= 10000000) 
		OR
		(NGDK >= '1-1-2007' AND DOANHSO >= 2000000));

-- III. Ngôn ngữ truy vấn dữ liệu:
-- CAU 1:
SELECT MASP, TENSP
FROM SanPham
WHERE NUOCSX = 'Trung Quoc';

-- CAU 2:
SELECT MASP, TENSP
FROM SanPham
WHERE DVT = 'cay' OR DVT = 'quyen';

-- CAU 3:
SELECT MASP, TENSP
FROM SanPham
WHERE MASP LIKE 'B%1';

-- CAU 4:
SELECT MASP, TENSP
FROM SanPham
WHERE NUOCSX = 'Trung Quoc' AND GIA BETWEEN 30000 AND 40000;

-- CAU 5:
SELECT MASP, TENSP, NUOCSX, GIA
FROM SanPham1
WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND GIA BETWEEN 30000 AND 40000;

-- CAU 6:
SELECT SOHD, TRIGIA
FROM HoaDon
WHERE NGHD = '1-1-2007' OR  NGHD = '2-1-2007';

-- CAU 7: 
SELECT SOHD, TRIGIA, NGHD
FROM HoaDon
WHERE NGHD BETWEEN '1-1-2007' AND '31-1-2007'
ORDER BY NGHD ASC, TRIGIA DESC;

-- CAU 8:
SELECT KH.MAKH, KH.HOTEN
FROM KhachHang AS KH
JOIN HoaDon AS HD 
ON KH.MAKH = HD.MAKH
WHERE NGHD = '1-1-2007';

-- CAU 9:
SELECT SOHD, TRIGIA
FROM HoaDon
WHERE MANV IN 
(
    SELECT MANV
    FROM NhanVien
    WHERE HOTEN = 'Nguyen Van B'
)
AND NGHD = '2006-10-28';

-- CAU 10:
SELECT SanPham.MASP, SanPham.TENSP
FROM SanPham 
JOIN CTHoaDon ON CTHoaDon.MASP = SanPham.MASP
JOIN HoaDon ON HoaDon.SOHD = CTHoaDon.SOHD
JOIN KhachHang ON KhachHang.MAKH = HoaDon.MAKH
WHERE KhachHang.HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006

-- CAU 11:
SELECT DISTINCT CTHoaDon.SOHD
FROM CTHoaDon
JOIN SanPham ON CTHoaDon.MASP = SanPham.MASP
WHERE SanPham.MASP IN ('BB01', 'BB02')

-- CAU 12:
SELECT CTHoaDon.SOHD
FROM CTHoaDon
JOIN SanPham ON CTHoaDon.MASP = SanPham.MASP
WHERE SanPham.MASP IN ('BB01', 'BB02') AND CTHoaDon.SL BETWEEN 10 AND 20

-- CAU 13:
SELECT DISTINCT CTHoaDon.SOHD
FROM CTHoaDon
WHERE CTHoaDon.MASP IN ('BB01', 'BB02')AND CTHoaDon.SL BETWEEN 10 AND 20
GROUP BY CTHoaDon.SOHD
HAVING COUNT(DISTINCT CTHoaDon.MASP) = 2;


-- CAU 14:
SELECT *
FROM SanPham
JOIN CTHoaDon ON CTHoaDon.MASP = SanPham.MASP
JOIN HoaDon ON HoaDon.SOHD = CTHoaDon.SOHD
WHERE SanPham.NUOCSX = 'Trung Quoc' OR NGHD = '1-1-2007'

-- CAU 15:
SELECT SanPham.MASP, SanPham.TENSP
FROM SanPham
LEFT JOIN CTHoaDon ON CTHoaDon.MASP = SanPham.MASP
WHERE CTHoaDon.MASP IS NULL

-- CAU 16:
SELECT SanPham.MASP, SanPham.TENSP
FROM SanPham
LEFT JOIN CTHoaDon ON CTHoaDon.MASP = SanPham.MASP
JOIN HoaDon ON HoaDon.SOHD = CTHoaDon.SOHD
WHERE CTHoaDon.MASP IS NULL AND YEAR(NGHD) = 2006

-- CAU 17:
SELECT SanPham.MASP, SanPham.TENSP
FROM SanPham
LEFT JOIN CTHoaDon ON CTHoaDon.MASP = SanPham.MASP
JOIN HoaDon ON HoaDon.SOHD = CTHoaDon.SOHD
WHERE CTHoaDon.MASP IS NULL AND YEAR(HoaDon.NGHD) = 2006 AND SanPham.NUOCSX = 'Trung Quoc'

-- CAU 18:
SELECT SOHD
FROM HoaDon HD1
WHERE NOT EXISTS 
(
	SELECT *
	FROM SanPham
    WHERE SanPham.NUOCSX = 'Singapore' AND NOT EXISTS 
	(
		SELECT *
		FROM CTHoaDon HD2
		WHERE HD2.MASP = SanPham.MASP 
			AND HD2.SOHD = HD1.SOHD
	)
);


-- CAU 19:
SELECT SOHD
FROM HoaDon HD1
WHERE YEAR(NGHD) = 2006 AND NOT EXISTS 
(
	SELECT *
	FROM SanPham
    WHERE SanPham.NUOCSX = 'Singapore' AND NOT EXISTS 
	(
		SELECT *
		FROM CTHoaDon HD2
		WHERE HD2.MASP = SanPham.MASP 
			AND HD2.SOHD = HD1.SOHD
	)
);


-- CAU 20:
SELECT COUNT(*) AS KH_KhongPhaiThanhVien
FROM HoaDon
WHERE MAKH IS NULL;

-- CAU 21:
SELECT COUNT(DISTINCT MASP) AS SP_KHACNHAU
FROM CTHoaDon
JOIN HoaDon ON HoaDon.SOHD = CTHoaDon.SOHD
WHERE YEAR(NGHD) = 2006

-- CAU 22:
SELECT MAX(TRIGIA) AS MaxValue, MIN(TRIGIA) AS MinValue
FROM HoaDon;

-- CAU 23:
SELECT AVG(TRIGIA) AS TRIGIA_TRUNGBINH
FROM HoaDon
WHERE YEAR(NGHD) = 2006

-- CAU 24:
SELECT SUM(TRIGIA) AS DOANH_THU
FROM HoaDon
WHERE YEAR(NGHD) = 2006

-- CAU 25:
SELECT TOP 1 SOHD
FROM HoaDon
WHERE YEAR(NGHD) = 2006
ORDER BY TRIGIA DESC







