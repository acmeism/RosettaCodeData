select round ( power( ( 1 + sqrt( 5 ) ) / 2, level ) / sqrt( 5 ) ) fib
from dual
connect by level <= 10;
