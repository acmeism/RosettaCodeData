-- set up list 1
create table L1 (value integer);
insert into L1 values (1);
insert into L1 values (2);
-- set up list 2
create table L2 (value integer);
insert into L2 values (3);
insert into L2 values (4);
-- get the product
select * from L1, L2;
