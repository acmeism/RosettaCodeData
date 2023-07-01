-- Create table
create table benford (num integer);

-- Seed table
insert into benford (num) values (1);
insert into benford (num) values (1);
insert into benford (num) values (2);

-- Populate table
insert into benford (num)
  select
    ult + penult
  from
    (select max(num) as ult from benford),
    (select max(num) as penult from benford where num not in (select max(num) from benford))

-- Repeat as many times as desired
--    in Oracle SQL*Plus, press "Slash, Enter" a lot of times
--    or wrap this in a loop, but that will require something db-specific...

-- Do sums
select
  digit,
  count(digit) / numbers as actual,
  log(10, 1 + 1 / digit) as expected
from
  (
    select
      floor(num/power(10,length(num)-1)) as digit
    from
      benford
  ),
  (
    select
      count(*) as numbers
    from
      benford
  )
group by digit, numbers
order by digit;

-- Tidy up
drop table benford;
