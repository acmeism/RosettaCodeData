-- 26 Mar 2025
include Settings
numeric digits 10

say 'PRIMALITY BY WILSON''S THEOREM'
say version
say
call ShowWilson 1,660
call ShowWilson 7901,8269
do i = 3 to 6
   a = 1'E'i; a = a+1; b = a+999
   call CompareWilsonMR a,b
end
exit

ShowWilson:
procedure expose glob.
arg xx,yy
call Time('r')
say 'Primes between' Std(xx) 'and' Std(yy)
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

CompareWilsonMR:
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
say 'For n between' Right(Std(xx),7) 'and' Right(Std(yy),7),
'Wilson took' Format(e1,3,3)'s and Miller-Rabin' Format(e2,3,3)'s'
return

Isprime:
procedure expose glob.
arg xx
if xx < 2 then
   return 0
if xx = 2 then
   return 1
if Even(xx) then
   return 0
f = 1; x1 = xx-1
do i = 2 to x1
   f = (f*i)//xx
end
if f = x1 then
   return 1
else
   return 0

include Sequences
include Numbers
include Functions
include Constants
include Abend
