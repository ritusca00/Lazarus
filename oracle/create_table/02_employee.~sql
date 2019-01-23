create table employee(
userid NUMBER GENERATED ALWAYS AS IDENTITY(START with 1000 INCREMENT by 1),
username varchar2(50) not null, --unique
pwd varchar2(1000) not null,
lastname varchar2(100) not null,
firstname varchar2(100) not null,
gender char(1) not null, --F-female/M-male/U-uknown
birth_date date not null, --constraint 1900<
birth_place varchar2(1000),
mother_name varchar2(500),
address_const varchar2(4000),
address_temp  varchar2(4000),
email varchar2(100),
beginning_date date not null,
leaving_date date,
status varchar2(30),
posid number, -- FK -> position.posid
superior number, -- FK -> userid
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_employee PRIMARY KEY (userid),
CONSTRAINT uq_employee_username UNIQUE (username),
CONSTRAINT check_employee_birth_date CHECK (birth_date > DATE'1900-01-01'),
CONSTRAINT check_employee_gender CHECK (gender in ('F', 'M', 'U')),
CONSTRAINT check_employee_status CHECK (status in ('VALID', 'INVALID')),
CONSTRAINT fk_employee_superior FOREIGN KEY (superior) REFERENCES employee (userid),
CONSTRAINT fk_employee_posid FOREIGN KEY (posid) REFERENCES position(posid)
);
-- Add comments to the columns 
comment on column employee.userid is 'auto_increment';
comment on column employee.username is 'Felhasználónév, pl.: rbliznik';
comment on column employee.pwd is 'Jelszó SHA256()';
comment on column employee.lastname is 'Vezetéknév';
comment on column employee.firstname is 'Keresztnév';
comment on column employee.gender is 'Nem: F-female/M-male/U-uknown ';
comment on column employee.birth_date is 'Születésnap';
comment on column employee.birth_place is 'Születés hely';
comment on column employee.mother_name is 'Anyja neve';
comment on column employee.address_const is 'Állandó lakcím';
comment on column employee.address_temp is 'Ideiglenes lakcím';
comment on column employee.email is 'Belsõ email cím';
comment on column employee.beginning_date is 'Munkaviszony kezdete';
comment on column employee.leaving_date is 'Munkaviszony vége?';
comment on column employee.status is 'Munkaviszony státusza: VALID, INVALID pl: tartós táppénz, gyes ';
comment on column employee.posid is 'FK -> position.posid';
comment on column employee.superior is 'Felettes: FK -> employee.userid';
