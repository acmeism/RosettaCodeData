-- setup
create table averages (val integer);
insert into averages values (1);
insert into averages values (2);
insert into averages values (3);
insert into averages values (1);
insert into averages values (2);
insert into averages values (4);
insert into averages values (2);
insert into averages values (5);
insert into averages values (2);
insert into averages values (3);
insert into averages values (3);
insert into averages values (1);
insert into averages values (3);
insert into averages values (6);
-- find the mode
with
  counts as
  (
    select
      val,
      count(*) as num
    from
      averages
    group by
      val
  )
select
  val as mode_val
from
  counts
where
  num in (select max(num) from counts);
