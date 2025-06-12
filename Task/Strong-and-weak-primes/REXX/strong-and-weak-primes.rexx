-- 12 Apr 2025
include Settings

call Time('r')
say 'STRONG AND WEAK PRIMES'
say version
say
call Primes 1e8
call Task 'Strong',36
call Task 'Weak',37
call Task 'Balanced',30
call Task 'Strong',1e6
call Task 'Weak',1e6
call Task 'Balanced',1e6
call Task 'Strong',1e7
call Task 'Weak',1e7
call Task 'Balanced',1e7
call Task 'Strong',1e8
call Task 'Weak',1e8
call Task 'Balanced',1e8
say Format(Time('e'),,3) 'seconds'
exit

Task:
procedure expose prim. flag.
parse arg xx,yy
v = (yy<1e3)
if v then
   say 'First' yy xx 'primes'
else
   say xx 'primes below' yy
n = 0
do i = 2 to prim.0-1
   if \ v & prim.i > yy then
      leave
   im = i-1; ip = i+1; a = (prim.im+prim.ip)/2
   s = (prim.i > a); t = (prim.i < a); u = (prim.i = a)
   if xx = 'Strong' & s | xx = 'Weak' & t | xx = 'Balanced' & u then do
      n = n+1
      if v then do
         call Charout ,prim.i' '
         if n = yy then
            leave
      end
   end
end
if v then
   say
say n 'found'
say
return

include Sequences
include Functions
include Abend
