-- 25 Apr 2026
Main:
include Setting

say 'PRINT DEBUGGING STATEMENT'
say version
say
parse arg maxdiv
if maxdiv = '' then
   maxdiv = 5
say 'Random denominator is between 0 and'  maxdiv
call Random ,,12345
total = 0
do j = 1 to 1000
   r = Random(maxdiv)
   total = total+j/r; call Debug
end
say 'Total =' total
exit

include Math
