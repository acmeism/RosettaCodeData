include Settings

say version; say 'Carmichael 3 strong primes'; say
arg n
numeric digits 16
if n = '' then
   n = 61
show = (n > 0); n = Abs(n)
c = Carmichaels(n)
if show then do
   do i = 1 to capr.0
      say capr.prime1.i 'x' capr.prime2.i 'x' capr.prime3.i '=',
          capr.prime1.i * capr.prime2.i * capr.prime3.i
   end
end
say c 'Carmichael numbers found up to first prime' n
say time('e') 'seconds'
exit

Carmichaels:
/* Carmichael 3 strong prime numbers */
procedure expose capr.
parse arg x
n = 0
do p1 = 3 by 2 to x
/* Method Janeson */
   if \ IsPrime(p1) then
      iterate p1
   pm = p1-1; ps = -p1*p1
   do h3 = 1 to pm
      t1 = (h3+p1) * pm; t2 = ps//h3
      if t2 < 0 then
         t2 = t2+h3
      do d = 1 to h3+pm
         if t1//d <> 0 then
            iterate d
         if t2 <> d//h3 then
            iterate d
         p2 = 1+t1%d
         if \ IsPrime(p2) then
            iterate d
         p3 = 1+(p1*p2%h3)
         if \ IsPrime(p3) then
            iterate d
         if (p2*p3)//pm <> 1 then
            iterate d
/* Save results */
         n = n+1
         capr.prime1.n = p1; capr.prime2.n = p2; capr.prime3.n = p3
      end d
   end h3
end
capr.0 = n
/* Return count */
return n

include Numbers
include Functions
include Abend
