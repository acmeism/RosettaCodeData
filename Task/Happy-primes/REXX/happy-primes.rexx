-- 23 Aug 2025
include Setting

say 'HAPPY PRIMES'
say version
say
say 'Get Happys up to 60 million...'
say HappyS(60e6) 'found'
call Timer 'R'
say 'Get Primes up to 60 million...'
say PrimeS(60e6) 'found'
call Timer 'R'
call ShowFirst50
call ShowFractions
call Timer 'R'
exit

ShowFirst50:
procedure expose Happ.
say 'First 50 Happy Primes...'
do i = 1 to 50
   call CharOut ,Right(Happ.i,4)
   if i//10 = 0 then
      say
end
say
return

ShowFractions:
procedure expose Happ. Flag.
say 'Happy Primes / Happys...'
say 'Fraction  Index    Value'
say '------------------------'
p=0; r=2
do i = 2 to Happ.0
   h=Happ.i
   if Flag.h then
      p=p+1
   f=p/(i+1)
   if f < 1/r then do
      say '1 /' Right(r,2)':' Right(i,7) Right(h,8)
      r=r+1
   end
end
say '------------------------'
return

include Math
