
create table working_calendar( --keretóraidõ
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
calendar_year number,
calendar_month number,
calendar_day number,
day_type number, --'Munkanap':1, 'Pihenõnap:2', Ünnepnap:3
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_working_calendar PRIMARY KEY (id),
CONSTRAINT fk_workc_day_type FOREIGN KEY (day_type) REFERENCES day_type(id)
);
create index idx_working_calendar_date on working_calendar(calendar_year, calendar_month, calendar_day);
