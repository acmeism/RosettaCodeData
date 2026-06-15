-- 12 Jun 2026
include Setting

say 'APERY''S CONSTANT'
say 'Version 1 Three methods, using formulas'
say version
say
arg n; if n = '' then n = 101; numeric digits n
call time('r'); a = Definition(); e = format(time('e'),,3)
say 'Definition' a '('e 'seconds)'
call time('r'); a = Markov(); e = format(time('e'),,3)
say 'Markov    ' a '('e 'seconds)'
call time('r'); a = Wedeniwski(); e = format(time('e'),,3)
say 'Wedeniwski' a '('e 'seconds)'
call time('r'); a = TrueValue(); e = format(time('e'),,3)
say 'True value' a '('e 'seconds)'
exit

Definition:
-- Definition Zeta function
procedure
numeric digits digits()+2
y = 0
do k = 1 to 1000
   y = y + 1/(k**3)
end
numeric digits digits()-2
return y+0

Markov:
-- Markov series
procedure expose Fact.
fact. = 0
numeric digits digits()+2
y = 0
do k = 1 to 158
   y = y + (-1)**(k-1) * Fact(k)**2 / (Fact(2*k)*k**3)
end
y = y*2.5
numeric digits digits()-2
return y+0

Wedeniwski:
-- Wedeniwski series
procedure expose Fact.
fact. = 0
numeric digits Digits()+2
y = 0
do k = 0 to 19
   y = y + ((-1)**k * Fact(2*k+1)**3 * Fact(2*k)**3 * Fact(k)**3,
         * (((((126392*k+412708)*k+531578)*k+336367)*k+104000)*k+12463)),
         / (Fact(3*k+2) * Fact(4*k+3)**3)
end
y = y/24
numeric digits Digits()-2
return y+0

TrueValue:
procedure
return 1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581+0

include Math
