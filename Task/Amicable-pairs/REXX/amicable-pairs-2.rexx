-- 8 May 2025
include Settings

say 'AMICABLE PAIRS'
say version
say
arg n
numeric digits 16
if n = '' then
   n = 20000
show = (n > 0); n = Abs(n)
a = Amicables(n)
say time('e') a 'amicable pairs collected'
if show then do
   do i = 1 to a
      say time('e') amic.1.i 'and' amic.2.i 'are an amicable pair'
   end
end
say time('e') 'seconds'
exit

include Sequences
include Numbers
include Functions
include Special
include Abend
