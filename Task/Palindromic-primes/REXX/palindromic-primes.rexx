-- 24 Aug 2025
include Setting
numeric digits 20

call Time('r')
say 'PRIMES WHICH CONTAIN ONLY ONE ODD DIGIT'
say version
say
call GetPrimes
call Task
call Stretch
say Format(Time('e'),,3) 'seconds'; say
exit

GetPrimes:
procedure expose prim.
call Primes 1e7+100
return

Task:
procedure expose prim.
say 'Primes below 1000 with only 1 odd digit...'
n = 0
do i = 1
   p = prim.i
   if p > 1000 then
      leave
   if OneOdd(p) then do
      n = n+1
      call Charout ,Right(p,4)
      if n //10 = 0 then
         say
   end
end
say
say n 'such primes'
say
return

Stretch:
procedure expose prim.
say 'Primes below given threshold with only 1 odd digit...'
n = 0; t = 1
do i = 1 to prim.0
   p = prim.i
   if p > 1'E't then do
      say Right(n,5) 'such primes below' Right(10**t,8)
      t = t+1
   end
   if OneOdd(p) then
      n = n+1
end
say
return

OneOdd:
procedure
arg xx
a = Verify(xx,02468)
if a = 0 then
   return 0
a = Verify(Substr(xx,a+1),02468)
if a > 0 then
   return 0
else
   return 1

include Math
