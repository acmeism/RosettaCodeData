-- 12 Apr 2025
include Settings
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
procedure
arg xx,yy
call Time('r')
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
say Format(Time('e'),,3) 'seconds'
say
return

MillerRabin:
procedure
arg xx,yy
call Time('r')
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
say Format(Time('e'),,3) 'seconds'
say
return

Isprime:
procedure
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

include Sequences
include Numbers
include Functions
include Constants
include Abend
