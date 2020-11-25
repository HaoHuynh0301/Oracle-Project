create table hao_cuahang(
  MaCH char(5) constraint pk_MAcuahang primary key,
  tenCH varchar2(20) not null,
  dchi varchar2(30),
  dthoai varchar2(20) unique
);

drop table hao_nhasach;

insert into hao_cuahang(mach, tench, dchi, dthoai) values('CH002', 'Nha Sach Phuong Nam', 'Can Tho', '0123456789');
insert into hao_cuahang(mach, tench, dchi, dthoai) values('CH003', 'Nha Sach Nguyen Hue', 'TP HCM', '0987654321');
insert into hao_cuahang(mach, tench, dchi, dthoai) values('CH001', 'FAHASA', 'Can Tho', '0939380933');
insert into hao_cuahang(mach, tench, dchi, dthoai) values('CH004', 'FAHASA', 'TP HCM', '0981124543');
insert into hao_cuahang(mach, tench, dchi, dthoai) values('CH005', 'Nha Sach Nhan Van', 'TP HCM', '0766832842');


create table hao_nhanvien(
  MaNV char(5) constraint pk_MANhanvien primary key,
  tenNV varchar2(30) not null,
  ngaysinh date not null,
  MaCH char(5) constraint fk_MaCuahang references hao_CUAHANG(MaCH)
);

insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0002', 'Ngo Hong Quoc Bao', '12-MAY-00', 'CH002');
insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0003', 'Le Chanh Nhut', '13-MAY-97', 'CH003');
insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0004', 'Mai Phuoc Vinh', '11-OCT-00', 'CH004');
insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0005', 'Dang Nguyen Phu Nguyen', '02-JAN-99', 'CH005');
insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0001', 'Bui Quoc Trong', '11-MAY-00', 'CH001');
insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0006', 'Nguyen Nhi Thai', '03-MAY-95', 'CH006');
insert into hao_nhanvien(manv, tennv, ngaysinh, mach) values('B0007', 'Duong Huu Thang', '16-MAR-96', 'CH007');


create table hao_hoadon(
  sohd number(5, 0) constraint pk_sohoadon primary key,
  ngaylap date default sysdate,
  MaNV char(5) constraint fk_MAnhanvien references hao_nhanvien(manv),
  tongtien number(15, 3) not null check(tongtien>0)
);

insert into hao_hoadon(sohd, manv, tongtien) values('1003', 'B0002', 150000);
insert into hao_hoadon(sohd, manv, tongtien) values('1004', 'B0003', 50000);
insert into hao_hoadon(sohd, manv, tongtien) values('1001', 'B0004', 20000);
insert into hao_hoadon(sohd, manv, tongtien) values('1002', 'B0001', 100000);
insert into hao_hoadon(sohd, manv, tongtien) values('1005', 'B0006', 60000);


select * from hao_sach;

create table hao_sach(
  IDsach varchar2(10) constraint pk_idsach primary key,
  tenSach varchar2(30) not null,
  gia number(10,3) not null check(gia > 0),
  donvitinh varchar2(10) not null
);

insert into hao_sach(idsach, tensach, gia, donvitinh) values('S02', 'Vat Ly 12', 6000, 'quyen');
insert into hao_sach(idsach, tensach, gia, donvitinh) values('S03', 'Hoa Hoc 12', 15000, 'quyen');
insert into hao_sach(idsach, tensach, gia, donvitinh) values('S04', 'Sinh Hoc 12', 20000, 'quyen');
insert into hao_sach(idsach, tensach, gia, donvitinh) values('S01', 'Toan 12', 70000, 'quyen');
insert into hao_sach(idsach, tensach, gia, donvitinh) values('S05', 'GDCD 12', 50000, 'quyen');


 -- 1
create or replace function get_mach_basedon_tench(Temp_tench varchar2)
return char
is
result_index varchar2(20);
begin 
    select mach into result_index from hao_cuahang where tenCH=Temp_tench;
    return result_index;
end;

DECLARE 
    result varchar2(30);
begin
    result := get_mach_basedon_tench('Nha Sach Minh Khai');
    dbms_output.put_line('Total no. of Customers: ' || result);  
end;

select get_mach_basedon_tench('Nha Sach Minh Khai') from dual;


-- 2
CREATE OR REPLACE FUNCTION sum_books
	RETURN number 
IS  
    total number(10,0) := 0;   
BEGIN  
    SELECT count(*) into total  from hao_sach;
    return total;
END; 

select sum_bookS() from dual;


-- 3
CREATE OR REPLACE PROCEDURE update_emp_name_hao_sach(manv varchar2, new_name varchar2) 
IS    

BEGIN    
    update hao_nhanvien set hao_nhanvien.tennv=new_name where hao_nhanvien.manv=manv;
END; 

EXECUTE update_emp_name_hao_sach('B0002', 'Huynh Van A');


-- 4
CREATE OR REPLACE PROCEDURE delete_book(book_name varchar2) 
IS    
    temp_id varchar2(10);
BEGIN    
    select idsach into temp_id from hao_sach where hao_sach.tensach=book_name;
    delete from hao_sach where hao_sach.idsach=temp_id;
END; 
execute delete_book('Vat Ly 12');


----------------------------------
desc hao_sach;
create table hao_sach_history(
    edituser varchar2(30),
    editdate timestamp,
    newIdSach VARCHAR2(10),
    newTenSach VARCHAR2(30),
    newGia number(10,3),
    newDonViTinh VARCHAR2(10)
);


create or replace trigger hao_sach_trigger
after insert on hao_sach
for each row
begin
    insert into hao_sach_history values(user, sysdate, :new.idsach, :new.tensach, :new.gia, :new.donvitinh);
end;


insert into hao_sach values('S10', 'Khoa hoc may tinh 18', 90000, 'quyen');

select * from hao_sach_history;

-------
desc hao_hoadon;

create table hao_hoadon_history(
    edituser varchar2(30),
    editdate timestamp,
    oldTongTien number(15,3),
    newTongTien number(15,3)
);

create or replace trigger hao_hoadon_history_trigger
after update on hao_hoadon
for each row
begin
    insert into hao_hoadon_history values(user, sysdate, :old.Tongtien, :new.tongtien);
end;


update hao_hoadon set tongtien=300000 where sohd=88888;


select * from hao_hoadon_history;
