/*
This code is an implementation of "General FizzBuzz" in SQL ORACLE 19c
*/
select lpad( nvl(   case when mod(level, 3) = 0 then 'Fizz' end
                 || case when mod(level, 5) = 0 then 'Buzz' end
                 || case when mod(level, 7) = 0 then 'Baxx' end
                , level)
            ,12) as output
  from dual
connect by level <= 107
;
/
