-- 13 Jun 2026
include Setting
numeric digits 100
arg xx
if xx='' then
   xx=1234
else
   xx/=1

say 'NON-DECIMAL RADICES CONVERT'
say version
say
do n = 2 to 36
   say xx 'decimal =' D2n(xx,n) 'base' n '=' N2d(D2n(xx,n),n) 'decimal'
end
exit

N2d:
-- Convert base n to base 10
procedure
arg xx,yy
b=XRange('0','9')XRange('A','Z')
l=Length(xx); rr=0
do i=1 to l
   d=Pos(SubStr(xx,i,1),b)-1; rr=rr*yy+d
end i
return rr

D2n:
-- Convert base 10 to base n
procedure
arg xx,yy
b=XRange('0','9')XRange('A','Z')
rr=''
do while xx>0
   r=xx//yy; xx=xx%yy; rr=SubStr(b,r+1,1)rr
end
return rr

-- N2d, D2n (full versions support up to base62, negatives and fractions)
include Math
