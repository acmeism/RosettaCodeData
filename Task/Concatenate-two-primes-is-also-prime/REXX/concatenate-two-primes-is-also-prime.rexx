-- 23 Aug 2025
include Setting

say 'CONCATENATED PRIMES'
say version
say
-- Collect and flag all primes with 4 digits max
numeric digits 5
p = Primes(9999)
-- Collect and flag all concatenated primes to avoid sorting
work. = 0
i = 1; a = prim.i
do while a < 100
   j = 1; b = prim.j
   do while b < 100
      c = a||b
      if flag.c = 1 then
         work.concat.c = 1
      j = j+1; b = prim.j
   end
   i = i+1; a = prim.i
end
-- Show and count results
say 'Concatenated primes (10 per line):'
say
n = 0
do i = 1 to 9999
   if work.concat.i then do
      n = n+1
      call charout ,right(i,5)
      if n//10 = 0 then
         say
   end
end
say
say n 'primes found'
say Format(Time('e'),,3) 'seconds'
exit

include Math
