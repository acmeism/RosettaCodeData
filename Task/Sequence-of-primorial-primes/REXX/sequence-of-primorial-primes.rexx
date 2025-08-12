-- 28 Jul 2025
include Settings

say 'SEQUENCE OF PRIMORIAL PRIMES'
say version
say
call GetPrimorials 172
call ShowPrimes 172
say Format(Time('e'),,3) 'seconds'
exit

GetPrimorials:
procedure expose prim. prmo. Memo.
arg xx
say 'Get enough primorials...'
call Primorials(-xx)
say prmo.0 'found'
say
return

ShowPrimes:
procedure expose prmo. Memo.
arg xx
say 'Index of first 15 primorial primes is...'
n = 0
do i = 1 to xx
   p = prmo.i; x = Xpon(p)+1
   numeric digits x+10
   n = n+1
   if Prime(p-1) then do
      say i x 'digits'
      iterate
   end
   n = n+1
   if Prime(p+1) then do
      say i x 'digits'
      iterate
   end
end
say n 'Miller-Rabin primality tests performed'
say
return

include Math
