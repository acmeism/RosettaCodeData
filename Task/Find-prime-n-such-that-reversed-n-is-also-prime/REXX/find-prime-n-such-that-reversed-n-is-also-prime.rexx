-- 24 Aug 2025
include Setting

say 'REVERSABLE PRIMES'
say version
say
numeric digits 4
call Time('r')
call Primes 1000
call Task
say; say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure expose prim. flag.
say 'Reversable primes below 500:'
n = 0
do i = 1
   a = prim.i; b = Reverse(a)
   if a > 500 then
      leave i
   if \ flag.b then
      iterate i
   n = n+1
   call charout ,right(a,4)
   if n//10 = 0 then
      say
end
say; say n 'reversable primes found'
return

include Math
