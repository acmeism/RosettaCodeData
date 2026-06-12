-- 10 Oct 2025
include Setting
numeric digits 100

say 'NUMBERS WHOSE BINARY AND TERNARY DIGIT SUMS ARE PRIME'
say version
say
arg xx
if xx = '' then
   xx = 200
say 'Numbers whose binary and ternary digit sums are prime up to' xx'...'
say
a = 10; b = 3
say Right('Base 10',a) Right('Base 2',a) Right('Sum',b) Right('Base 3',a) Right('Sum',b)
do n = 2 to xx
   b1 = D2b(n); b2 = Digitsum(b1); t1 = D2n(n,3); t2 = Digitsum(t1)
   if Prime(b2) & Prime(t2) then
      say Right(n,a) Right(b1,a) Right(b2,b) Right(t1,a) Right(t2,b)
end
exit

-- D2b, D2n
include Base
-- Prime
include Ntheory
-- Digitsum
include Special
