
create table day_type( --keretóraidõ
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
descriptions varchar2(100),
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_day_type PRIMARY KEY (id)
);
