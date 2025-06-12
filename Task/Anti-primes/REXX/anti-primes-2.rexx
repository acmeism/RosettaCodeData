-- 8 May 2025
include Settings
arg xx
if xx = '' then
   xx = 1500000

say 'ANTI-PRIMES'
say version
say 'Cheating'
say
say 'Anti-primes below' xx'...'
numeric digits 16
s = (xx > 0); xx = Abs(xx)
h = Highcomposites(xx)
if s then do
   do i = 1 to high.0
      c = Divisor(high.i)
      call Charout ,Left(high.i' ['c'] ',20)
      if i//5 = 0 then
         say
   end
end
say h 'found'
say
call Timer
exit

include Numbers
include Functions
include Special
include Sequences
include Helper
include Abend
