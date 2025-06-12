-- 25 Apr 2025
include Settings
numeric digits 40000
arg xx
if xx = '' then
   xx = 11000

say 'WILSON PRIMES OF ORDER N'
say version
say 'Calculations in full precision up to p =' xx
say
call GetPrimes xx
call GetFactorials xx
call DisplayList xx
call Timer
exit

GetPrimes:
procedure expose prim.
arg xx
say 'Get primes...'
say Primes(xx) 'found'
say
return

GetFactorials:
procedure expose fcto.
arg xx
say 'Get factorials...'
say Factorials(xx) 'found'
say
return

DisplayList:
procedure expose prim. fcto.
arg xx
say '  n: Wilson primes'
say '--------------------'
mo = 1
do n = 1 to 11
   a = Right(n,3)':'; n1 = n-1; n1 = fcto.n1; mo = -mo
   do i = 1 to prim.0
      p = prim.i
      if p < n then
         iterate i
      pn = p-n; pn = fcto.pn
      if (n1*pn-mo)//(p*p) = 0 then
         a = a p
   end
   say a
end
say '--------------------'
return

include Sequences
include Functions
include Helper
include Abend
