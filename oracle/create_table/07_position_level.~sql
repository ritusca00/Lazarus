create table position_level(
levelid NUMBER GENERATED ALWAYS AS IDENTITY(START with 1000 INCREMENT by 1),
description varchar2(4000),
active number,
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_position_level PRIMARY KEY (levelid),
CONSTRAINT check_position_level_aktiv CHECK (active in (1,2))
);
-- Add comments to the columns 
comment on column position_level.description is 'pozíció szint megnevezése';
