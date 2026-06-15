-- 13 Jun 2026
include Setting
numeric digits 30

say 'MOTZKIN NUMBERS'
say version
say
call Motzkins 1e20
call Range 0 41
say Time('e')/1 'seconds'
exit

Range:
procedure expose Motz. Glob.
arg xx yy
if yy = '' then
   yy = xx
say 'The Motzkin numbers from no' xx 'up to' yy 'are'
do i = xx to yy
   m = motz.i
   if Prime(m) then
      p = 'is prime'
   else
      p = ''
   say 'M['right(i,2)']' right(m,18) p
end
return

include Math
