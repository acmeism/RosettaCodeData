-- 24 Aug 2025
include Setting

say 'NICE PRIMES'
say version
say
arg xx','yy
if xx = '' then do
   xx = 500; yy = 1000
end
call GetPrimes yy
call ShowNice xx,yy
exit

GetPrimes:
procedure expose prim. flag.
call Time('r')
arg xx
say 'Get PrimeS up to' xx'...'
call PrimeS xx
say Format(Time('e'),,3) 'seconds'; say
return

ShowNice:
procedure expose prim. flag.
call Time('r')
arg xx,yy
say 'Nice PrimeS between' xx 'and' yy'...'
n = 0
do i = xx to yy
   if flag.i then do
      d = DigitRoot(i)
      if flag.d then do
         n = n+1
         call CharOut ,Right(i'('d')',Length(yy)+4)
         if n//10 = 0 then
            say
       end
   end
end
say
say n 'nice PrimeS found'
say Format(Time('e'),,3) 'seconds'; say
return

include Math
