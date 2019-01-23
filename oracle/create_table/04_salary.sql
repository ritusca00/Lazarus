create table salary(
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
userid number, -- FK
gross number, -- bruttó
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_salary PRIMARY KEY (id),
CONSTRAINT fk_salary_userid FOREIGN KEY (userid) REFERENCES employee(userid)
);
