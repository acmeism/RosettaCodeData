-- 29 Aug 2025
include Setting

arg threshold
-- Max threshold 300,000 for the task
-- and 25,000,000 for 1,000,000 de Polignac numbers
if threshold = '' then
   threshold=300000
say 'DE POLIGNAC NUMBERS'
say version
say
say 'Get primes up to' threshold'...'
say PrimeS(threshold) 'found'; say
say 'Get de Polignacs up to' threshold'...'
say PolignacS(threshold) 'found'; say
say 'First 50 de Polignac numbers...'
call First50
say 'Nth de Polignac number for powers of 10...'
call PowersOf10
call Timer
exit

PolignacS:
procedure expose Prim. Poli.
arg threshold
-- Precompute powers of 2
Pow2.=0; p=2
do i = 1 while p < 2*threshold
   Pow2.i=p; p=p*2
end
-- Flag all numbers as Polignac
Polf.=1
-- Strike numbers prime+2, prime+4, prime+8...
do i = 1 to Prim.0
   p=Prim.i; s=p+Pow2.1
   do j = 2 while s <= threshold
      Polf.s=0; s=p+Pow2.j
   end j
end i
-- Collect Polignacs except 3
Poli.=0; Poli.1=1; n=1
do i = 5 by 2 to threshold
   if Polf.i then do
      n=n+1; Poli.n=i
   end
end
Poli.0=n
return n

First50:
procedure expose Poli.
do i = 1 to 50
   call CharOut ,Right(Poli.i,5)
   if i//10 = 0 then
      say
end
say
return

PowersOf10:
procedure expose Poli.
say Right('Nth',7) Right('Number',8)
do i = 1 to 10
   j=10**i
   if Poli.j <> 0 then
      say Right(j,7) Right(Poli.j,8)
end
say
return

include Math
