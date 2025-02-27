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
   call Time('r'); p = Prime(b); e = Time('e')
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

include Functions
include Numbers
include Abend
