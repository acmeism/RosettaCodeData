-- 23 Aug 2025
include Setting

say 'EXTRA PRIMES'
say version
say
call TaskA 7777
call TaskB  -777777777
say Format(Time('e'),,3) 'seconds'
exit

TaskA:
procedure expose prim.
arg x
show = (x>0); x = Abs(x)
p = Primes(x); n = 0
do i = 1 to p
   a = prim.i
   do j = 1 to Length(a)
      if Pos(Substr(a,j,1),'014689') > 0 then
         iterate i
   end
   if \ Prime(Digitsum(a)) then
      iterate i
   n = n+1
   if show then do
      call Charout ,Right(a,10)
      if n//10 = 0 then
         say
   end
end
say; say 'A' n 'extra primes found below' 10**(Xpon(x)+1)
return

TaskB:
procedure expose prim.
arg x
show = (x>0); x = Abs(x)
n = 1
if show then
   call Charout ,Right(2,10)
do i = 3 by 2 to x
   do j = 1 to Length(i)
      if Pos(Substr(i,j,1),'014689') > 0 then
         iterate i
   end
   if \ Prime(Digitsum(i)) then
      iterate i
   if \ Prime(i) then
      iterate i
   n = n+1
   if show then do
      call Charout ,Right(i,10)
      if n//10 = 0 then
         say
   end
end
say; say 'B' n 'extra primes found below' 10**(Xpon(x)+1)
return

include Math
