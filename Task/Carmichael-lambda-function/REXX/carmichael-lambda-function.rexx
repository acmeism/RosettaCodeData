-- 23 Aug 2025
include Setting

say 'CARMICHAEL LAMBDA FUNCTION'
say version
say
numeric digits 10
arg n
if n = '' then
   n = 25
call Time 'r'
say '----------'
say ' n   l   k'
say '----------'
do i = 1 to n
   k = 1; a = Lambdan(i); b = a
   do while b > 1
      k = k+1; b = Lambdan(b)
   end
   say Right(i,2) Right(a,3) Right(k,3)
end
say '----------'
say Format(Time('e'),,3) 'seconds'
say

say '----------'
say ' k       n'
say '----------'
call Time 'r'
a = 1
do i = 1 to 15
   do j = a until k = i
      k = 0; b = j
      do until b = 1
         k = k+1; b = Lambdan(b)
      end
   end
   say Right(k,2) Right(j,7)
   a = j+1
end
say '----------'
say Format(Time('e'),,3) 'seconds'
exit

include Math
