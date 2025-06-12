-- 8 May 2025
include Settings

say 'RADICAL OF AN INTEGER'
say version
say
arg n
if n = '' then
   n = 1000000
numeric digits 100
say 'Radicals for 1..50...'
ol = ''
do i = 1 to 50
   ol = ol||Right(Radical(i),5)
   if i//10 = 0 then do
      say ol; ol = ''
   end
end
say
say 'Radicals for...'
say '99999  =' Radical(99999)
say '499999 =' Radical(499999)
say '999999 =' Radical(999999)
say
say 'Getting distribution list...'
m = n/10; r = Isqrt(n); radi. = 0
call Time('r')
do i = 1 to n
   call Radical(i)
   u = ufac.0
   radi.u = radi.u+1
   if i//m=0 then do
      ti=(i%m)*10
      say Format(ti,3)'%' Format(Time('e'),4,3) 'seconds'
   end
end
say
say 'Distribution for first' n 'radicals over Number of Factors...'
do i = 0 to 10
   if radi.i > 0 then
      say Right(i,2)':' Right(radi.i,6)
end
say
say 'Getting Primes up to' n'...'
call Time('r')
pr = Primes(n)
say 'Took' Format(Time('e'),,3) 'seconds'
say
say 'Getting powers of Primes up to' r'...'
call Time('r')
pw = 0
do i = 1
   p1 = prim.i
   if p1 > r then
      leave
   p2 = p1
   do forever
      p2 = p2*p1
      if p2 > n then
         leave
      pw = pw+1
   end
end
say 'Took' Format(Time('e'),,3) 'seconds'
say
say 'Primes' Format(pr,6)
say 'Powers' Format(pw,6)
say '        -----'
say 'Total ' Format(pr+pw,6)
exit

include Functions
include Special
include Numbers
include Sequences
include Abend
