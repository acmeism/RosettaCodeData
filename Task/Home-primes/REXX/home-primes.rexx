-- 25 Apr 2025
include Settings

say 'HOME PRIMES'
say version
say
numeric digits 50
do i = 1 to 48
   call Home i
end
exit

Home:
procedure expose fact. glob. work.
arg xx
call Time('r')
if xx = 1 then
   call charout ,'HP1 = 1'
else do
   yy = xx/1
-- Collect chain
   n = 0
   do while Factors(yy) > 1
      n = n+1; work.n = yy; yy = ''
      do i = 1 to fact.0
         yy = yy||fact.i
      end
   end
-- Show results
   if n = 0 then
      call Charout ,'HP'xx '= '
   else do
      do i = 1 to n
         call Charout ,'HP'work.i'('n-i+1') = '
      end
   end
   call Charout ,yy
end
say
call Timer
say
return

include Helper
include Abend
include Functions
include Numbers
include Sequences
