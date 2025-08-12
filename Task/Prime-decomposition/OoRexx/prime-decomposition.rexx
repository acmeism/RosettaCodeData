.local~digits=50
numeric digits .local~digits
say 'PRIME DECOMPOSITION'
parse version version
say version
call ShowFactors 100,120
call ShowFactors 720720
call ShowFactors 9007199254740991
call ShowFactors 2543821448263974486045199
call ShowFactors 340282366920938463463374607431768211455
exit

ShowFactors:
Call time 'R'
arg xx,yy
if yy = '' then
   yy = xx
do i = xx to yy
   call Charout ,i '= '
   f = factors(i)
   if f = 1 then
      call Charout ,'Prime'
   else do
      do j = 1 to f
        call Charout ,GetFact(,j)
        if j < f then
          call Charout ,' x '
      end
   end
   say
end
say Format(Time('e'),,3) 'seconds'
say
return

::REQUIRES math.cls
