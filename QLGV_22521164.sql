CREATE DATABASE QLGV_22521164
USE QLGV_22521164
SET DATEFORMAT DMY
-- I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):
-- 1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính  GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
CREATE TABLE KHOA 
(
	MAKHOA VARCHAR(4) PRIMARY KEY,
	TENKHOA VARCHAR(40),
	NGTLAP  SMALLDATETIME,
	TRGKHOA  CHAR(4),
)

CREATE TABLE MONHOC
(
	MAMH VARCHAR(10) PRIMARY KEY,
	TENMH VARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4) FOREIGN KEY REFERENCES KHOA(MAKHOA)
)

CREATE TABLE DIEUKIEN 
(
    MAMH VARCHAR(10) FOREIGN KEY REFERENCES MONHOC(MAMH),
    MAMH_TRUOC VARCHAR(10)FOREIGN KEY REFERENCES MONHOC(MAMH),
    PRIMARY KEY (MAMH, MAMH_TRUOC),
);

CREATE TABLE GIAOVIEN 
(
    MAGV CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    HOCVI VARCHAR(10),
    HOCHAM VARCHAR(10),
    GIOITINH VARCHAR(3),
    NGSINH SMALLDATETIME,
    NGVL SMALLDATETIME,
    HESO NUMERIC(4,2),
    MUCLUONG MONEY,
    MAKHOA VARCHAR(4),
);
ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_KHOA
FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_GIAOVIEN
FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)

CREATE TABLE LOP (
    MALOP CHAR(3) PRIMARY KEY,
    TENLOP VARCHAR(40),
    TRGLOP CHAR(5),
    SISO TINYINT,
    MAGVCN CHAR(4),
);


CREATE TABLE HOCVIEN 
(
    MAHV CHAR(5) PRIMARY KEY,
    HO VARCHAR(40),
    TEN VARCHAR(10),
    NGSINH SMALLDATETIME,
    GIOITINH VARCHAR(3),
    NOISINH VARCHAR(40),
    MALOP CHAR(3),
);

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_HOCVIEN
FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV);

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_GIAOVIEN
FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE HOCVIEN
ADD CONSTRAINT FK_HOCVIEN_LOP
FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)


CREATE TABLE GIANGDAY 
(
    MALOP CHAR(3),
    MAMH VARCHAR(10),
    MAGV CHAR(4),
    HOCKY TINYINT,
    NAM SMALLINT,
    TUNGAY SMALLDATETIME,
    DENNGAY SMALLDATETIME,
    PRIMARY KEY (MALOP, MAMH),
    FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
);

CREATE TABLE KETQUATHI 
(
    MAHV CHAR(5),
    MAMH VARCHAR(10),
    LANTHI TINYINT,
    NGTHI SMALLDATETIME,
    DIEM NUMERIC(4,2),
    KQUA VARCHAR(10),
    PRIMARY KEY (MAHV, MAMH, LANTHI),
    FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);

ALTER TABLE HOCVIEN
ADD GHICHU NVARCHAR(255),
    DIEMTB FLOAT,
    XEPLOAI NVARCHAR(20);

-- Them du lieu:
ALTER TABLE LOP NOCHECK CONSTRAINT FK_LOP_HOCVIEN;
ALTER TABLE HOCVIEN NOCHECK CONSTRAINT FK_HOCVIEN_LOP;
ALTER TABLE KHOA NOCHECK CONSTRAINT FK_KHOA_GIAOVIEN;
ALTER TABLE GIAOVIEN NOCHECK CONSTRAINT FK_GIAOVIEN_KHOA;


INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP, TRGKHOA)
VALUES
	('KHMT', 'Khoa hoc may tinh', '7/6/2005', 'GV01'),
	('HTTT', 'He thong thong tin', '7/6/2005', 'GV02'),
	('CNPM', 'Cong nghe phan mem', '7/6/2005', 'GV04'),
	('MTT', 'Mang va truyen thong', '20/10/2005', 'GV03'),
	('KTMT', 'Ky thuat may tinh', '20/12/2005', 'Null')

