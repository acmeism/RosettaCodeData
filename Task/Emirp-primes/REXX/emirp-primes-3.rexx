say 'Emirp primes - Using REXX libraries - Build 20240829'
parse version version; say version; say

/* Primes is in Numbers - See Extensible prime generator */

call Time('r'); numeric digits 7
call Primes 1e6
call Task1
call Task2
call Task3
say; say Format(Time('e'),,3) 'seconds'; say

call Time('r'); numeric digits 9
call Primes 1e8
call Stress
say; say Format(Time('e'),,3) 'seconds'; say
exit

Task1:
procedure expose prim. flag.
say 'The first 20 emirps:'
n = 0
do i = 1
   a = prim.prime.i; b = Reverse(a)
   if a = b then
      iterate i
   if \ flag.prime.b then
      iterate i
   n = n+1
   if n > 20 then
      leave i
   call Charout ,a' '
end
say; say
return

Task2:
procedure expose prim. flag.
say 'All emirps > 7700 and < 8000:'
n = 0
do i = 1
   a = prim.prime.i
   if a < 7700 then
      iterate
   if a > 8000 then
      leave i
   if a = b then
      iterate i
   b = Reverse(a)
   if \ flag.prime.b then
      iterate i
   n = n+1
   call Charout ,a' '
end
say; say
return

Task3:
procedure expose prim. flag.
say 'The 10000th emirp:'
n = 0
do i = 1
   a = prim.prime.i; b = Reverse(a)
   if a = b then
      iterate i
   if \ flag.prime.b then
      iterate i
   n = n+1
   if n = 10000 then do
      say a
      leave i
   end
end
return

Stress:
procedure expose prim. flag.
say 'Number of emirps < 100 million:'
p = prim.0; n = 0
do i = 1 to p
   a = prim.prime.i; b = Reverse(a)
   if a = b then
      iterate i
   if \ flag.prime.b then
      iterate i
   n = n+1
end
say n
say: say 'The last emirp:'
say prim.prime.p
return

include Functions
include Numbers
