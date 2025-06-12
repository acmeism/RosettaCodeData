-- 22 Mar 2025
include Settings

say 'EXTENSIBLE PRIME GENERATOR'
say version
say
numeric digits 9
call Primes 105e3
call First20
call Between100and150
call Between7700and8000
call Number10000
call Primes 1e8
call Extended
say Format(Time('e'),,3) 'seconds'
exit

First20:
procedure expose prim.
say 'The first 20 prime numbers are:'
do i = 1 to 20
   call charout ,right(prim.i,3)
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
   a = prim.i
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
say 'Prime numbers between 77022 Mar 2025:'
n = 0
do i = 1
   a = prim.i
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
say prim.10000
say
return

Extended:
procedure expose prim.
do i = 1 to 6
   j = 10**i
   say 'The' j'th prime is' prim.j
end
say 'The 5500000th prime is' prim.5500000
say
return

include Functions
include Sequences
include Numbers
include Abend
