create table working_period( --keretóraidõ
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
period_start date, 
period_end date, 
plan_difference_day number,
plan_difference_hours number,
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_working_period PRIMARY KEY (id)
);
