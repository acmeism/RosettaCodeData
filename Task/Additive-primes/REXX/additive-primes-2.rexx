include Settings

say version; say 'Additive primes'; say
arg n
numeric digits 16
if n = '' then
   n = -500
show = (n > 0); n = Abs(n)
a = Additiveprimes(n)
if show then do
   do i = 1 to a
      call Charout ,Right(addi.additiveprime.i,8)' '
      if i//10 = 0 then
         say
   end
   say
end
say a 'additive Primes found below' n
say Time('e') 'seconds'
exit

Additiveprimes:
/* Additive prime numbers */
procedure expose addi. prim.
arg x
/* Init */
addi. = 0
/* Fast values */
if x < 2 then
   return 0
if x < 101 then do
   a = '2 3 5 7 11 23 29 41 43 47 61 67 83 89 999'
   do n = 1 to Words(a)
      w = Word(a,n)
      if w > x then
         leave
      addi.additiveprime.n = w
   end
   n = n-1; addi.0 = n
   return n
end
/* Get primes */
p = Primes(x)
/* Collect additive primes */
n = 0
do i = 1 to p
   q = prim.Prime.i; s = 0
   do j = 1 to Length(q)
      s = s+Substr(q,j,1)
   end
   if Prime(s) then do
      n = n+1; addi.additiveprime.n = q
   end
end
/* Return number of additive primes */
return n

include Functions
include Numbers
include Sequences
include Abend
