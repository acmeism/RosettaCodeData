-- 10 Oct 2025
include Setting
arg xx
if xx = '' then
   xx = 1e5

say 'PALINDROMIC PRIMES IN BASE 16'
say version
say
call GetPrimes xx
call ShowPalindromes xx
exit

GetPrimes:
procedure expose Prim. Flag.
arg xx
say 'Get Primes up to' xx'...'
call PrimeS(xx)
return

ShowPalindromes:
procedure expose Prim. Flag.
arg xx
say 'Palindromic primes base 16 up to' xx'...'
w = 6; n = 0
do i = 1 to Prim.0
   p = Prim.i; q = D2x(p); r = Reverse(q)
   if q <> r then
      iterate
   s = X2d(r)
   if Flag.s then do
      n = n+1
      if xx <= 1e5 then do
         call CharOut ,Right(r,w)
         if n//10 = 0 then
            say
      end
   end
end
say
say n 'found'
return

-- PrimeS
include Sequence
