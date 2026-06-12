-- 23 Aug 2025
include Setting

say 'FROBENIUS NUMBERS'
say version
say
numeric digits 20
arg x
if x = '' then
   x = 1e6
x = x+0
call GetPrimes x%10
call GenerateFrobenius
exit

GetPrimes:
call Time('r')
arg y
say 'Get Primes up to threshold' y
call Primes(y)
say Format(Time('e'),,3) 'seconds'; say
return

GenerateFrobenius:
call Time('r')
say 'Frobenius numbers below' x':'
do i = 1
   j = i+1; f = prim.i * prim.j - prim.i - prim.j
   if f > x
      then leave
   call CharOut ,Right(f,10)
   if i//10 = 0 then
      say
end
say
say i-1 'Frobenius numbers found'
say Format(Time('e'),,3) 'seconds'; say
return

include Math
