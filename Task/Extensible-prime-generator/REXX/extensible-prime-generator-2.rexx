include Settings

say version; say 'Extensible prime generator'; say
numeric digits 9
call Primes 105e3
call First20
call Between100and150
call Between7700and8000
call Number10000
/* call Primes 1e8 */
/* call Extended */
say Format(Time('e'),,3) 'seconds'
exit

Primes:
/* Prime numbers */
procedure expose prim. work.
arg x
/* Init */
prim. = 0
/* Fast values */
if x = 1 then
   return 0
/* Sieve of Eratosthenes */
work. = 1
do i = 3 by 2 to x while i*i <= x
   if work.prime.i then do
      do j = i*i by i+i to x
         work.prime.j = 0
      end
   end
end
/* Save results */
n = 1; prim.prime.1 = 2; prim.flag.2 = 1
do i = 3 by 2 to x
   if work.prime.i then do
      n = n+1; prim.prime.n = i; prim.flag.i = 1
   end
end
prim.0 = n
return n

First20:
procedure expose prim.
say 'The first 20 prime numbers are:'
do i = 1 to 20
   call charout ,right(prim.prime.i,3)
   if i//10 = 0 then
      say
end
say '20 primes found';say
return

Between100and150:
procedure expose prim.
say 'Prime numbers between 100 and 150 are:'
n = 0
do i = 1
   a = prim.prime.i
   if a < 100 then
      iterate i
   if a > 150 then
      leave i
   n = n+1
   call charout ,a' '
   if n//10 = 0 then
      say
end
say: say n 'primes found'; say
return

Between7700and8000:
procedure expose prim.
say 'Prime numbers between 7700 and 8000:'
n = 0
do i = 1
   a = prim.prime.i
   if a < 7700 then
      iterate i
   if a > 8000 then
      leave i
   n = n+1
end
say n 'primes found'; say
return

Number10000:
procedure expose prim.
say 'The 10000th prime number is:'
say prim.prime.10000
say
return

Extended:
procedure expose prim.
do i = 1 to 6
   j = 10**i
   say 'The' j'th prime is' prim.prime.j
end
say 'The 5500000th prime is' prim.prime.5500000
say
return

include Functions
include Numbers
include Abend
