-- 24 Aug 2025
include Setting
numeric digits 10

call Time('r')
say 'SAFE AND SOPHIE GERMAIN PRIMES'
say version
say
call First100
say Format(Time('e'),,3) 'seconds'
exit

First100:
procedure
say 'The first 50 Sophie Germain primes are...'
p = 2; n = 1
call Charout ,Right(p,5)
do p = 3 by 2 until n = 50
   if Prime(p) then do
      if Prime(2*p+1) then do
         n = n+1
         call Charout ,right(p,5)
         if n//10 = 0 then
            say
      end
   end
end
say
return

include Math
