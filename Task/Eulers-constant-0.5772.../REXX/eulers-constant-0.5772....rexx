-- 28 Jul 2025
include Settings

say 'EULER-MASCHERONI CONSTANT'
say 'Method Brent-McMillan'
say version
say
arg n; if n = '' then n = 100; numeric digits n
call time('r'); a = Brent(); e = format(time('e'),,3)
say 'Brent     ' a '('e 'seconds)'
call time('r'); a = TrueValue(); e = format(time('e'),,3)
say 'True value' a '('e 'seconds)'
exit

Brent:
procedure expose fact. Memo. work.
numeric digits Digits()+2
-- Brent McMillan
n = Ceil((Digits()*Ln(10)+Ln(Pi()))*0.25); m = Ceil(2.07*Digits())
n2 = n*n; ak = -Ln(n); bk = 1; s = ak; v = 1
do k = 1 to m
   bk = bk*n2/(k*k); ak = (ak*n2/k+bk)/k
   s = s+ak; v = v+bk
end
y = s/v
numeric digits Digits()-2
return y+0

TrueValue:
procedure
return 0.5772156649015328606065120900824024310421593359399235988057672348848677267776646709369470632917467495+0

include Math
