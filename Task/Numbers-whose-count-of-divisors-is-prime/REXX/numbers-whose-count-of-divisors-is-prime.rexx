-- 23 Aug 2025
include Setting
numeric digits 10

say 'COUNT OF DIVISORS IS PRIME'
say version
say
arg xx
if xx = '' then
   xx = 1e5
interpret 'xx =' xx'+0'
say 'Numbers whose count of divisors is prime up to' xx'...'
p = 4; n = 0
do i = 3 until p >= xx
   c = Divisors(p)
   if c > 2 & Prime(c) then do
      n = n+1
      if xx <= 1e5 then do
         call Charout ,Right(p,6)
         if n//10 = 0 then
            say
      end
   end
   p = i*i
end
say
say n 'such numbers found'
say Format(Time('e'),,3) 'seconds'
exit

include Math
