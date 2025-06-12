-- 8 May 2025
include Settings
arg xx
if xx = '' then
   xx = 1500000

say 'ANTI-PRIMES'
say version
say 'Brute force'
say
say 'Anti-primes below' xx'...'
h = 0; n = 0
do i = 1 to xx
   c = Divisor(i)
   if c > h then do
      n = n+1
      call Charout ,Left(i' ['c'] ',16)
      if n//5 = 0 then
         say
      h = c
   end
end
say n 'found'
say
call Timer
exit

include Numbers
include Functions
include Special
include Helper
include Abend
