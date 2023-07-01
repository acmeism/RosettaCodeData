SQL> with fib(e,f) as (select 1, 1 from dual union all select e+f,e from fib where e <= 55) select f from fib;

         F
----------
         1
         1
         2
         3
         5
         8
        13
        21
        34
        55

10 rows selected.
