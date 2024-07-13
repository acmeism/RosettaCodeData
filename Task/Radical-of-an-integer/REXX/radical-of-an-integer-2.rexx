/* REXX */
arg n
if n = '' then
   n = 1000000
numeric digits 100
parse version version; say version 'Intel i7 5GHz'
say 'Radicals for an integer = product of distinct prime factors'
say 'Version 2: generic procedures'
say
say 'Radicals for 1..50:'
ol = ''
do i = 1 to 50
   ol = ol||Right(Radical(i),5)
   if i//10 = 0 then do
      say ol; ol = ''
   end
end
say
say 'Radicals for:'
say '99999  =' Radical(99999)
say '499999 =' Radical(499999)
say '999999 =' Radical(999999)
say
s = n/10; r = ISqrt(n); radi. = 0; glob. = ''
say 'Getting distribution list:'
call Time('r')
do i = 1 to n
   call Radical(i)
   u = glob.ufactor.0
   radi.u = radi.u+1
   if i//s = 0 then
      say Right(i,7) Format(Time('e'),,3) 'seconds'
end
say
say 'Distribution for first' n 'radicals over number of factors:'
do i = 0 to 10
   say Right(i,2) Right(radi.i,6)
end
say
say 'Getting primes up to' n':'
call Time('r')
pr = Primes(n)
say 'Took' Format(Time('e'),,3) 'seconds'
say
say 'Getting powers of primes up to' r':'
call Time('r')
pw = 0
do i = 1
   p1 = glob.prime.i
   if p1 > r then
      leave
   p2 = p1
   do forever
      p2 = p2*p1
      if p2 > n then
         leave
      pw = pw+1
   end
end
say 'Took' Format(Time('e'),,3) 'seconds'
say
say 'Primes' Format(pr,6)
say 'Powers' Format(pw,6)
say '        -----'
say 'Total ' Format(pr+pw,6)
exit

Radical:
/* Radical function = product of unique prime factors */
procedure expose glob.
arg x
/* Validity */
if \ Whole(x) then
   return 'X'
if x < 1 then
   return 'X'
/* Get unique factors */
n = Ufactors(x)
/* Calculate product */
y = 1
do i = 1 to n
   y = y*glob.ufactor.i
end
return y

Ufactors:
/* Unique factors */
procedure expose glob.
arg x
/* Validity */
if \ Datatype(x,'w') then
   return 'X'
if x < 1 then
   return 'X'
/* Fast values */
if x = 1 then do
   glob.ufactor.0 = 0
   return 0
end
if x < 4 then do
   glob.ufactor.1 = x
   glob.ufactor.0 = 1
   return 1
end
if Prime(x) then do
   glob.ufactor.1 = x
   glob.ufactor.0 = 1
   return 1
end
/* Check low factors */
n = 0; v = 0
pr = '2 3 5 7 11 13 17 19 23'
do i = 1 to Words(pr)
   pn = Word(pr,i)
   do while x//pn = 0
      if pn <> v then do
         n = n+1; glob.ufactor.n = pn; v = pn
      end
      x = x%pn
   end
end
/* Check higher factors */
do j = 29 by 6 while j*j <= x
   p = Right(j,1)
   if p <> 5 then do
      do while x//j = 0
         if j <> v then do
            n = n+1; glob.ufactor.n = j; v = j
         end
         x = x%j
      end
   end
   if p = 3 then
      iterate
   y = j+2
   do while x//y = 0
      if y <> v then do
         n = n+1; glob.ufactor.n = y; v = y
      end
      x = x%y
   end
end
/* Last factor */
if x > 1 then  do
   if x <> v then do
      n = n+1; glob.ufactor.n = x
   end
end
glob.ufactor.0 = n
/* Return number of factors */
return n

Isqrt:
/* Integer square root Floor(x^(1/2)) function */
procedure expose glob.
arg x
/* Validity */
if x < 0 then
   return 'X'
/* Fast values */
if x < 1 then
   return 0
if x < 4 then
   return 1
if x < 9 then
   return 2
/* Uses only integers */
x = x%1; q = 1
do until q > x
   q = q*4
end
y = 0
do while q > 1
   q = q%4; t = x-y-q; y = y%2
   if t >= 0  then do
      x = t; y = y+q
   end
end
return y

Powermod:
/* Power modulus x^y mod z function */
procedure expose glob.
arg x,y,z
/* Validity */
if \ Whole(x) then
   return 'X'
if \ Whole(y) then
   return 'X'
if \ Whole(z) then
   return 'X'
if x < 0 then
   return 'X'
if y < 0 then
   return 'X'
if z < 1 then
   return 'X'
/* Fast values */
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

Prime:
/* Is a number prime? function */
procedure expose glob.
arg x
/* Validity */
if \ Whole(x) then
   return 'X'
if x < 2 then
   return 'X'
/* Low primes also used as deterministic witnesses */
lp = '2 3 5 7 11 13 17 19 23 29 31 37 41'
/* Fast values */
if x < 42 then do
   if Wordpos(x,lp) = 0 then
      return 0
   else
      return 1
end
if x//2 = 0 then
   return 0
if x//3 = 0 then
   return 0
if Right(x,1) = 5 then
   return 0
/* Miller-Rabin primality test */
numeric digits 2*Length(x)
d = x-1; e = d
/* Reduce x-1 by factors of 2 */
do s = -1 while d//2 = 0
   d = d%2
end
/* Thresholds deterministic witnesses */
th = '2047 1373653 25326001 3215031751 2152302898747 3474749660383 341550071728321 0 ',
||   '3825123056546413051 0 0 318665857834031151167461 3317044064679887385961981 '
w = Words(th)
/* Up to 13 deterministic trials */
if x < Word(th,w) then do
   do k = 1 to w
      if x < Word(th,k) then
         leave
   end
end
/* or 3 probabilistic trials */
else do
   lp = ''
   do k = 1 to 3
      r = Rand(2,e)/1; lp = lp||r||' '
   end
   k = k-1
end
/* Algorithm using generated witnesses */
do k = 1 to k
   a = Word(lp,k); y = Powermod(a,d,x)
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

Rand:
/* Random number 12 digits precision function */
procedure expose glob.
arg x,y
/* Validity */
if x <> '' then do
   if \ Whole(x) then
      return 'X'
   if \ Whole(y) then
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
/* Is a number integer? function */
procedure expose glob.
arg x
/* Formula */
return Datatype(x,'w')

Primes:
/* Prime numbers */
procedure expose glob.
arg x
/* Validity */
if Datatype(x,'w') = 0 then
   return 'X'
if x < 1 then
   return 'X'
/* Fast values */
if x = 1 then do
   glob.prime.0 = 0
   return 0
end
if x < 101 then do
   p = '2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 999'
   do n = 1 to Words(p)
      w = Word(p,n)
      if w > x then do
         n = n-1
         leave
      end
      glob.prime.n = w
   end
   glob.prime.0 = n
   return n
end
/* Wheeled sieve of Eratosthenes */
z. = 1
do i = 3 by 2 to x while i*i <= x
   if z.i = 1 then do
      do j = i*3 by i+i to x
         z.j = 0
      end
   end
end
/* Save results */
n = 1; glob.prime.1 = 2
do i = 3 by 2 to x
   if z.i = 1 then do
      n = n+1; glob.prime.n = i
   end
end
glob.prime.0 = n
return n
