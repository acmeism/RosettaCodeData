-- 24 Aug 2025
include Setting
numeric digits 100

say 'SPECIAL NEIGHBOR PRIMES'
say version
say
arg xx','yy
if xx = '' then
   xx = 2
if yy = '' then
   yy = 99
interpret 'xx =' xx'+0'; interpret 'yy =' yy'+0'
a = Xpon(yy)+1; b = a+3
say 'Special neighbor primes between' xx 'and' yy'...'
say
say Right('p',a) Right('q',a) Right('p+q-1',b)
p = xx; q = Nextprime(xx)
do while q <= yy
   r = p+q-1
   if Prime(r) then
      say Right(p,a) Right(q,a) Right(r,b)
   p = q; q = Nextprime(p)
end
say
say Format(Time('e'),,3) 'seconds'
exit

include Math
