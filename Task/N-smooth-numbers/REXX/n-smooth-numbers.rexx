-- 25 Apr 2025
include Settings

say 'N-SMOOTH NUMBERS'
say version
say
parse arg xl','xh','nl','nh
numeric digits 200
call GetPrimes 1000
call ShowSmooth 1,25,2,29
call ShowSmooth 3000,3002,3,29
call ShowSmooth 30000,30019,503,521
call ShowSmooth 1,20,5,5
call ShowSmooth 1691,1691,5,5
call ShowSmooth 1e5,1e5,5,5
call ShowSmooth 1e6,1e6,5,5
call ShowSmooth 1e7,1e7,5,5
exit

GetPrimes:
procedure expose prim. flag. numb.
call Time('r')
arg xx
say 'Get Primes up to' xx'...'
call Primes(xx)
numb. = 0
do i = 1 to prim.0
   p = prim.i; numb.p = i
end
say Format(Time('e'),,3) 'seconds'; say
return

ShowSmooth:
arg xl,xh,nl,nh
call Time('r')
do j = nl to nh
   if \ flag.j then
      iterate
   call Smooths -xh,j
   dd = ''
   do k = xl to xh
      dd = dd smoo.k
   end
   say j'-smooth numbers' xl 'thru' xh'...'
   say Strip(dd);say
end
say Format(Time('e'),,3) 'seconds'; say
return

include Sequences
include Numbers
include Functions
include Constants
include Abend
