-- 21 Feb 2026
include Setting
arg p
if p='' then
   p=100

say 'AKS TEST FOR PRIMES' p
say version
say
numeric digits Max(10,Abs(p%3))
say Combmemo(p) 'combinations generated'
say
say Getprimes(p) 'primes found'
say
call Showprimes
say
call Timer
exit

Getprimes:
procedure expose Poly. Work. Prim. Memo.
arg p
q=-p*(p<0); p=Abs(p)
say 'Get primes...'
Poly.=0; Prim.=0; n=0
do i=q to p
-- Generate power of x-1, also saves coefficients
   a=PowP('1 -1',i)
   if i<11 then
      say '(x-1)^'i '=' Poly2form(Stem2poly())
-- AKS algorithm using saved coefficients
   s=1
   do j=2 to Poly.0-1
      a=Poly.j
      if a//i>0 then do
         s=0
         leave j
      end
   end
-- Bump prime
   if s=1 then do
      if i>1 then do
         n+=1; Prim.n=i
      end
   end
end
-- Prime count
Prim.0=n
return n

Showprimes:
procedure expose Prim.
say 'Primes...'
do i=1 to Prim.0
   call Charout ,Right(Prim.i,5)
   if i//20=0 then
      say
end
say
return

-- Combmemo; PowP; Poly2form; Stem2poly; Timer
include Math
