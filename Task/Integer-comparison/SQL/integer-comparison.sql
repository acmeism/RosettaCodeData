drop table test;

create table test(a integer, b integer);

insert into test values (1,2);

insert into test values (2,2);

insert into test values (2,1);

select to_char(a)||' is less than '||to_char(b) less_than
from test
where a < b;

select to_char(a)||' is equal to '||to_char(b) equal_to
from test
where a = b;

select to_char(a)||' is greater than '||to_char(b) greater_than
from test
where a > b;
