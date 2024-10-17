say 'Factor of a Mersenne number - Using REXX libraries'
parse version version; say version; say
call Time('r')
numeric digits 300
n = Primes(1000)
do i = 1 to n
   x = prim.prime.i
   select
      when (x >= 2 & x <= 83) then
         call Task x
      when (x >= 929 & x <= 967) then
         call Task x
      otherwise
         nop
   end
end
say; say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure
arg x
a = x; a = 'M'a; m = 2**x
do k = 1 by 2*x to ISqrt(m)
   if Right(k,1) = 5 then
      iterate k
   b = k//8
   if b = 1 | b = 7 then do
      if k//3 = 0 then
         iterate k
      if k//7 = 0 then
         iterate k
      c = m//k
      if c = 1 then do
         say a 'is composite =' k 'x ...'
         leave k
      end
   end
end
if c <> 1 then
   say a 'is prime'
return

include Functions
include Numbers