INSERT INTO MONHOC(MAMH, TENMH, TCLT, TCTH, MAKHOA)
VALUES
	('THDC', 'Tin hoc dai cuong', '4', '1', 'KHMT'),
	('CTRR', 'Cau truc roi rac', '5', '0', 'KHMT'),
	('CSDL', 'Co so du lieu', '3', '1', 'HTTT'),
	('CTDLGT', 'Cau truc du lieu va giai thuat', '3', '1', 'KHMT'),
	('PTTKTT', 'Phan tich thiet ke thuat toan', '3', '0', 'KHMT'),
	('DHMT', 'Do hoa may tinh', '3', '1', 'KHMT'),
	('KTMT', 'Kien truc may tinh', '3', '0', 'KTMT'),
	('TKCSDL', 'Thiet ke co so du lieu', '3', '1', 'HTTT'),
	('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', '4', '1', 'HTTT'),
	('HDH', 'He dieu hanh', '4', '0', 'KTMT'),
	('NMCNPM', 'Nhap mon cong nghe phan mem', '3', '0', 'CNPM'),
	('LTCFW', 'Lap trinh C for win', '3', '1', 'CNPM'),
	('LTHDT', 'Lap trinh huong doi tuong', '3', '1', 'CNPM')


INSERT INTO DIEUKIEN(MAMH, MAMH_TRUOC)
VALUES
	('CSDL', 'CTRR'),
	('CSDL', 'CTDLGT'),
	('CTDLGT', 'THDC'),
	('PTTKTT', 'THDC'),
	('PTTKTT', 'CTDLGT'),
	('DHMT', 'THDC'),
	('LTHDT', 'THDC'),
	('PTTKHTTT', 'CSDL')



