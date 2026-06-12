-- 24 Aug 2025
include Setting

say 'PRIME NUMBERS OF THE FORM N^3+2'
say version
say
numeric digits 44
say '  n   n^3+2'
say '-----------'
n = 0
do i = 1 to 199
   a = i*i*i+2
   if Prime(a) then do
      n = n+1
      say Right(i,3) Right(a,7)
   end
end
say '-----------'
say n 'primes found'
say Format(Time('e'),,3) 'seconds'; say
exit

include Math
