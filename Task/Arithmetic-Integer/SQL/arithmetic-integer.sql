-- test.sql
-- Tested in SQL*plus

drop table test;

create table test (a integer, b integer);

insert into test values ('&&A','&&B');

commit;

select a-b difference from test;

select a*b product from test;

select trunc(a/b) integer_quotient from test;

select mod(a,b) remainder from test;

select power(a,b) exponentiation from test;
