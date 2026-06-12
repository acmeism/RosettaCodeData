-- 23 Aug 2025
include Setting
numeric digits 10
arg xx
if xx = '' then
   xx = 1e5

say 'PRIME NUMBERS WHICH CONTAIN 123'
say version
say
call GetPrimes xx
call ShowPrimes
exit

GetPrimes:
call Time('r')
arg xx
say 'Analysis for primes up to' xx 'follows'
say
say 'Get primes...'
call Primes xx
say prim.0 'primes found'
say Format(Time('e'),,3) 'seconds'; say
return

ShowPrimes:
call Time('r')
say 'Show primes...'
n = 0; a = prim.0; p = prim.a
do i = 1 to prim.0
   if Pos('123',prim.i) = 0 then
      iterate
   n = n+1
   if p > 1e5 then
      iterate
   call Charout ,Right(prim.i,7)
   if n//10 = 0 then
      say
end
say
say n 'such primes found'
say Format(Time('e'),,3) 'seconds'; say
return

include Math
