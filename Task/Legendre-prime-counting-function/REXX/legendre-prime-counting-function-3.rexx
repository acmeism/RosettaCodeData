-- 21 Feb 2026
include Setting

say 'LEGENDRE PRIME COUNTER (SIEVING)'
say version
say
numeric digits 10
do n = 0 to 8
   call Time('r')
   a = 10**n; p = Primes(a)
   say '10^'n Right(p,9) Format(Time('e'),3,3)'s'
end
exit

-- Primes
include Math
