-- 25 Apr 2026

Main:
include Setting
Memo.cache=0

say 'PRIME DECOMPOSITION'
say version
say 'Task'
say
numeric digits 100
call ShowFactors 100,120
call Timer 'R'
call ShowFactors 720720
call Timer 'R'
call ShowFactors 9007199254740991
call Timer 'R'
call ShowFactors 2543821448263974486045199
call Timer 'R'
call ShowFactors 2942942095527502756823568345688
call Timer 'R'
call ShowFactors 340282366920938463463374607431768211455
call Timer 'R'
call ShowFactors Primorial(150)
call Timer 'R'
numeric digits 50
call ShowMersenne
call Timer 'R'
exit

ShowFactors:
-- Show factors for a range numbers
arg xx,yy
if yy='' then
   yy=xx
do i=xx to yy
   call Charout ,i '= '
   f=FactorS(i)
   if f=1 then
      call Charout ,'Prime'
   else do
      do j=1 to f
         if j<f then
            call Charout ,Fact.j 'x '
         else
            call Charout ,Fact.j
      end
   end
   say
end
return

ShowMersenne:
-- Show factors for Mersenne numbers
p=2
do until p>100
   m=2**p-1; f=FactorS(m)
   call Charout ,'M'p '=' m '= '
   if f=1 then
      call Charout ,'Prime'
   else do
      do j=1 to f-1
         call Charout ,Fact.j 'x '
      end
      call Charout ,Fact.f
   end
   say
   p=Nextprime(p)
end
return

-- Nextprime; FactorS; Timer
include Math
