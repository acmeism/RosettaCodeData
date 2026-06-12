-- 1 Sep 2025
include Setting
numeric digits 30

call Time('r')
say 'PRIMES WHOSE SUM OF DIGITS IS 25'
say version
say
call Task 5000,25
call Stretch 25
say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure
arg xx,yy
say 'Primes below' xx 'whose sum of digits is' yy'...'
w = Xpon(xx)+2; n = 0
do i = 3 by 2 to xx
   if Digitsum(i) = yy then do
      if Prime(i) then do
         n = n+1
         call Charout ,Right(i,w)
         if n//10 = 0 then
            say
      end
   end
end
say
say n 'such primes'
say
return

Stretch:
procedure
arg xx
say 'Primes whose sum of digits is' xx'...'
say Count('',xx,0) 'such primes'
return

Count:
procedure
arg xx,yy,zz
if yy = 0 then do
   if Pos(Right(xx,1),1379) > 0 then do
      if Prime(xx) then
         zz = zz+1
   end
end
else do
   do i = 1 to Min(yy,9)
      zz = Count(xx||i,yy-i,zz)
   end
end
return zz

include Math
