-- 8 May 2025
include Settings
numeric digits 40

say 'SQUARE FORM FACTORIZATION'
say version
say
call TestNumbers
call Selected
call Randomized
exit

TestNumbers:
procedure expose test.
t = '2501 12851 13289 75301 120787 967009 997417 7091569 13290059',
    '42854447 223553581 2027651281 11111111111 100895598169 1002742628021',
    '60012462237239 287129523414791 9007199254740931 11111111111111111',
    '314159265358979323 384307168202281507 419244183493398773',
    '658812288346769681 922337203685477563 1000000000000000127',
    '1152921505680588799 1537228672809128917 4611686018427387877'
do i = 1 to Words(t)
   test.i = Word(t,i)
end
test.0 = i-1
return

Selected:
procedure expose mult. test. glob.
call Time('r')
say 'Find a factor for 28 selected numbers...'
do t = 1 for test.0
   n = test.t
   call Time('r')
   f = Squfof(n)
   if f = 0 then
      u = 'failed'
   else
      u = f 'x' n/f
   say Format(Time('e'),3,3)'s Squfof ' n '('Xpon(n)+1 'digits) =' u
   call Time('r')
   f = Pollardrho(n)
   if f = 0 then
      u = 'failed'
   else
      u = f 'x' n/f
   say Format(Time('e'),3,3)'s Pollard' n '('Xpon(n)+1 'digits) =' u
   if n < 1e17 then do
      call Time('r')
      f = Trialdiv(n); u = f 'x' n/f
      say Format(Time('e'),3,3)'s Trial  ' n '('Xpon(n)+1 'digits) =' u
   end
   say
end
say
return

Randomized:
procedure expose mult. glob.
say 'Find a factor for 28 random numbers...'
x = 0
do until x = 28
   n = (Right(Randu(),Randu(1,10))||Right(Randu(),Randu(1,10))||Right(Randu(),Randu(1,10)))/1
   if Pos(Right(n,1),05) > 0 | Even(n) | Digitsum(n)//3 = 0 then
      iterate
   call Time('r')
   f = Squfof(n)
   if f = 0 then
      u = 'failed'
   else
      u = f 'x' n/f
   say Format(Time('e'),3,3)'s Squfof ' n '('Xpon(n)+1 'digits) =' u
   if n < 1e24 then do
      call Time('r')
      f = Pollardrho(n)
      if f = 0 then
         u = 'failed'
      else
         u = f 'x' n/f
      say Format(Time('e'),3,3)'s Pollard' n '('Xpon(n)+1 'digits) =' u
   end
   if n < 1e17 then do
      call Time('r')
      f = Trialdiv(n); u = f 'x' n/f
      say Format(Time('e'),3,3)'s Trial  ' n '('Xpon(n)+1 'digits) =' u
   end
   say
   x = x+1
end
say
return

include Numbers
include Functions
include Abend
