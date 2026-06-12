-- 23 Aug 2025
include Setting

say 'CUBIC SPECIAL PRIMES'
say version
say
t = 150000; d = Xpon(t)+2; numeric digits d
call Primes t
call ShowCubics t,d
say
say Format(Time('e'),,3) 'seconds'
exit

ShowCubics:
procedure expose prim. flag.
arg x,y
call Charout ,Right(2,y)
a = 2; b = 3; k = 1; n = 1
do while b <= x
   b = a + k*k*k
   if flag.b = 1 then do
      n = n+1
      call Charout ,Right(b,y)
      if n//10 = 0 then
         say
      a = b; k = 1
   end
   k = k+1
end
say; say
say n 'cubic special primes found below' x
return

include Math
