-- 12 Jun 2026
include Setting
numeric digits 5

say 'ERDOS-PRIMES'
say version
say
call Primes 2500
call Task 2500
say
call Time('r'); numeric digits 7
call Primes 1000000
call Stretch 7875
say; say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure expose Prim. Flag. Fact.
arg x
say 'Erdos primes <' x':'
n = 0; fact. = 0
do i = 1 to prim.0
   a = prim.i
   do j = 1
      k = Fact(j)
      if k >= a then
         leave
      p = a-k
      if flag.p then
         iterate i
   end
   n = n+1
   call Charout ,Right(a,5)
   if n//10 = 0 then
      say
end
say; say n 'Erdos primes found'
return

Stretch:
procedure expose Prim. Flag. Fact.
arg x
say x'th Erdos prime:'
n = 0; fact. = 0
do i = 1 to prim.0
   a = prim.i
   do j = 1
      k = Fact(j)
      if k >= a then
         leave j
      p = a-k
      if flag.p then
         iterate i
   end
   n = n+1
   if n = x then do
      say a
      leave i
   end
end
say x 'Erdos primes processed'
return

include Math
