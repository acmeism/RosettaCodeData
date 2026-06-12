-- 23 Aug 2025
include Setting
numeric digits 20

call Time('r')
say 'PRIMES WHOSE FIRST AND LAST NUMBER IS THE SAME'
say version
say
call GetPrimes
call Task
call Stretch
say Format(Time('e'),,3) 'seconds'; say
exit

GetPrimes:
procedure expose prim.
call Primes 1e7+100
return

Task:
procedure expose prim.
say 'Primes below 10000 with first and last digit is the same...'
say
w = '1 2 3 5 7 9'
do i = 1 to Words(w)
   d = Word(w,i)
   say 'Beginning and ending with' d
   n = 0
   do j = 1
      p = prim.j
      if p > 10000 then
         leave
      if Same(p,d) then do
         n = n+1
         call Charout ,Right(p,5)
         if n //10 = 0 then
            say
      end
   end
   say
   say n 'such primes'
   say
end
return

Stretch:
procedure expose prim.
say 'Primes below given threshold with first and last digit is the same...'
say
w = '1 3 7 9'
do i = 1 to Words(w)
   d = Word(w,i)
   say 'Beginning and ending with' d
   n = 0; t = 1
   do j = 1 to prim.0
      p = prim.j
      if p > 1'E't then do
         say Right(n,5) 'such primes below' Right(10**t,8)
         t = t+1
      end
      if Same(p,d) then
         n = n+1
   end
   say
end
return

Same:
procedure
arg xx,yy
if Left(xx,1) = yy & Right(xx,1) = yy then
   return 1
else
   return 0

include Math
