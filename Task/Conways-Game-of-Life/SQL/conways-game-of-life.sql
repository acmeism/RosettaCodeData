-- save these lines in a file called
-- setupworld.sql

-- turn off feedback for cleaner display

set feedback off

-- 3 x 3 world

-- alive has coordinates of living cells

drop table alive;

create table alive (x number,y number);

-- three alive up the middle
--  *
--  *
--  *

insert into alive values (2,1);
insert into alive values (2,2);
insert into alive values (2,3);

commit;

-- save these lines in a file called
newgeneration.sql

-- adjact contains one row for each pair of
-- coordinates that is adjacent to a living cell

drop table adjacent;

create table adjacent (x number,y number);

-- add row for each of the 8 adjacent squares

insert into adjacent select x-1,y-1 from alive;
insert into adjacent select x-1,y from alive;
insert into adjacent select x-1,y+1 from alive;
insert into adjacent select x,y-1 from alive;
insert into adjacent select x,y+1 from alive;
insert into adjacent select x+1,y-1 from alive;
insert into adjacent select x+1,y from alive;
insert into adjacent select x+1,y+1 from alive;

commit;

-- delete rows for squares that are outside the world

delete from adjacent where x<1 or y<1 or x>3 or y>3;

commit;

-- table counts is the number of live cells
-- adjacent to that point

drop table counts;

create table counts as
select x,y,count(*) n
from adjacent a
group by x,y;

--    C   N                 new C
--    1   0,1             ->  0  # Lonely
--    1   4,5,6,7,8       ->  0  # Overcrowded
--    1   2,3             ->  1  # Lives
--    0   3               ->  1  # It takes three to give birth!
--    0   0,1,2,4,5,6,7,8 ->  0  # Barren

-- delete the ones who die

delete from alive a
where
((a.x,a.y) not in (select x,y from counts)) or
((select c.n from counts c where a.x=c.x and a.y=c.y) in
(1,4,5,6,7,8));

-- insert the ones that are born

insert into alive a
select x,y from counts c
where c.n=3 and
((c.x,c.y) not in (select x,y from alive));

commit;

-- create output table

drop table output;

create table output as
select rownum y,' ' x1,' ' x2,' ' x3
from dba_tables where rownum < 4;

update output set x1='*'
where (1,y) in
(select x,y from alive);

update output set x2='*'
where (2,y) in
(select x,y from alive);

update output set x3='*'
where (3,y) in
(select x,y from alive);

commit

-- output configuration

select x1||x2||x3 WLD
from output
order by y desc;
