-- 22 Mar 2025
include Settings

say 'CARMICHAEL 3 STRONG PSEUDOPRIMES'
say version
say
arg n
numeric digits 16
if n = '' then
   n = 61
show = (n > 0); n = Abs(n)
c = Carmichaels(n)
if show then do
   do i = 1 to carm.0
      say carm.1.i 'x' carm.2.i 'x' carm.3.i '=',
          carm.1.i * carm.2.i * carm.3.i
   end
end
say c 'Carmichael numbers found up to first prime' n
say time('e') 'seconds'
exit

include Sequences
include Numbers
include Functions
include Abend
