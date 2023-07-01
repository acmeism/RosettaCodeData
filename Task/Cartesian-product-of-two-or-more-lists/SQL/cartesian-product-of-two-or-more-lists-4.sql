insert into L1 values (3);
insert into L2 values (30);
create table L3 (value integer);
insert into L3 values (500);
insert into L3 values (100);
-- product works the same for as many "lists" as you'd like
select * from L1, L2, L3;
