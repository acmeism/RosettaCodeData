include Settings

say version; say 'Amicable pairs'; say
arg n
numeric digits 16
if n = '' then
   n = 20000
show = (n > 0); n = Abs(n)
/* Get amicable pairs */
a = Amicables(n)
say time('e') a 'amicable pairs collected'
/* Show amical pairs */
if show then do
   do i = 1 to a
      say time('e') amic.amicable.1.i 'and' amic.amicable.2.i 'are an amicable pair'
   end
end
say time('e') 'seconds'
exit

Amicables:
/* Amicable number pairs */
procedure expose glob. amic.
arg x
/* Init */
amic. = 0
/* Scan for amicable pairs */
n = 0
do i = 1 to x
   s = Sigma(i)-i; glob.sigma.i = s
   if i = glob.sigma.s then do
      if s = i then
         iterate
      n = n+1
      amic.amicable.1.n = s; amic.amicable.2.n = i
   end
end
amic.0 = n
return n

include Numbers
include Functions
include Abend
