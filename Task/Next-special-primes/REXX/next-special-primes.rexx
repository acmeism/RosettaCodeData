-- 24 Aug 2025
include Setting
numeric digits 100

say 'NEXT SPECIAL PRIMES'
say version
say
arg xx
if xx = '' then
   xx = 1050
interpret 'xx =' xx'+0'
a = Xpon(xx)+1
say 'Next special primes up to' xx'...'
say
say Right('this',a) Right('next',a) Right('gap',a)
p = 2; q = 3; g = 1; h = 0
do until q >= xx
   if g > h then do
      say Right(p,a) Right(q,a) Right(g,a)
      h = g; p = q
   end
   q = Nextprime(q); g = q-p
end
say
say Format(Time('e'),,3) 'seconds'
exit

include Math
