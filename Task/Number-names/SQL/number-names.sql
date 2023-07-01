select val, to_char(to_date(val,'j'),'jsp') name
from
(
select
round( dbms_random.value(1, 5373484)) val
from dual
connect by level <= 5
);

select to_char(to_date(5373485,'j'),'jsp') from dual;
