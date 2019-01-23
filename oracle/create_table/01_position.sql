create table position(
posid NUMBER GENERATED ALWAYS AS IDENTITY(START with 1000 INCREMENT by 1),
description varchar2(4000),
position_level number,
active number,
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT pk_position PRIMARY KEY (posid),
CONSTRAINT fk_position_level FOREIGN KEY (posid) REFERENCES position (posid),
CONSTRAINT check_position_aktiv CHECK (active in (1,2))
);
-- Add comments to the columns 
comment on column position.posid is 'auto_increment';
comment on column position.description is 'pozíció megnevezése';
comment on column position.posid is 'Létezõ, aktív pozíció?';
