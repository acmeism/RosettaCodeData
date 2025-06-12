-- 25 Apr 2025
include Settings
numeric digits 2000

say 'WIEFERICH PRIMES'
say version
say
call GetPrimes 5000
call DisplayList 5000
call Timer
exit

GetPrimes:
procedure expose prim.
arg xx
say 'Get primes below' xx'...'
say Primes(xx) 'found'
say
return

DisplayList:
procedure expose prim.
arg xx
say 'Wieferich primes below' xx'...'
n = 0
do i = 1 to prim.0
   if (2**(prim.i-1)-1)//(prim.i*prim.i) = 0 then do
      n = n+1
      say prim.i
   end
end
say n 'found'
say
return

include Sequences
include Helper
include Functions
include Constants
include Abend
