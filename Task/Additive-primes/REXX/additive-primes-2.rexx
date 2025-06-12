-- 22 Mar 2025
include Settings

say 'ADDITIVE PRIMES'
say version
say
arg n
numeric digits 16
if n = '' then
   n = 500
show = (n > 0); n = Abs(n)
a = Additives(n)
if show then do
   do i = 1 to a
      call Charout ,Right(addi.i,8)' '
      if i//10 = 0 then
         say
   end
   say
end
say a 'additive primes found below' n
say Time('e')/1 'seconds'
exit

include Sequences
include Numbers
include Functions
include Abend
