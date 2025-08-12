-- 28 Jul 2025
include Settings
numeric digits 15

say 'PRIMALITY BY TRIAL DIVISION'
say version
say
call ShowTrial 1,100
call ShowMR 1,100
do i = 3 to 13
   a = 1'E'i; a = a+1; b = a+999
   call CompareTrialMR a,b
end
exit

ShowTrial:
procedure
arg xx,yy,zz
call Time('r')
say 'Primes between' std(xx) 'and' std(yy) 'by trial division'
n = 0; w = Xpon(yy)+2
do i = xx to yy
   if Isprime(i) then do
      n = n+1
      call Charout ,Right(i,w)
      if n//10 = 0 then
         say
   end
end
say
say n 'primes found'
say Format(Time('e'),,3) 'seconds'; say
return

ShowMR:
procedure
arg xx,yy,zz
call Time('r')
say 'Primes between' std(xx) 'and' std(yy) 'by Miller-Rabin'
n = 0; w = Xpon(yy)+2
do i = xx to yy
   if Prime(i) then do
      n = n+1
      call Charout ,Right(i,w)
      if n//10 = 0 then
         say
   end
end
say
say n 'primes found'
say Format(Time('e'),,3) 'seconds'; say
return

CompareTrialMR:
procedure
arg xx,yy
call Time('r')
do i = xx to yy
   call Isprime i
end
e1 = Time('e')
call Time('r')
do i = xx to yy
   call Prime i
end
e2 = Time('e')
say 'For n between' Right(Std(xx),14) 'and' Right(Std(yy),14),
'trial division took' Format(e1,2,3)'s and Miller-Rabin' Format(e2,2,3)'s'
return

Isprime:
procedure
arg xx
if xx < 2 then
   return 0
if xx = 2 then
   return 1
if Even(xx) then
   return 0
do i = 3 by 2 to Isqrt(xx)
   if xx//i = 0 then
      return 0
end
return 1

include Math
