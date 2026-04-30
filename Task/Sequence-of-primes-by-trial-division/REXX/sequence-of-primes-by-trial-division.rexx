-- 4 Mar 2026
include Setting
numeric digits 30

say 'SEQUENCE OF PRIMES BY TRIAL DIVISION'
say version
say
call TrialDivision 1,99
call TrialDivision 1e3,1e3+99
call MillerRabin 1e3,1e3+99
call TrialDivision 1e6,1e6+99
call MillerRabin 1e6,1e6+99
call TrialDivision 1e12,1e12+99
call MillerRabin 1e12,1e12+99
call TrialDivision 1e15,1e15+99
call MillerRabin 1e15,1e15+99
call MillerRabin 1e18,1e18+999
call MillerRabin 1e21,1e21+999
exit

TrialDivision:
procedure expose Memo. Glob.
arg xx,yy
say 'Primes between' Std(xx) 'and' Std(yy) 'by trial division...'
n = 0; w = Xpon(yy)+2
do i = xx to yy
   if IsPrime(i) then do
      n = n+1
      call Charout ,Right(i,w)
      if n//5 = 0 then
         say
   end
end
say
say n 'found'
call Timer 'R'
return

MillerRabin:
procedure expose Glob.
arg xx,yy
say 'Primes between' Std(xx) 'and' Std(yy) 'by Miller-Rabin primality test...'
n = 0; w = Xpon(yy)+2
do i = xx to yy
   if Prime(i) then do
      n = n+1
      call Charout ,Right(i,w)
      if n//5 = 0 then
         say
   end
end
say
say n 'found'
call Timer 'R'
return

Isprime:
procedure expose Memo.
arg xx
if xx < 3 then
   return (xx = 2)
if Even(xx) then
   return 0
do i = 3 by 2 to Isqrt(xx)
   if xx//i = 0 then
      return 0
end
return 1

-- Xpon; Std; Prime; Even; Isqrt
include Math
