-- 13 Jun 2026
include Setting

say 'TOTIENT FUNCTION (PHI)'
say version
numeric digits 10; m = 6
call First25A
call PrimeCountA m
call Timer 'r'
call First25B m
call PrimeCountB m
call Timer 'r'
exit

First25A:
procedure expose Fact.
say 'A: using calls to function Totient()'; say
say ' N Phi(N) Prime?'
say Copies('-',16)
n = 0
do i = 1 to 25
   p = Totient(i)
   if p = i-1 then do
      n = n+1; pr = 'Yes'
   end
   else
      pr = ''
   say Right(i,2) Right(p,6) pr
end
say Copies('-',16); say
say 'Found' Right(n,6) 'primes <' Right(25,8)
return

PrimeCountA:
procedure expose Fact. Toti.
arg x
n = 0; d = 1
do i = 1
   p = Totient(i)
   if p = i-1 then
      n = n+1
   e = Xpon(i)
   if e > d then do
      say 'Found' Right(n,6) 'primes <' Right(10**e,8)
      if e > x-1 then
         leave i
      d = e
   end
end
say
return

First25B:
procedure expose Toti.
arg m
say 'B: generate and save all totients, use the stored values'; say
call TotientS 10**m
say ' N Phi(N) Prime?'
say Copies('-',16)
n = 0
do i = 1 to 25
   p = toti.i
   if p = i-1 then do
      n = n+1; pr = 'Yes'
   end
   else
      pr = ''
   say Right(i,2) Right(p,6) pr
end
say Copies('-',16)
say
say 'Found' Right(n,6) 'primes <' Right(25,8)
return

PrimeCountB:
procedure expose Toti.
arg x
n = 0; d = 1
do i = 1
   p = toti.i
   if p = i-1 then
      n = n+1
   e = Xpon(i)
   if e > d then do
      say 'Found' Right(n,6) 'primes <' Right(10**e,8)
      if e > x-1 then
         leave i
      d = e
   end
end
say
return

-- Totient, TotientS, Xpon, Timer
include Math
