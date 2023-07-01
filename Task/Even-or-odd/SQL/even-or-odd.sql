-- Setup a table with some integers
create table ints(int integer);
insert into ints values (-1);
insert into ints values (0);
insert into ints values (1);
insert into ints values (2);

-- Are they even or odd?
select
  int,
  case mod(int, 2) when 0 then 'Even' else 'Odd' end
from
  ints;
