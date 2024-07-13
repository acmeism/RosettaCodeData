parse version version
say version
glob. = ''
numeric digits 1000
say '25 numbers of the form 2^n-1, mostly Mersenne primes'
say 'Up to about 25 digits deterministic, above probabilistic'
say
mm = '2 3 5 7 11 13 17 19 23 31 61 89 97 107 113 127 131 521 607 1279 2203 2281 2293 3217 3221'
do nn = 1 to 25
   a = Word(mm,nn); b = 2**a-1; l = Length(b)
   call time('r'); p = Prime(b); e = time('e')
   if l > 25 then
      b = Left(b,12)'...'Right(b,13)
   select
      when p = 0 then
         p = 'not'
      when l < 26 then
         p = 'for sure'
      otherwise
         p = 'probable'
   end
   say '2^('a'-1)' '=' b '('l' digits) is' p 'prime' '('format(e,,3) 'seconds)'
end
return

Prime:
/* Is a number prime? */
procedure expose glob.
arg x
/* Validity */
if \ Whole(x) then
   return 'X'
if x < 2 then
   return 'X'
/* Low primes also used as deterministic witnesses */
w1 = ' 2 3 5 7 11 13 17 19 23 29 31 37 41 '
/* Fast values */
w = x
if Pos(' 'w' ',w1) > 0 then
   return 1
if x//2 = 0 then
   return 0
if x//3 = 0 then
   return 0
if Right(x,1) = 5 then
   return 0
/* Miller-Rabin primality test */
numeric digits 2*Length(x)
d = x-1; e = d
/* Reduce n-1 by factors of 2 */
do s = -1 while d//2 = 0
   d = d%2
end
/* Thresholds deterministic witnesses */
w2 = ' 2047 1373653 25326001 3215031751 2152302898747 3474749660383 341550071728321 0 ',
||   ' 3825123056546413051 0 0 318665857834031151167461 3317044064679887385961981 '
w = Words(w2)
/* Up to 13 deterministic trials */
if x < Word(w2,w) then do
   do k = 1 to w
      if x < Word(w2,k) then
         leave
   end
end
/* or 3 probabilistic trials */
else do
   w1 = ' '
   do k = 1 to 3
      r = Rand(2,e)/1; w1 = w1||r||' '
   end
   k = k-1
end
/* Algorithm using generated witnesses */
do k = 1 to k
   a = Word(w1,k); y = powermod(a,d,x)
   if y = 1 then
      iterate
   if y = e then
      iterate
   do s
      y = (y*y)//x
      if y = 1 then
         return 0
      if y = e then
         leave
   end
   if y <> e then
      return 0
end
return 1

Floor:
/* Floor */
procedure expose glob.
arg x
/* Formula */
if Whole(x) then
   return x
else
   return Trunc(x)-(x<0)

Powermod:
/* Power modulus function x^y mod z */
procedure expose glob.
arg x,y,z
/* Validity */
if \ Whole(x) then
   return 'X'
if \ Whole(x) then
   return 'X'
if \ Whole(x) then
   return 'X'
if x < 0 then
   return 'X'
if y < 0 then
   return 'X'
if z < 1 then
   return 'X'
/* Special values */
if z = 1 then
   return 0
/* Binary method */
numeric digits Max(Length(Format(x,,,0)),Length(Format(y,,,0)),2*Length(Format(z,,,0)))
b = x//z; r = 1
do while y > 0
   if y//2 then
      r = r*x//z
   x = x*x//z; y = y%2
end
return r

Rand:
/* Random number 12 digits precision */
procedure expose glob.
arg x,y
/* Validity */
if x <> '' then do
   if \ Whole(x) then
      return 'X'
   if \ Whole(x) then
      return 'X'
   if x >= y then
      return 'X'
end
/* Fixed precision */
p = Digits(); numeric digits 30
/* Get and save first seed from system Date and Time */
if glob.rand = '' then do
   a = Date('s'); b = Time('l')
   glob.rand = Substr(b,10,3)||Substr(b,7,2)||Substr(b,4,2)||Substr(b,1,2)||Substr(a,7,2)||Substr(a,5,2)||Substr(a,3,2)
end
/* Calculate next random number method HP calculators */
glob.rand = Right((glob.rand*2851130928467),15)
/* Uniform deviate [0,1) */
z = '0.'Left(glob.rand,Length(glob.rand)-3)
numeric digits 12
if x = '' then
   return z/1
else
   return Floor(z*(y+1-x)+x)

Whole:
/* Is a number integer? */
procedure expose glob.
arg x
/* Formula */
return Datatype(x,'w')
