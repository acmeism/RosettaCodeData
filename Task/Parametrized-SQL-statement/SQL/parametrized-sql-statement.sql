-- This works in Oracle's SQL*Plus command line utility

VARIABLE P_NAME VARCHAR2(20);
VARIABLE P_SCORE NUMBER;
VARIABLE P_ACTIVE VARCHAR2(5);
VARIABLE P_JERSEYNUM NUMBER;

begin

:P_NAME := 'Smith, Steve';
:P_SCORE := 42;
:P_ACTIVE := 'TRUE';
:P_JERSEYNUM := 99;

end;
/

drop table players;

create table players
(
NAME VARCHAR2(20),
SCORE NUMBER,
ACTIVE VARCHAR2(5),
JERSEYNUM NUMBER
);

insert into players values ('No name',0,'FALSE',99);

commit;

select * from players;

UPDATE players
   SET name = :P_NAME, score = :P_SCORE, active = :P_ACTIVE
   WHERE jerseyNum = :P_JERSEYNUM;

commit;

select * from players;
