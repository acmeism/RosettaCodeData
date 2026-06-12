-- 24 Aug 2025
include Setting

call Time('r')
say 'SUBSTRING PRIMES'
say version
say
call Task
call Stretch
say Format(Time('e'),,3) 'seconds'
exit

Task:
procedure expose test.
say 'Substring primes below' 500'...'
n = 0; test.0 = 0; test.1 = ''
do i = 1 to 500
   if Substring(i) then do
      n = n+1
      call Charout ,i' '
   end
end
say
say n 'found'
say
return

Substring:
procedure expose test.
arg xx
if Verify(xx,014689,'m') > 0 then
   return 0
if xx < 10 then
   return 1
if Verify(Substr(xx,2),25,'m') > 0 then
   return 0
l = Length(xx)
do i = 1 to l-1
   if Substr(xx,i,1) = Substr(xx,i+1,1) then
      return 0
end
do i = 2 to l-1
   do j = i+1 to l
      a = Substr(xx,i,j-1)
      test.0 = test.0+1
      if \ Prime(a) then do
         test.1 = test.1 a
         return 0
      end
   end
end
test.0 = test.0+1
if Prime(xx) then
   return 1
else do
   test.1 = test.1 xx
   return 0
end

Stretch:
procedure expose test.
say 'Tested for primality, but found composite...'
say strip(test.1)
say 'In total' test.0 'primality tests performed'
say
return

include Math
