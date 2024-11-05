include Settings

say version; say 'Anti-prims'; say
arg n
numeric digits 16
if n = '' then
   n = 10000
show = (n > 0); n = Abs(n)
h = Highcomposites(n)
say h 'anti-primes found below' n
if show then do
   do i = 1 to high.0
      say i high.highcomposite.i
   end
end
say time('e') 'seconds'
exit

Highcomposites:
/* Highly composite sequence */
procedure expose high.
arg x
/* Thresholds and increments */
a = '1 2 6 60 840 55440 720720 61261200 2327925600 321253732800 9999999999999'
b = '1 2 6 60 420 27720 360360 12252240 232792560  80313433200  9999999999999'
c = Words(a)-1; m = 0; n = 0
/* Colllect cf definition */
do i = 1 to c
   do j = Word(a,i) by Word(b,i) to Min(x,Word(a,i+1)-1)
      d = Divisors(j)
      if d > m then do
         n = n+1; high.highcomposite.n = j
         m = d
      end
   end
end
high.0 = n
/* Return count */
return n

include Numbers
include Functions
include Sequences
include Abend
