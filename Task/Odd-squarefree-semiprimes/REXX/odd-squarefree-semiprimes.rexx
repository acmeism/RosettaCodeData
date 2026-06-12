-- 24 Aug 2025
include Setting

say 'ODD SQUAREFREE SEMIPRIMES'
say version
say
arg xx
if xx = '' then
   xx = 1000
interpret 'xx =' xx'+0'
a = Xpon(xx)+1
say 'Odd squarefree semiprimes up to' xx'...'
n = 0
do i = 3 by 2 to xx
   if \ Squarefree(i) then
      iterate
   if \ Semiprime(i) then
      iterate
   n = n+1
   if xx <= 1000 then do
      call Charout ,Right(i,a)
      if n//10 = 0 then
         say
   end
end
say
say n 'such numbers'
say Format(Time('e'),,3) 'seconds'
exit

include Math
