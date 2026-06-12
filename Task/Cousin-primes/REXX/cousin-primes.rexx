-- 23 Aug 2025
include Setting
numeric digits 4

say 'COUSIN PRIMES'
say version
say
call ShowCousins 2,999
say Format(Time('e'),,3) 'seconds'
exit

ShowCousins:
procedure expose Memo.
arg x,y
n = 0
do i = x to y-4
   j = i+4
   if Prime(i) & Prime(j) then do
      call Charout ,'('i' 'j')  '
      n = n+1
      if n//10 = 0 then
         say
   end
end
say
say n 'cousin primes found between' x 'and' y
return

include Math
