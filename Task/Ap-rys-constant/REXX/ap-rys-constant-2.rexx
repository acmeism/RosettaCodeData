-- 23 Aug 2025
include Setting

say 'APERY''S CONSTANT'
say 'Version 2 Wedeniwski factorials replaced by recurring values'
say version
say
arg n; if n = '' then n = 101; numeric digits n
call time('r'); a = Wedeniwski(); e = format(time('e'),,3)
say 'Wedeniwski' a '('e 'seconds)'
call time('r'); a = TrueValue(); e = format(time('e'),,3)
say 'True value' a '('e 'seconds)'
exit

Wedeniwski:
-- Wedeniwski series
procedure
numeric digits Digits()+2
-- Term for k = 0
f10 = 1; f20 = 1; f21 = 1; f32 = 2; f43 = 6; f00 = 12463; s = 1; y = 0
do k = 1 to 20
-- Add term to series
   y = y + s * ((f10*f20*f21)**3*f00) / (f32*f43**3)
-- Prepare next term
   k2 = k+k; k3 = k2+k; k4 = k3+k
-- Recurring factorials
   f10 = f10 * k
   f20 = f20 * k2 * (k2-1)
   f21 = f21 * k2 * (k2+1)
   f32 = f32 * k3 * (k3+1) * (k3+2)
   f43 = f43 * k4 * (k4+1) * (k4+2) * (k4+3)
-- Polynomial
   f00 = ((((126392*k+412708)*k+531578)*k+336367)*k+104000)*k+12463
-- Change sign
   s = -s
end
y = y/24
numeric digits Digits()-2
return y+0

TrueValue:
procedure
return 1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581+0

include Abend
