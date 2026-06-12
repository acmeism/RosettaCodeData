-- 24 Aug 2025
include Setting
numeric digits 30

call Time('r')
say 'PRIMES WITH DIGITS IN NONDECREASING ORDER'
say version
say
call Task
say Format(Time('e'),,3) 'seconds'
exit

Task:
procedure
arg xx,yy
say 'Primes below 1000 with nondecreasing digits...'
n = 0
do i = 1 to 1000
   do j = 1 to Length(i)-1
      if Substr(i,j,1) > Substr(i,j+1,1) then
         iterate i
   end
   if Prime(i) then do
      n = n+1
      call Charout ,right(i,4)
      if n//10 = 0 then
         say
   end
end
say n 'such primes'
say
return

include Math
