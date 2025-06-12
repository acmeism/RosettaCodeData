-- 22 Mar 2025
include Settings

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

include Abend
include Functions
include Sequences
