Main:
include Settings
say version; say 'Legendre Prime counter (with memoization)'; say
numeric digits 10
do n = 0 to 9
   call Time('r')
   a = 10**n; p = Pi(a)
   say '10^'n Right(p,9) Format(Time('e'),3,3)'s'
end
exit

Pi:
procedure expose prim. work.
arg xx
if xx < 3 then
   return 0+(xx=2)
n = Primes(Isqrt(xx))
work. = 0
return Phi(xx,n)+n-1

Phi:
procedure expose prim. work.
arg xx,yy
if yy < 2 then
   return xx-(xx%2)*(yy=1)
p = prim.prime.yy
if xx <= p then
   return 1
if work.xx.yy > 0 then
   return work.xx.yy
work.xx.yy = Phi(xx,yy-1)-Phi(xx%p,yy-1)
return work.xx.yy

include Abend
include Functions
include Sequences
