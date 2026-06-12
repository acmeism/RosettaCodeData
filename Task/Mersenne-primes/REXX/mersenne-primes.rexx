-- 3 Mar 2026
include Setting
numeric digits 2000

say 'MERSENNE PRIMES'
say version
say
say 'Using Miller-Rabin primality test (scan M1...M1279)'
say '<= 25 digits deterministic, > 25 digits probabilistic'
say
call Time('r')
do i = 1 to 1279
   if Prime(i) then do
      a = 2**i-1; l = Length(a)
      if Prime(a) then do
         if l > 20 then
            a = Left(a,10)'...'Right(a,10)
         select
            when l < 26 then
               t = 'for sure'
            otherwise
               t = 'probably'
         end
         say '2^'i'-1' '=' a '('l' digits) is' t 'prime' '('Format(Time('e'),,3) 'seconds)'
      end
   end
end
say
say 'Using Lucas-Lehmer primality test (scan M1...M2281)'
say 'all deterministic'
say
call Time('r')
do i = 1 to 2281
   if Prime(i) then do
      a = 2**i-1; l = Length(a)
      if Primell(i) then do
         if l > 20 then
            a = Left(a,10)'...'Right(a,10)
         say '2^'i'-1' '=' a '('l' digits) is prime' '('Format(Time('e'),,3) 'seconds)'
      end
   end
end
return

-- Prime; Primell
include Math
