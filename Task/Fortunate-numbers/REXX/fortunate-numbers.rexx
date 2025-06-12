-- 8 May 2025
include Settings

say 'FORTUNATE NUMBERS'
say version
say
numeric digits 155
call GetPrimorials 75
call GenerateFortunate 75
call ShowFortunate 50
exit

GetPrimorials:
call Time('r')
arg x
say 'Get the first' x 'primorials...'
call Primorials(-x)
say Format(Time('e'),,3) 'seconds'; say
return

GenerateFortunate:
call Time('r')
arg x
say 'Generate fortunate numbers...'
work. = 0; m = 0; n = 0
do i = 1 to x
   p = prmo.i
   do j = 3 by 2
      m = m+1
      if Prime(p+j) then
         leave j
   end
   if work.j = 0 then do
      work.j = 1; n = n+1
   end
end
say m 'primality tests performed'
say n 'fortunate numbers found'
say Format(Time('e'),,3) 'seconds'; say
return

ShowFortunate:
call Time('r')
arg x
say 'First' x 'fortunate numbers:'
n = 0
do i = 1
   if work.i then do
      n = n+1
      call CharOut ,Right(i,5)
      if n//10 = 0 then
         say
      if n = x then
         leave i
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

include Numbers
include Sequences
include Functions
include Special
include Constants
include Abend
