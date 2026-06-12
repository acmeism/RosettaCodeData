-- 24 Aug 2025
include Setting
numeric digits 10
arg xx
if xx = '' then
   xx = 5500

say 'PRIME TRIPLETS'
say version
say
call GetPrimes xx
call ShowTriplets
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

ShowTriplets:
call Time('r')
say 'Show triplets...'
p = prim.0; p = prim.p
n = 0; a = prim.1; b = prim.2
do i = 3 to prim.0
   c = prim.i
   if b-a = 2 then do
      if c-a = 6 then do
         n = n+1
         if p > 5500 then
            iterate i
         call Charout, Left('['a b c']',18)
         if n//5 = 0 then
            say
      end
   end
   a = b; b = c
end
say
say n 'triplets found'
say Format(Time('e'),,3) 'seconds'; say
return

include Math
