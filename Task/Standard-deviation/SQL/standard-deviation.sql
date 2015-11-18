-- the minimal table
create table if not exists teststd (n double precision not null);

-- code modularity with view, we could have used a common table expression instead
create view  vteststd as
  select count(n) as cnt,
  sum(n) as tsum,
  sum(power(n,2)) as tsqr
from teststd;

-- you can of course put this code into every query
create or replace function std_dev() returns double precision as $$
 select sqrt(tsqr/cnt - (tsum/cnt)^2) from vteststd;
$$ language sql;

-- test data is: 2,4,4,4,5,5,7,9
insert into teststd values (2);
select std_dev() as std_deviation;
insert into teststd values (4);
select std_dev() as std_deviation;
insert into teststd values (4);
select std_dev() as std_deviation;
insert into teststd values (4);
select std_dev() as std_deviation;
insert into teststd values (5);
select std_dev() as std_deviation;
insert into teststd values (5);
select std_dev() as std_deviation;
insert into teststd values (7);
select std_dev() as std_deviation;
insert into teststd values (9);
select std_dev() as std_deviation;
-- cleanup test data
delete from teststd;
