include Settings

say version; say 'Totient function (Phi)'; say
call Time('r')
numeric digits 10; cycl. = 0; m = 7
call First25A
call PrimeCountA m
say Format(Time('e'),,3) 'seconds'; say
call Time('r')
call Totients 10**m
call First25B
call PrimeCountB m
say Format(Time('e'),,3) 'seconds'
exit

First25A:
procedure
say 'A: using calls to an optimized Totient()'; say
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
procedure
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
procedure expose toti.
say 'B: generate and save all Totients, and use the stored values'; say
say ' N Phi(N) Prime?'
say Copies('-',16)
n = 0
do i = 1 to 25
   p = toti.totient.i
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
procedure expose toti.
arg x
n = 0; d = 1
do i = 1
   p = toti.totient.i
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

Totient:
/* Euler's totient function */
procedure expose toti.
arg x
/* Fast values */
if x < 3 then
   return 1
if x < 5 then
   return 2
/* Multiplicative property using Factors */
f = Factors(x)+1; fact.factor.f = 0
y = 1; v = fact.factor.1; n = 1
do i = 2 to f
   a = fact.factor.i
   if a = v then
      n = n+1
   else do
      y = y*v**(n-1)*(v-1)
      v = a; n = 1
   end
end
return y

Totients:
/* Euler's totient numbers */
procedure expose toti.
arg x
/* Recurring sequence */
do i = 1 to x
   toti.totient.i = i
end
do i = 2 to x
   if toti.totient.i < i then
      iterate i
   do j = i by i to x
      toti.totient.j = toti.totient.j-toti.totient.j/i
   end
end
toti.0 = x
return x

include Functions
include Numbers
include Sequences
include Abend
