-- 28 Jul 2025
include Settings
numeric digits 12

say 'CHOWLA NUMBERS'
say version
say
call ChowlaNumbers
call PrimeCount
call PerfectNumbers
exit

ChowlaNumbers:
procedure expose Memo.
call Time('r'); sep = Copies('-',12)
say sep; say ' n Chowla(n)'; say sep
m = 37
do i = 1 to m
   say Right(i,2) Right(Chowla(i),9)
end
say sep
say Format(Time('e'),,3) 'seconds'
say
return

PrimeCount:
procedure expose Memo. work.
call Time('r'); sep = Copies('-',17)
say sep; say Right('n',8) Right('Primes<n',8); say sep
d = 1; work. = 1; m = 1e7; n = 0
do i = 1 by 2 to m+1
   e = Xpon(i)
   if e > d then do
      say Right(10**e,8) Right(n,8)
      d = e
   end
   if work.i = 0 then
      iterate i
   if Chowla(i) = 0 then do
      n = n+1
      if i > 1 then do
         j = i+i
         do while j < m
            work.j = 0; j = j+i
         end
      end
   end
end
say sep
say Format(Time('e'),,3) 'seconds'
say
return

PerfectNumbers:
procedure expose divi.
call Time('r'); sep = Copies('-',12)
say sep; say Right('Perfect',12); say sep
k = 2; kk = 3; m = 140e9; n = 0
do forever
   p = k * kk
   if p > 140e9 then
      leave
   if Chowla(p) = p-1 then do
      n = n+1
      say Right(p,12)
   end
   k = kk+1; kk = kk+k
end
say sep
say n 'perfect numbers found below 140e9'
say Format(Time('e'),,3) 'seconds'
say
return

include Math
