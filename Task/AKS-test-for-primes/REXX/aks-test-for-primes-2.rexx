-- 28 Jul 2025
include Settings
arg p
if p = '' then
   p = 10

say 'AKS TEST FOR PRIMES'
say version
say
numeric digits Max(10,Abs(p)%3)
call Combis p
call Polynomials p
call Showprimes p
exit

Combis:
procedure expose comb.
arg p
call Time('r')
if p > 0 then
   say 'Combinations up to' p'...'
else
   say 'Combinations for' Abs(p)'...'
say Combinations(p) 'combinations generated'
say Format(Time('e'),,3) 'seconds'
say
return

Polynomials:
procedure expose poly. comb. work. prim.
arg p
call Time('r')
say 'Polynomials...'
if p < 0 then
   b = Abs(p)
else
   b = 0
p = Abs(p); prim. = 0; n = 0
do i = b to p
   a = PowP('1 -1',i)
   if i < 11 then
      say '(x-1)^'i '=' Lst2FormP(Arr2LstP())
   s = 1
   do j = 2 to poly.0-1
      a = poly.coef.j
      if a//i > 0 then do
         s = 0
         leave j
      end
   end
   if s = 1 then do
      if i > 1 then do
         n = n+1
         prim.n = i
      end
   end
end
prim.0 = n
say Format(Time('e'),,3) 'seconds'
say
return

Showprimes:
procedure expose prim.
arg p
call Time('r')
say 'Primes...'
if p < 0 then do
   p = Abs(p)
   if prim.0 > 0 then
      say p 'is prime'
   else
      say p 'is not prime'
end
else do
   do i = 1 to prim.0
      call Charout ,Right(prim.i,5)
      if i//20 = 0 then
         say
   end
   say
end
say Format(Time('e'),,3) 'seconds'
say
return

include Math
