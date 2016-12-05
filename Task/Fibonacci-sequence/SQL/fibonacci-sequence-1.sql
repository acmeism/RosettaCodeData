select round ( exp ( sum (ln ( ( 1 + sqrt( 5 ) ) / 2)
        ) over ( order by level ) ) / sqrt( 5 ) ) fibo
from dual
connect by level <= 10;
