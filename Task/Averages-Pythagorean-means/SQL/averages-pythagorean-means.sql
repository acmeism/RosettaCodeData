--setup
create table averages (val integer);
insert into averages values (1);
insert into averages values (2);
insert into averages values (3);
insert into averages values (4);
insert into averages values (5);
insert into averages values (6);
insert into averages values (7);
insert into averages values (8);
insert into averages values (9);
insert into averages values (10);
-- calculate means
select
  1/avg(1/val) as harm,
  avg(val) as arith
from
  averages;
