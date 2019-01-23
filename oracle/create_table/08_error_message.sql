create table errors_message(
emid NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
error_message varchar2(4000),
created_by varchar2(4000)  default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
CONSTRAINT pk_errors_message PRIMARY KEY (emid)
);
