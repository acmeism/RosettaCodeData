-- 8 May 2025
include Settings

call Time('r')
say 'TAU NUMBER'
say version
say
call Task 100
call Timer
exit

Task:
procedure
arg xx
say 'First' xx ' tau numbers...'
n = 0
do i = 1 until n = xx
   a = Divisor(i)
   if i//a = 0 then do
      n = n+1
      call Charout ,Right(i,5)
      if n//10 = 0 then
         say
   end
end
say
return

include Sequences
include Functions
include Special
include Constants
include Helper
include Abend
