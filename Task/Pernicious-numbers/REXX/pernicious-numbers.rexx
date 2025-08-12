-- 28 Jul 2025
include Settings
numeric digits 100

say 'PERNICIOUS NUMBERS'
say version
say
call Show 1,36
call Show 888888877,888888888
exit

Show:
procedure
call Time('r')
arg xx,yy
if yy = '' then
   yy = xx
interpret 'xx =' xx'+0'; interpret 'yy =' yy'+0'
say 'Pernicious numbers between' xx 'and' yy'...'
say
n = 0
do i = xx to yy
   if Prime(Digitsum(Basenn(i,2))) then do
      n = n+1
      call Charout ,i' '
      if n//10 = 0 then
         say
   end
end
say
say n 'such numbers found'
say Format(Time('e'),,3) 'seconds'
say
return

include Math
