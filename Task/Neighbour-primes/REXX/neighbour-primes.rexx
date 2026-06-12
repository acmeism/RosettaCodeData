-- 24 Aug 2025
include Setting
numeric digits 100

say 'NEIGHBOR PRIMES'
say version
say
arg xx','yy
if xx = '' then
   xx = 2
if yy = '' then
   yy = 500
interpret 'xx =' xx'+0'; interpret 'yy =' yy'+0'
a = Xpon(yy)+1; b = 2*a
say 'Neighbor primes between' xx 'and' yy'...'
say
say Right('p',a) Right('q',a) Right('pq+2',b)
p = xx
do while p <= yy
   q = Nextprime(p); r = p*q+2
   if Prime(r) then
      say Right(p,a) Right(q,a) Right(r,b)
   p = q
end
say
say Format(Time('e'),,3) 'seconds'
exit

include Math
