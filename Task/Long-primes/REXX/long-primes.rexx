-- 28 Jul 2025
include Settings

say 'LONG PRIMES'
say version
say
call GetPrimes 70000
call LPbelow500
call NumberOfLP
exit

GetPrimes:
call Time('r')
arg x
say 'Get primes up to' x
numeric digits 10
call Primes(x)
say Format(Time('e'),,3) 'seconds'; say
return

LPbelow500:
call Time('r')
say 'Long primes < 500'
p = 0
do i = 1 to prim.0 until p > 500
   p = prim.i
   if p-PeriodQ(1 p) = 1 then
      call Charout ,p' '
end
say
say Format(Time('e'),,3) 'seconds'; say
return

NumberOfLP:
call Time('r')
say 'Number of long primes up to'
t = '500 1000 2000 4000 8000 16000 32000 64000 0'
w = 1; a = Word(t,1); n = 0
do i = 1 to prim.0 while a > 0
   p = prim.i
   if p > a then do
      say Right(a,5) Right(n,4)
      w = w+1; a = Word(t,w)
   end
   if p-PeriodInvQ(p) = 1 then do
      n = n+1
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

include Math
