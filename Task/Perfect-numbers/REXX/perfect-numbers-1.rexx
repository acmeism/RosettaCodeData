-- 25 Mar 2025
include Settings

say 'PERFECT NUMBERS'
say version
say
numeric digits 100
call Show 1,34000000
call Show 137438691328
call Show 2658455991569831744654692615953842176
call Show 9658455991569831744654692615953842176
exit

Show:
procedure
call Time('r')
arg xx,yy
if yy = '' then
   yy = xx
interpret 'xx =' xx'+0'; interpret 'yy =' yy'+0'
say 'Perfect numbers between' xx 'and' yy'...'
xx = xx+Odd(xx); yy = yy-Odd(yy)
n = 0
do i = xx to yy by 2
   if Perfect(i) then do
      n = n+1
      call Charout ,i' '
   end
end
say
say n 'such numbers found'
say Format(Time('e'),,3) 'seconds'
say
return

include Numbers
include Functions
include Abend
