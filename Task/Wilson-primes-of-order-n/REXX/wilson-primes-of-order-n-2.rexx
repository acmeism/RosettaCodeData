-- 25 Apr 2025
include Settings
numeric digits 20
arg xx
if xx = '' then
   xx = 11000

say 'WILSON PRIMES OF ORDER N'
say version
say 'Calculations modulo p^2 up to p =' xx
say
call GetPrimes xx
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

DisplayList:
procedure expose prim. fcto.
arg xx
say '  n: Wilson primes'
say '--------------------'
do n = 1 to 301
   a = Right(n,3)':'
   do i = 1 to prim.0
      if Wilson(n,prim.i) then
         a = a prim.i
   end
   say a
end
say '--------------------'
return

Wilson:
procedure
arg n,p
if p < n then
   return 0
pr = 1; p2 = p*p
do i = 1 to n-1
   pr = (pr*i)//p2
end
do i = 1 to p-n
   pr = (pr*i)//p2
end
if (p2+pr-(-1)**n)//p2 = 0 then
   return 1
else
   return 0

include Sequences
include Functions
include Helper
include Abend
