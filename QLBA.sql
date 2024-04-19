CREATE TABLE BENHNHAN (
    MABN        char(4),
    HOTEN       varchar(40),
    DCHI        varchar(50),
    NGSINH      smalldatetime,
    CMND        int,
    DOITUONG    varchar(10),
    SLPT        varchar(10),
    PRIMARY KEY (MABN)
);

CREATE TABLE KHAMBENH (
    MAKB        char(4),
    MABN        char(4),
    BENH        varchar(20),
    BENHKT      varchar(20),
    BATDAU      smalldatetime,
    KETTHUC     smalldatetime,
    TAIKHAM     smalldatetime,
    PRIMARY KEY (MAKB),
    FOREIGN KEY (MABN) REFERENCES BENHNHAN(MABN)
);

CREATE TABLE PHAUTHUAT (
    MAPT        char(4),
    MABN        char(4),
    BOPHANPT    varchar(20),
    LOAIPT      varchar(20),
    KETQUA      varchar(20),
    PRIMARY KEY (MAPT),
    FOREIGN KEY (MABN) REFERENCES BENHNHAN(MABN)
);

CREATE TABLE BACSI (
    MABS        char(4),
    HOTEN       varchar(40),
    NAMSINH     smalldatetime,
    CHUYENMON   varchar(20),
    KHOA        varchar(20),
    BENHVIEN    varchar(20),
    PRIMARY KEY (MABS)
);

CREATE TABLE PHUTRACH (
    MABS        char(4),
    MAKB        char(4),
    BATDAUPT    smalldatetime,
    KETTHUCPT   smalldatetime,
    FOREIGN KEY (MABS) REFERENCES BACSI(MABS),
    FOREIGN KEY (MAKB) REFERENCES KHAMBENH(MAKB)
);

-- Thông tin bệnh nhân (HOTEN, CMND) thuộc đối tượng BHYT hoặc có địa chỉ Đồng Nai. Kết quả sắp xếp theo số lần phẫu thuật giảm dần.
SELECT HOTEN, CMND
FROM BENHNHAN
WHERE DOITUONG = 'BHYT'
UNION
SELECT BN.HOTEN, BN.CMND
FROM BENHNHAN BN
WHERE DCHI LIKE '%Đồng Nai%'
ORDER BY SLPT DESC;

-- Thông tin (MAKB, MABN, HOTEN) của những bệnh nhân sinh năm 2020 có khám bệnh chính là 'Tim mạch'.
SELECT KH.MAKB, KH.MABN, BN.HOTEN
FROM BENHNHAN BN
JOIN KHAMBENH KH ON BN.MABN = KH.MABN
WHERE YEAR(BN.NGSINH) = 2020 AND KH.BENH = 'Tim mạch';

-- Thông tin (MABN, HOTEN, SLPT) của bệnh nhân khám bệnh năm 2020
SELECT BN.MABN, BN.HOTEN, BN.SLPT
FROM BENHNHAN BN
JOIN KHAMBENH KH ON BN.MABN = KH.MABN
JOIN PHUTRACH PT ON KH.MAKB = PT.MAKB
WHERE YEAR(KH.TAIKHAM) = 2020;

-- Thông tin BS (MABS, HOTEN) có chuyên môn "Tai-Mũi-Họng" chưa được phụ trách khám bệnh năm 2020
SELECT B.MABS, B.HOTEN
FROM BACSI B
LEFT JOIN PHUTRACH PT ON B.MABS = PT.MABS
WHERE B.CHUYENMON = 'Tai-Mũi-Họng' AND YEAR(PT.BATDAUPT) != 2020;

-- Thông tin BS (MABS, HOTEN) chuyên môn 'Hồi sức-Cấp cứu', tham gia khám bệnh nhân 'Nguyên Văn A'
SELECT B.MABS, B.HOTEN
FROM BACSI B
JOIN PHUTRACH PT ON B.MABS = PT.MABS
JOIN KHAMBENH KH ON PT.MAKB = KH.MAKB
JOIN BENHNHAN BN ON KH.MABN = BN.MABN
WHERE B.CHUYENMON = 'Hồi sức-Cấp cứu' AND BN.HOTEN = 'Nguyễn Văn A';

-- Thông tin BS (MABS, HOTEN), có số lần phụ trách khám bệnh nhiều nhất
SELECT B.MABS, B.HOTEN, COUNT(PT.MAKB) AS SO_LAN_PHU_TRACH
FROM BACSI B
LEFT JOIN PHUTRACH PT ON B.MABS = PT.MABS
GROUP BY B.MABS, B.HOTEN
ORDER BY SO_LAN_PHU_TRACH DESC
LIMIT 1;