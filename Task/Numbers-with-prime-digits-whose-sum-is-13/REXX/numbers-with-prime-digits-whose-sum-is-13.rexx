-- 26 Aug 2025
include Setting

say 'NUMBERS WITH PRIME DIGITS WHOSE SUM IS 13'
say version
say
say 'Searching for numbers...'; say
n = 0
do i = 100 to 1e6-1
   if Verify(i,2357) <> 0 then
      iterate
   if Digitsum(i) <> 13 then
      iterate
   n = n+1
   call Charout ,Right(i,7)
   if n//10 = 0 then
      say
end
say
say n 'such numbers found'
say Format(Time('e'),,3) 'seconds'
exit

include Math
