-- 24 Aug 2025
include Setting
numeric digits 20

call Time('r')
say 'STRANGE PLUS NUMBERS'
say version
say
call Task
say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure
say 'Strange plus numbers in the range 100 to 500...'
n = 0
do i = 100 to 500
   if StrangePlus(i) then do
      n = n+1
      call Charout ,i' '
      if n//10 = 0 then
         say
   end
end
say
say n 'found'
say
return

StrangePlus:
procedure
arg xx
if xx < 10 then
   if Prime(xx) then
      return 1
   else
      return 0
if xx < 100 then
   if Prime(Left(xx,1)+Right(xx,1)) then
      return 1
   else
      return 0
do i = 1 to Length(xx)-1
   if \ Prime(Substr(xx,i,1)+Substr(xx,i+1,1)) then
      return 0
end
return 1

include Math
