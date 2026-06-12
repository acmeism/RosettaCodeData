-- 24 Aug 2025
include Setting

call Time('r')
say 'PIPRIMES'
say version
say
call GetPrimes 100
call ShowPrimes 22
say Format(Time('e'),,3) 'seconds'; say
exit

GetPrimes:
procedure expose prim.
arg xx
say 'Get primes up to' xx'...'
call primes xx
say prim.0 'primes found'
say
return

ShowPrimes:
procedure expose prim.
arg xx
say 'Piprimes below' xx'...'
n = 0; p = 0; j = 2
do i = 1 to prim.0 while p < xx
   do j = j to prim.i
      n = n+1
      call Charout, Right(p,4)
      if n//10 = 0 then
         say
   end
   p = p+1
end
say
say
return

include Math
