-- set of numbers is a table
-- create one set with 3 elements

create table myset1 (element number);

insert into myset1 values (1);
insert into myset1 values (2);
insert into myset1 values (3);

commit;

-- check if 1 is an element

select 'TRUE' BOOL from dual
where 1 in
(select element from myset1);

-- create second set with 3 elements

create table myset2 (element number);

insert into myset2 values (1);
insert into myset2 values (5);
insert into myset2 values (6);

commit;

-- union sets

select element from myset1
union
select element from myset2;

-- intersection

select element from myset1
intersect
select element from myset2;

-- difference

select element from myset1
minus
select element from myset2;

-- subset

-- change myset2 to only have 1 as element

delete from myset2 where not element = 1;

commit;

-- check if myset2 subset of myset1

select 'TRUE' BOOL from dual
where 0 =  (select count(*) from
(select element from myset2
minus
select element from myset1));

-- equality

-- change myset1 to only have 1 as element

delete from myset1 where not element = 1;

commit;

 -- check if myset2 subset of myset1 and
 -- check if myset1 subset of myset2 and

select 'TRUE' BOOL from dual
where
0 =  (select count(*) from
(select element from myset2
minus
select element from myset1)) and
0 =
(select count(*) from
(select element from myset1
minus
select element from myset2));
