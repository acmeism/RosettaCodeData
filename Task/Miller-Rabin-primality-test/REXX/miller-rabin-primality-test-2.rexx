include Settings

say version; say 'Miller-Rabin primality test'; say
numeric digits 1000
say '25 numbers of the form 2^n-1, mostly Mersenne primes'
say 'Up to about 25 digits deterministic, above probabilistic'
say
mm = '2 3 5 7 11 13 17 19 23 31 61 89 97 107 113 127 131 521 ',
||   '607 1279 2203 2281 2293 3217 3221'
do nn = 1 to 25
   a = Word(mm,nn); b = 2**a-1; l = Length(b)
   call Time('r'); p = IsPrime(b); e = Time('e')
   if l > 20 then
      b = Left(b,10)'...'Right(b,10)
   select
      when p = 0 then
         p = 'not'
      when l < 26 then
         p = 'for sure'
      otherwise
         p = 'probable'
   end
   say '2^'a'-1' '=' b '('l' digits) is' p 'prime' '('Format(e,,3) 'seconds)'
end
return

IsPrime:
/* Is a number prime? */
procedure expose glob.
arg x
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
w2 = '2047 1373653 25326001 3215031751 2152302898747 3474749660383 341550071728321 ',
||   '0 3825123056546413051 0 0 318665857834031151167461 3317044064679887385961981 '
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
   a = Word(w1,k); y = Powermod(a,d,x)
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

include Functions
include Numbers
include Abend
