-- 12 Sep 2025
include Setting
numeric digits 100

say 'BINARY DIGITS'
say version
say
say left('Decimal',9) '= Binary'
call Task 0
call Task 5
call Task 50
call Task 9000
call Task 999999999
call Task 1e30
exit

Task:
arg xx
-- Built-in Decimal2Hex -> Hex2Binary -> Normalize
say left(xx,9) '=' X2B(D2X(xx))
say left(xx,9) '=' X2B(D2X(xx))+0
return 0

include Math
