-- tạo database QLBH
CREATE DATABASE QLBH_21522924
USE QLBH_21522924;
GO
-- tạo các quan hệ
-- tạo bảng quan hệ khách hàng
CREATE TABLE KHACHHANG (
    MAKH CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    DCHI VARCHAR(50),
    SODT VARCHAR(20),
    NGSINH smalldatetime,
    DOANHSO money,
    NGDK smalldatetime
);
-- tạo bảng quan hệ nhân viên
CREATE TABLE NHANVIEN (
	MANV CHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(40),
	SODT VARCHAR(20),
	NGVL smalldatetime
);
-- tạo bảng quan hệ sản phẩm
CREATE TABLE SANPHAM (
	MASP CHAR(4) PRIMARY KEY,
	TENSP VARCHAR(40),
	DVT VARCHAR(20),
	NUOCSX VARCHAR(20),
	GIA money
);
-- tạo bảng quan hệ hóa đơn
CREATE TABLE HOADON (
	SOHD INT PRIMARY KEY,
	NGHD smalldatetime,
	MAKH CHAR(4), 
	MANV CHAR(4),
	TRIGIA money
);
-- tạo bảng chi tiết đơn hàng
CREATE TABLE CTHD (
    SOHD INT,
    MASP CHAR(4),
    SL INT,
    PRIMARY KEY (SOHD, MASP),
    FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),  -- Đảm bảo SOHD là khóa ngoại tham chiếu đến bảng HOADON
    FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)  -- Đảm bảo MASP là khóa ngoại tham chiếu đến bảng SANPHAM
);
-- Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
ALTER TABLE SANPHAM
ADD GHICHU VARCHAR(20);
-- Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG
ADD LOAIKH tinyint;
--Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100);
--Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM
DROP COLUMN GHICHU;
--Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM
ADD CONSTRAINT CHK_DVT CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'));
-- Tạo ràng buộc CHECK cho cột GIA >500
ALTER TABLE SANPHAM
ADD CONSTRAINT CHK_GIA CHECK (GIA >= 500);
-- Tạo ràng buộc CHECK ngày đăng kí lớn hơn ngày sinh
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHK_NGAY_DANG_KY CHECK (NGDK > NGSINH);
/*. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang
lai”, “Thuong xuyen”, “Vip”, … */
ALTER TABLE KHACHHANG
ALTER COLUMN LOAIKH VARCHAR(20); 


