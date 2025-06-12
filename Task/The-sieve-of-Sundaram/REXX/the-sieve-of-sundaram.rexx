-- 25 Apr 2025
include Settings
arg xx
say 'THE SIEVE OF SUNDARAM'
say version
say
call Collect 16e6
call Task100
call Task1e6
call Timer
exit

Collect:
procedure expose prim. work.
arg xx
say 'Collecting primes up to' xx'...'
work. = 1
k = (xx-3)%2+1; m = (Isqrt(xx-3))%2+1
do i = 0 to m
   p = 2*i+3; s = (p*p-3)%2
   do j = s by p to k
      work.j = 0
   end
end
prim. = 0; n = 0
do i = 0 to k
   if work.i then do
      p = i+i+3
      if p > xx then
         leave i
      n = n+1; prim.n = p
   end
end
prim.0 = n
say n 'found'
say
return n

Task100:
procedure expose prim.
say 'First 100 Sundaram primes (excluding 2)...'
do i = 1 to 100
   call Charout ,Right(prim.i,4)
   if i//10 = 0 then
      say
end
say
return

Task1e6:
procedure expose prim.
say '1 millionth Sundaram prime (excluding 2)...'
say prim.1000000
say
return

include Sequences
include Helper
include Numbers
include Functions
include Constants
include Abend