INSERT INTO GIAOVIEN(MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA)
VALUES
	('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '02/05/1950', '11/01/2004', '5', '2250000', 'KHMT'),
	('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '17/12/1965', '20/04/2004', '4.5', '2025000', 'HTTT'),
	('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '01/08/1950', '23/09/2004', '4', '1800000', 'CNPM'),
	('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '22/02/1961', '12/01/2005', '4.5', '2025000', 'KTMT'),
	('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '12/03/1958', '12/01/2005', '3', '1350000', 'HTTT'),
	('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '11/03/1953', '12/01/2005', '4.5', '2025000', 'KHMT'),
	('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '23/11/1971', '01/03/2005', '4', '1800000', 'KHMT'),
	('GV08', 'Le Thi Tran', 'KS', 'Null', 'Nu', '26/03/1974', '01/03/2005', '1.69', '760500', 'KHMT'),
	('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '31/12/1966', '01/03/2005', '4', '1800000', 'HTTT'),
	('GV10', 'Le Tran Anh Loan', 'KS', 'Null', 'Nu', '17/07/1972', '01/03/2005', '1.86', '837000', 'CNPM'),
	('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '12/01/1980', '15/05/2005', '2.67', '1201500', 'MTT'),
	('GV12', 'Tran Van Anh', 'CN', 'Null', 'Nu', '29/03/1981', '15/05/2005', '1.69', '760500', 'CNPM'),
	('GV13', 'Nguyen Linh Dan', 'CN', 'Null', 'Nu', '23/05/1980', '15/05/2005', '1.69', '760500', 'KTMT'),
	('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '30/11/1976', '15/05/2005', '3', '1350000', 'MTT'),
	('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '04/05/1978', '15/05/2005', '3', '1350000', 'KHMT')


INSERT INTO LOP(MALOP, TENLOP, TRGLOP, SISO, MAGVCN)
VALUES
	('K11', 'Lop 1 khoa 1','K1108','11','GV07'),
	('K12', 'Lop 2 khoa 1','K1205','12','GV09'),
	('K13', 'Lop 3 khoa 1','K1305','12','GV14')

INSERT INTO HOCVIEN(MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES
	('K1101', 'Nguyen Van', 'A', '27/01/1986', 'Nam', 'TpHCM', 'K11'),
	('K1102', 'Tran Ngoc', 'Han', '14/03/1986', 'Nu', 'Kien Giang', 'K11'),
	('K1103', 'Ha Duy', 'Lap', '18/04/1986', 'Nam', 'Nghe An', 'K11'),
	('K1104', 'Tran Ngoc', 'Linh', '30/03/1986', 'Nu', 'Tay Ninh', 'K11'),
	('K1105', 'Tran Minh', 'Long', '27/02/1986', 'Nam', 'TpHCM', 'K11'),
	('K1106', 'Le Nhat', 'Minh', '24/01/1986', 'Nam', 'TpHCM', 'K11'),
	('K1107', 'Nguyen Nhu', 'Nhut', '27/01/1986', 'Nam', 'Ha Noi', 'K11'),
	('K1108', 'Nguyen Manh', 'Tam', '27/02/1986', 'Nam', 'Kien Giang', 'K11'),
	('K1109', 'Phan Thi Thanh', 'Tam', '27/01/1986', 'Nu', 'Vinh Long', 'K11'),
	('K1110', 'Le Hoai', 'Thuong', '05/02/1986', 'Nu', 'Can Tho', 'K11'),
	('K1111', 'Le Ha', 'Vinh', '25/12/1986', 'Nam', 'Vinh Long', 'K11'),
	('K1201', 'Nguyen Van', 'B', '11/02/1986', 'Nam', 'TpHCM', 'K12'),
	('K1202', 'Nguyen Thi Kim', 'Duyen', '18/01/1986', 'Nu', 'TpHCM', 'K12'),
	('K1203', 'Tran Thi Kim', 'Duyen', '17/09/1986', 'Nu', 'TpHCM', 'K12'),
	('K1204', 'Truong My', 'Hanh', '19/05/1986', 'Nu', 'Dong Nai', 'K12'),
	('K1205', 'Nguyen Thanh', 'Nam', '17/04/1986', 'Nam', 'TpHCM', 'K12'),
	('K1206', 'Nguyen Thi Truc', 'Thanh', '04/03/1986', 'Nu', 'Kien Giang', 'K12'),
	('K1207', 'Tran Thi Bich', 'Thuy', '08/02/1986', 'Nu', 'Nghe An', 'K12'),
	('K1208', 'Huynh Thi Kim', 'Trieu', '08/04/1986', 'Nu', 'Tay Ninh', 'K12'),
	('K1209', 'Pham Thanh', 'Trieu', '23/02/1986', 'Nam', 'TpHCM', 'K12'),
	('K1210', 'Ngo Thanh', 'Tuan', '14/02/1986', 'Nam', 'TpHCM', 'K12'),
	('K1211', 'Do Thi', 'Xuan', '09/03/1986', 'Nu', 'Ha Noi', 'K12'),
	('K1212', 'Le Thi Phi', 'Yen', '12/03/1986', 'Nu', 'TpHCM', 'K12'),
	('K1301', 'Nguyen Thi Kim', 'Cuc', '09/06/1986', 'Nu', 'Kien Giang', 'K13'),
	('K1302', 'Truong Thi My', 'Hien', '18/03/1986', 'Nu', 'Nghe An', 'K13'),
	('K1303', 'Le Duc', 'Hien', '21/03/1986', 'Nam', 'Tay Ninh', 'K13'),
	('K1304', 'Le Quang', 'Hien', '18/04/1986', 'Nam', 'TpHCM', 'K13'),
	('K1305', 'Le Thi', 'Huong', '27/03/1986', 'Nu', 'TpHCM', 'K13'),
	('K1306', 'Nguyen Thai', 'Huu', '30/03/1986', 'Nam', 'Ha Noi', 'K13'),
	('K1307', 'Tran Minh', 'Man', '28/05/1986', 'Nam', 'TpHCM', 'K13'),
	('K1308', 'Nguyen Hieu', 'Nghia', '08/04/1986', 'Nam', 'Kien Giang', 'K13'),
	('K1309', 'Nguyen Trung', 'Nghia', '18/01/1987', 'Nam', 'Nghe An', 'K13'),
	('K1310', 'Tran Thi Hong', 'Tham', '22/04/1986', 'Nu', 'Tay Ninh', 'K13'),
	('K1311', 'Tran Minh', 'Thuc', '04/04/1986', 'Nam', 'TpHCM', 'K13'),
	('K1312', 'Nguyen Thi Kim', 'Yen', '07/09/1986', 'Nu', 'TpHCM', 'K13')

INSERT INTO GIANGDAY(MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY)
VALUES
	('K11','THDC','GV07','1','2006','2/1/2006','12/5/2006'),
	('K12','THDC','GV06','1','2006','2/1/2006','12/5/2006'),
	('K13','THDC','GV15','1','2006','2/1/2006','12/5/2006'),
	('K11','CTRR','GV02','1','2006','9/1/2006','17/5/2006'),
	('K12','CTRR','GV02','1','2006','9/1/2006','17/5/2006'),
	('K13','CTRR','GV08','1','2006','9/1/2006','17/5/2006'),
	('K11','CSDL','GV05','2','2006','1/6/2006','15/7/2006'),
	('K12','CSDL','GV09','2','2006','1/6/2006','15/7/2006'),
	('K13','CTDLGT','GV15','2','2006','1/6/2006','15/7/2006'),
	('K13','CSDL','GV05','3','2006','1/8/2006','15/12/2006'),
	('K13','DHMT','GV07','3','2006','1/8/2006','15/12/2006'),
	('K11','CTDLGT','GV15','3','2006','1/8/2006','15/12/2006'),
	('K12','CTDLGT','GV15','3','2006','1/8/2006','15/12/2006'),
	('K11','HDH','GV04','1','2007','2/1/2007','18/2/2007'),
	('K12','HDH','GV04','1','2007','2/1/2007','20/3/2007'),
	('K11','DHMT','GV07','1','2007','18/2/2007','20/3/2007')

INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA)
VALUES
	('K1101','CSDL','1','20/07/2006','10','Dat'),
	('K1101','CTDLGT','1','28/12/2006','9','Dat'),
	('K1101','THDC','1','20/05/2006','9','Dat'),
	('K1101','CTRR','1','13/05/2006','9.5','Dat'),
	('K1102','CSDL','1','20/07/2006','4','Khong Dat'),
	('K1102','CSDL','2','20/07/2006','4.25','Khong Dat'),
	('K1102','CSDL','3','10/08/2006','4.5','Khong Dat'),
	('K1102','CTDLGT','1','28/12/2006','4.5','Khong Dat'),
	('K1102','CTDLGT','2','05/01/2007','4','Khong Dat'),
	('K1102','CTDLGT','3','15/01/2007','6','Dat'),
	('K1102','THDC','1','20/05/2006','5','Dat'),
	('K1102','CTRR','1','13/05/2006','7','Dat'),
	('K1103','CSDL','1','20/07/2006','3.5','Khong Dat'),
	('K1103','CSDL','2','27/07/2006','8.25','Dat'),
	('K1103','CTDLGT','1','28/12/2006','7','Dat'),
	('K1103','THDC','1','20/05/2006','8','Dat'),
	('K1103','CTRR','1','13/05/2006','6.5','Dat'),
	('K1104','CSDL','1','20/07/2006','3.75','Khong Dat'),
	('K1104','CTDLGT','1','28/12/2006','4','Khong Dat'),
	('K1104','THDC','1','20/05/2006','4','Khong Dat'),
	('K1104','CTRR','1','13/05/2006','4','Khong Dat'),
	('K1104','CTRR','2','20/05/2006','3.5','Khong Dat'),
	('K1104','CTRR','3','30/06/2006','4','Khong Dat'),
	('K1201','CSDL','1','20/07/2006','6','Dat'),
	('K1201','CTDLGT','1','28/12/2006','5','Dat'),
	('K1201','THDC','1','20/05/2006','8.5','Dat'),
	('K1201','CTRR','1','13/05/2006','9','Dat'),
	('K1202','CSDL','1','20/07/2006','8','Dat'),
	('K1202','CTDLGT','1','28/12/2006','4','Khong Dat'),
	('K1202','CTDLGT','2','05/01/2007','5','Dat'),
	('K1202','THDC','1','20/05/2006','4','Khong Dat'),
	('K1202','THDC','2','27/05/2006','4','Khong Dat'),
	('K1202','CTRR','1','13/05/2006','3','Khong Dat'),
	('K1202','CTRR','2','20/05/2006','4','Khong Dat'),
	('K1202','CTRR','3','30/06/2006','6.25','Dat'),
	('K1203','CSDL','1','20/07/2006','9.25','Dat'),
	('K1203','CTDLGT','1','28/12/2006','9.5','Dat'),
	('K1203','THDC','1','20/05/2006','10','Dat'),
	('K1203','CTRR','1','13/05/2006','10','Dat'),
	('K1204','CSDL','1','20/07/2006','8.5','Dat'),
	('K1204','CTDLGT','1','28/12/2006','6.75','Dat'),
	('K1204','THDC','1','20/05/2006','4','Khong Dat'),
	('K1204','CTRR','1','13/05/2006','6','Dat'),
	('K1301','CSDL','1','20/12/2006','4.25','Khong Dat'),
	('K1301','CTDLGT','1','25/07/2006','8','Dat'),
	('K1301','THDC','1','20/05/2006','7.75','Dat'),
	('K1301','CTRR','1','13/05/2006','8','Dat'),
	('K1302','CSDL','1','20/12/2006','6.75','Dat'),
	('K1302','CTDLGT','1','25/07/2006','5','Dat'),
	('K1302','THDC','1','20/05/2006','8','Dat'),
	('K1302','CTRR','1','13/05/2006','8.5','Dat'),
	('K1303','CSDL','1','20/12/2006','4','Khong Dat'),
	('K1303','CTDLGT','1','25/07/2006','4.5','Khong Dat'),
	('K1303','CTDLGT','2','07/08/2006','4','Khong Dat'),
	('K1303','CTDLGT','3','15/08/2006','4.25','Khong Dat'),
	('K1303','THDC','1','20/05/2006','4.5','Khong Dat'),
	('K1303','CTRR','1','13/05/2006','3.25','Khong Dat'),
	('K1303','CTRR','2','20/05/2006','5','Dat'),
	('K1304','CSDL','1','20/12/2006','7.75','Dat'),
	('K1304','CTDLGT','1','25/07/2006','9.75','Dat'),
	('K1304','THDC','1','20/05/2006','5.5','Dat'),
	('K1304','CTRR','1','13/05/2006','5','Dat'),
	('K1305','CSDL','1','20/12/2006','9.25','Dat'),
	('K1305','CTDLGT','1','25/07/2006','10','Dat'),
	('K1305','THDC','1','20/05/2006','8','Dat'),
	('K1305','CTRR','1','13/05/2006','10','Dat')

ALTER TABLE LOP CHECK CONSTRAINT FK_LOP_HOCVIEN;
ALTER TABLE HOCVIEN CHECK CONSTRAINT FK_HOCVIEN_LOP;
ALTER TABLE KHOA CHECK CONSTRAINT FK_KHOA_GIAOVIEN;
ALTER TABLE GIAOVIEN CHECK CONSTRAINT FK_GIAOVIEN_KHOA;


-- 2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”

CREATE TRIGGER CHECK_MAHOCVIEN
ON HOCVIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Result BIT = 0;
    DECLARE @STT VARCHAR(2);
    DECLARE @TempTable TABLE (MAHV VARCHAR(5), RowNum INT);
	DECLARE @MAHV VARCHAR(5);
    DECLARE @MALOP VARCHAR(3);

    INSERT INTO @TempTable (MAHV, RowNum)
    SELECT MAHV, ROW_NUMBER() OVER (ORDER BY MAHV)
    FROM HOCVIEN;

    SELECT @STT = CASE
                    WHEN RowNum < 10
                    THEN '0' + CAST(RowNum AS VARCHAR(2))
                    ELSE CAST(RowNum AS VARCHAR(2))
                  END
    FROM @TempTable
    WHERE MAHV = @MAHV;

    IF SUBSTRING(@MAHV, 1, 3) = LEFT(@MALOP, 3) AND SUBSTRING(@MAHV, 4, 2) = @STT
    BEGIN
        SET @Result = 1;
    END

    SELECT @MAHV = MAHV, @MALOP = MALOP FROM INSERTED;

    IF NOT EXISTS 
	(
        SELECT *
        FROM HOCVIEN
        WHERE @Result = 1
    )
    BEGIN
        RAISERROR('Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp', 16, 1);
        ROLLBACK;
    END
END;


-- 3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_GIOITINH_HV
CHECK (GIOITINH IN ('Nam', 'Nu'));

ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_GIOITINH_GV
CHECK (GIOITINH IN ('Nam', 'Nu'));

-- 4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI
ALTER COLUMN DIEM NUMERIC(4, 2);

-- 5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
CREATE TRIGGER Check_KQTHI
ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
    UPDATE KETQUATHI
    SET KQUA = CASE
        WHEN KETQUATHI.DIEM >= 5 AND KETQUATHI.DIEM <= 10 THEN 'Dat'
        ELSE 'Khong dat'
    END
    FROM inserted
    WHERE KETQUATHI.MAHV = inserted.MAHV
      AND KETQUATHI.MAMH = inserted.MAMH
      AND KETQUATHI.LANTHI = inserted.LANTHI
      AND KETQUATHI.NGTHI = inserted.NGTHI;
END;

-- 6. Học viên thi một môn tối đa 3 lần.
CREATE TRIGGER CheckSoLuongThi
ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE LANTHI > 3
    )
    BEGIN
        RAISERROR('Học viên chỉ thi môn này tối đa 3 lần.', 16, 1);
		ROLLBACK;
    END
END;


-- 7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHK_HOCKY
CHECK (HOCKY BETWEEN 1 AND 3);

-- 8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_HOCVI
CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'));

-- 9. Lớp trưởng của một lớp phải là học viên của lớp đó.
CREATE TRIGGER CheckTrgLop
ON LOP
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @IsValidTrgLOP BIT;

    SELECT @IsValidTrgLOP = CASE
        WHEN TRGLOP IS NULL THEN 1
        WHEN TRGLOP NOT IN (SELECT MAHV FROM HOCVIEN WHERE MALOP = INSERTED.MALOP) THEN 0
        ELSE 1
    END
    FROM INSERTED;

    IF @IsValidTrgLOP = 0
    BEGIN
        RAISERROR('Lớp trưởng phải là học viên của lớp đó.', 16, 1);
        ROLLBACK;
    END
END;


-- 10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
CREATE TRIGGER tr_CheckTrgKhoa
ON KHOA
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    DECLARE @IsValidTrgKhoa BIT;

    SELECT @IsValidTrgKhoa = CASE
        WHEN EXISTS (
            SELECT 1
            FROM INSERTED AS i
            WHERE i.MAKHOA = KHOA.MAKHOA
                AND EXISTS (
                    SELECT 1
                    FROM GIAOVIEN AS gv
                    WHERE gv.MAGV = i.TRGKHOA
                        AND gv.MAKHOA = i.MAKHOA
                        AND gv.HOCVI IN ('TS', 'PTS')
                )
        ) THEN 1
        ELSE 0
    END
    FROM KHOA, INSERTED;

    IF @IsValidTrgKhoa = 0
    BEGIN
        RAISERROR('Trưởng khoa phải là giáo viên thuộc khoa và có học vị TS hoặc PTS.', 16, 1);
        ROLLBACK;
    END
END;

-- 11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_TUOI
CHECK (DATEDIFF(YEAR, NGSINH, GETDATE()) >= 18)

-- 12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_NGAY_DAY_HOC
CHECK (TUNGAY < DENNGAY)


-- 13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_TUOI_GV
CHECK (DATEDIFF(YEAR, NGSINH, GETDATE()) >= 21)

-- 14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
UPDATE MONHOC
SET TCLT = 3, TCTH = 0
WHERE ABS(TCLT - TCTH) > 3;

ALTER TABLE MONHOC
ADD CONSTRAINT CHECK_TINCHI
CHECK (ABS(TCLT - TCTH) <=3)


-- 15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
CREATE TRIGGER tr_ChecKKetQuaThi
ON HOCVIEN
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @ThiHocKy BIT;

    SELECT @ThiHocKy = CASE
        WHEN EXISTS 
		(
            SELECT *
            FROM INSERTED AS I
			JOIN LOP ON I.MALOP = LOP.MALOP
            JOIN GIANGDAY AS GD ON LOP.MALOP = GD.MALOP
            WHERE GD.DENNGAY <= GETDATE()
        ) 
		THEN 1
        ELSE 0
    END
    FROM INSERTED;

    IF @ThiHocKy = 0
    BEGIN
        RAISERROR('Học viên chỉ được thi môn học khi lớp đã học xong môn này.', 16, 1);
        ROLLBACK;
    END
END;


-- 16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
CREATE TRIGGER CheckTrgGiangDay
ON GIANGDAY
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @IsValidGiangDay BIT;

    SELECT @IsValidGiangDay = CASE
        WHEN EXISTS 
		(
            SELECT 1
            FROM INSERTED AS I
            JOIN 
			(
                SELECT MALOP, HOCKY, NAM, COUNT(*) AS SoLuongMonHoc
                FROM GIANGDAY
                GROUP BY MALOP, HOCKY, NAM
            ) AS GD ON I.MALOP = GD.MALOP
            WHERE GD.SoLuongMonHoc > 3
        ) THEN 0
        ELSE 1
    END
    FROM INSERTED;

    IF @IsValidGiangDay = 0
    BEGIN
        RAISERROR('Mỗi lớp chỉ được học tối đa 3 môn trong một học kỳ.', 16, 1);
        ROLLBACK;
    END
END


-- 17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
CREATE TRIGGER tr_ChecSiSo
ON HOCVIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MAHV VARCHAR(5), @MALOP VARCHAR(3)
	SELECT @MAHV = IST.MAHV, @MALOP = IST.MALOP
	FROM INSERTED IST

	UPDATE LOP
    SET SISO = 
	(
		SELECT COUNT(*)
        FROM HOCVIEN
        JOIN LOP ON HOCVIEN.MALOP = LOP.MALOP
		WHERE LOP.MALOP = @MALOP
	)
	WHERE LOP.MALOP = @MALOP
	PRINT('DA THAY DOI SI SO LOP')
END

CREATE TRIGGER tr_ChecSiSo_DELETE
ON HOCVIEN
FOR DELETE
AS
BEGIN
	DECLARE @MAHV VARCHAR(5), @MALOP VARCHAR(3)
	SELECT @MAHV = DLTED.MAHV, @MALOP = DLTED.MALOP
	FROM deleted DLTED

	UPDATE LOP
    SET SISO = 
	(
		SELECT COUNT(*)
        FROM HOCVIEN
        JOIN LOP ON HOCVIEN.MALOP = LOP.MALOP
		WHERE LOP.MALOP = @MALOP
	)
	WHERE LOP.MALOP = @MALOP

	PRINT('DA THAY DOI SI SO LOP')
END


-- 18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ 
-- không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và (“B”,”A”).
ALTER TABLE DIEUKIEN
ADD CONSTRAINT UQ_MAMH_MAMH_TRUOC UNIQUE (MAMH, MAMH_TRUOC);

ALTER TABLE DIEUKIEN
ADD CONSTRAINT CK_MAMH_MAMH_TRUOC_DIFF
CHECK (MAMH <> MAMH_TRUOC);


-- 19. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.
CREATE TRIGGER tr_LuongGiaoVien
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
        SELECT *
        FROM INSERTED I
        JOIN GIAOVIEN GV ON I.HOCVI = GV.HOCVI
                           AND I.HOCHAM = GV.HOCHAM
                           AND I.HESO = GV.HESO
                           AND ISNULL(I.MUCLUONG, 0) <> ISNULL(GV.MUCLUONG, 0)
    )
    BEGIN
        RAISERROR('Mức lương của giáo viên cùng học vị, học hàm, và hệ số lương phải bằng nhau.', 16, 1);
        ROLLBACK;
    END
END;


-- 20. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5.
CREATE TRIGGER tr_LanThi
ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
       SELECT *
       FROM INSERTED I
       JOIN KETQUATHI KQ ON I.MAHV = KQ.MAHV AND I.MAMH = KQ.MAMH AND I.LANTHI = KQ.LANTHI - 1
	   WHERE KQ.DIEM >= 5
    )
    BEGIN
        RAISERROR('Học viên chỉ được thi lại khi điểm của lần thi trước đó dưới 5.', 16, 1);
        ROLLBACK;
    END
END


-- 21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học).
CREATE TRIGGER CheckNgayThi
ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
        SELECT *
        FROM INSERTED I
        JOIN KETQUATHI KQ ON I.MAHV =KQ.MAHV
                           AND I.MAMH = KQ.MAMH
                           AND I.LANTHI = KQ.LANTHI - 1
                           AND I.NGTHI <= KQ.NGTHI
    )
    BEGIN
        RAISERROR('Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước.', 16, 1);
        ROLLBACK;
    END
END;

-- 22. Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong.
-- -> Giống câu 15

-- 23. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau khi học 
-- xong những môn học phải học trước mới được học những môn liền sau).


-- 24. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.
CREATE TRIGGER CheckKhoaGV
ON GIANGDAY
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS 
	(
        SELECT *
        FROM INSERTED I
        JOIN GIAOVIEN GV ON I.MAGV = GV.MAGV
        JOIN MONHOC MH ON I.MAMH = MH.MAMH
        WHERE GV.MAKHOA <> MH.MAKHOA
    )
    BEGIN
        RAISERROR('Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.', 16, 1);
        ROLLBACK;
    END
END
