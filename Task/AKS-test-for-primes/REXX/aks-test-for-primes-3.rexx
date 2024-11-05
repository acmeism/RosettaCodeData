parse version version; say version
say 'AKS-test for Primes'; say
arg p
if p = '' then
   p = 10
numeric digits Max(10,Abs(p)%3)
call Combis p
call Polynomials p
call ShowPrimes p
exit

Combis:
procedure expose comb.
arg p
call Time('r')
if p > 0 then
   say 'Combinations up to' p'...'
else
   say 'Combinations for' Abs(p)'...'
say Combinations(p) 'Combinations generated'
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
   a = Ppower('1 -1',i)
   if i < 11 then
      say '(x-1)^'i '=' Parray2formula()
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

ShowPrimes:
procedure expose prim.
arg p
call Time('r')
say 'Primes...'
if p < 0 then do
   p = Abs(p)
   if prim.0 > 0 then
      say p 'is Prime'
   else
      say p 'is not Prime'
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

Combinations:
/* Combinations */
procedure expose comb.
arg xx
/* Validate */
if \ Whole(xx) then say abend
/* Recurring definition */
comb. = 1
if xx < 0 then do
   xx = -xx; m = xx%2; a = 1
   do i = 1 to m
      a = a*(xx-i+1)/i; comb.xx.i = a
   end
   do i = m+1 to xx-1
      j = xx-i; comb.xx.i = comb.xx.j
   end
   return xx+1
end
else do
   do i = 1 to xx
      i1 = i-1
      do j = 1 to i1
         j1 = j-1; comb.i.j = comb.i1.j1+comb.i1.j
      end
   end
   return (xx*xx+3*xx+2)/2
end

Ppower:
/* Exponentiation */
procedure expose poly. comb. work.
arg x,y
/* Validate */
if x = '' then say abend
if \ Whole(y) then say abend
if y < 0 then say abend
/* Exponentiate */
numeric digits Digits()+2
wx = Words(x); wm = wx*y-y+1
poly. = 0; poly.0 = wm
select
   when wx = 1 then
/* Power of a number */
      poly.coef.1 = x**y
   when wx = 2 then do
/* Newton's binomial */
      a = Word(x,1); b = Word(x,2)
      do i = 1 to wm
         j = y-i+1; k = i-1
         poly.coef.i = comb.y.k*a**j*b**k
      end
   end
   otherwise do
/* Repeated multiplication */
      do i = 1 to wx
         poly.coef.1.i = Word(x,i)
         poly.coef.2.i = poly.coef.1.i
      end
      wy = wx
      do i = 2 to y
         work. = 0
         do j = 1 to wx
            do k = 1 to wy
               l = j+k-1; work.coef.l = work.coef.l+poly.coef.1.j*poly.coef.2.k
            end
         end
         if i = y then
            leave i
         wx = wx+wy-1
         do j = 1 to wx
            poly.coef.1.j = work.coef.j
         end
      end
      do i = 1 to wm
         poly.coef.i = work.coef.i
      end
   end
end
numeric digits Digits()-2
/* Normalize coefs */
call Pnormalize
return wm

Parray2formula:
/* Array -> Formula */
procedure expose poly.
/* Generate formula */
y = ''; wm = poly.0
do i = 1 to wm
   a = poly.coef.i
   if a <> 0 then do
      select
         when a < 0 then
            s = '-'
         when i > 1 then
            s = '+'
         otherwise
            s = ''
      end
      a = Abs(a); e = wm-i
      if a = 1 & e > 0 then
         a = ''
      select
         when e > 1 then
            b = 'x^'e
         when e = 1 then
            b = 'x'
         otherwise
            b = ''
      end
      y = y||s||a||b
   end
end
if y = '' then
   y = 0
return Strip(y)

include Functions
include Numbers
include Polynomial
include Sequences
