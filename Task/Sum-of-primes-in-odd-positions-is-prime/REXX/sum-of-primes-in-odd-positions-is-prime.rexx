-- 24 Aug 2025
include Setting

call Time('r')
say 'SUM OF PRIMES IN ODD POSITIONS IS PRIME'
say version
say
call Primes 1000
say 'For the' prim.0 'primes up to 1000...'
say
call Task
say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure expose prim.
say '  i p(i)  sum'
say '-------------'
sum = 0
do i = 1 by 2 to prim.0
   sum = sum+prim.i
   if Prime(sum) then
      say Right(i,3) Right(prim.i,3) Right(sum,5)
end
say '-------------'
return

include Math
