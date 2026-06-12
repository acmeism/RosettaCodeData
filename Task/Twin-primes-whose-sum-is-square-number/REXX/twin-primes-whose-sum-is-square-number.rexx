-- 24 Aug 2025
include Setting
numeric digits 20
arg xx
if xx = '' then
   xx = 1E7
say 'TWIN PRIMES WHOSE SUM IS A SQUARE'
say version
say
call SievePrimes xx
call Timer 'r'
call UseSieve xx
call Timer 'r'
call UsePrimeTest xx
call Timer 'r'
call UsePrimeTest 1E12
call Timer 'r'
exit

SievePrimes:
arg xx
say 'Primes below' xx'...'
say Primes(xx) 'found'
return

UseSieve:
arg xx
say 'Primes p1,p2 below' xx 'with p2-p1=2 and p2+p1=x^2 for some x (Sieve)...'
n = 0
do i = 1 to prim.0-1
   j = i+1; a = prim.i; b = prim.j
   if b-a <> 2 then
      iterate i
   c = a+b; d = Isqrt(c)
   if d*d <> c then
      iterate i
   n = n+1
   call Charout ,Right(i'^2 =',11) Left(a '+' b,30)
   if n//2 = 0 then
      say
end
say
say n 'found'
return

UsePrimeTest:
arg xx
say 'Primes p1,p2 below' xx 'with p2-p1=2 and p2+p1=x^2 for some x (Squares)...'
n = 0
do i = 6 by 2 until a > xx
   a = i*i/2
   b = a-1
   if \ Prime(b) then
      iterate i
   c = a+1
   if \ Prime(c) then
      iterate i
   n = n+1
   call Charout ,Right(i'^2 =',11) Left(b '+' c,30)
   if n//2 = 0 then
      say
end
say
say n 'found'
return

include Math
