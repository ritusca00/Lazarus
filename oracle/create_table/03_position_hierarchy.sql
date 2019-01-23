create table position_hierarchy(
id NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1),
child_id number not null,
parent_id number,
active    number,
creation_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
creation_date date default sysdate,
last_updated_by varchar2(100) default sys_context('USERENV', 'OS_USER'),
last_updated_date date default sysdate,
CONSTRAINT position_hierarchy_pk PRIMARY KEY (id),
CONSTRAINT check_position_hierarchy check (active in (1,2))
);
CREATE INDEX idx_position_hierarchy_child ON position_hierarchy (child_id);
CREATE INDEX idx_position_hierarchy_parent ON position_hierarchy (parent_id);
