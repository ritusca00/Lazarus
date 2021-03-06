create table attendance( --jelenléti
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
userid number, -- FK
plan_start date, 
plan_end date, 
actual_start date, 
actual_end date, 
plan_difference AS (round((plan_end-plan_start)*24,2)-0.5),
actual_difference as (round((actual_end-actual_start)*24,2)-0.5),
overtime number,
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_attendance PRIMARY KEY (id),
CONSTRAINT fk_attendance_userid FOREIGN KEY (userid) REFERENCES employee(userid)
);

