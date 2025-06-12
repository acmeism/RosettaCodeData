-- 22 Mar 2025
include Settings

say 'PRIME DECOMPOSITION'
say version
say
numeric digits 50
call ShowFactors 100,120
call ShowFactors 720720
call ShowFactors 9007199254740991
call ShowFactors 2543821448263974486045199
call ShowFactors 340282366920938463463374607431768211455
exit

ShowFactors:
arg xx,yy
if yy = '' then
   yy = xx
do i = xx to yy
   call Charout ,i '= '
   f = Factors(i)
   if f = 1 then
      call Charout ,'Prime'
   else do
      do j = 1 to f
         if j < f then
            call Charout ,fact.j 'x '
         else
            call Charout ,fact.j
      end
   end
   say
end
say Format(Time('e'),,3) 'seconds'
say
return

include Functions
include Numbers
include Sequences
include Abend
