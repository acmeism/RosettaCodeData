-- 26 Mar 2025
include Settings
call Time('r')
numeric digits 500

say 'PISANO PERIOD'
say version
say
call GetFibo 1000
call ShowPisanoPrime 15,2
call ShowPisanoPrime 180,1
call ShowPisano 180
say Format(Time('e'),,3) 'seconds'; say
exit

GetFibo:
procedure expose fibo.
arg xx
say 'Get first' xx 'Fibonacci numbers...'
call Fibonaccis -xx
say fibo.0 'numbers found'
say
return

ShowPisanoPrime:
procedure expose fibo. prim.
arg xx,yy
say 'Pisano primes for p^'yy'...'
do i = 1 to xx
   if Prime(i) then
      say 'PisanoPrime('i','yy') = ' Pisanoprime(i,yy)
end
say
return

ShowPisano:
procedure expose fibo. prim.
arg xx
say 'Pisano(n) for n = 1...'xx'...'
do i = 1 to xx
   call Charout ,Right(Pisano(i),5)
   if i//10 = 0 then
      say
end
say
return

Pisanoprime:
procedure expose fibo.
arg xx,yy
return xx**(yy-1)*Pisano(xx)

Pisano:
procedure expose fibo.
arg xx
if xx = 1 then
   return 1
do i = 1
   j = i+1
   if fibo.i//xx = 0 then
      if fibo.j//xx = 1 then
         leave i
end
return i

include Sequences
include Numbers
include Functions
include Constants
include Abend
