select (CASE
    WHEN MOD(lvl,15)=0 THEN 'FizzBuzz'
    WHEN MOD(lvl,3)=0 THEN 'Fizz'
    WHEN MOD(lvl,5)=0 THEN 'Buzz'
    ELSE TO_CHAR(lvl)
    END) FizzBuzz
from (
    select LEVEL lvl
    from dual
    connect by LEVEL <= 100)
