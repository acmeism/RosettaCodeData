-- 21 Feb 2026
include Setting
numeric digits 12

say 'CHOWLA NUMBERS'
say version
say
call ChowlaNumbers
call Timer 'R'
call PrimeCount
call Timer 'R'
call PerfectNumbers
call Timer 'R'
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
return

PrimeCount:
procedure expose Memo. work.
sep = Copies('-',17)
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
return

PerfectNumbers:
procedure expose Divi. Memo.
sep = Copies('-',12)
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
return

-- Chowla; Xpon; Timer
include Math
