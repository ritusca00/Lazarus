create table errors_log(
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
unit_type varchar2(4000),
unit_name varchar2(4000),
inside_unit_type varchar2(4000),
inside_unit_name varchar2(4000),
error_message varchar2(4000),
created_by varchar2(4000)  default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
unique_message varchar2(4000),
CONSTRAINT pk_errors_log PRIMARY KEY (id)
);
CREATE INDEX idx_errors_log_date ON errors_log (creation_date);
