include Settings

say version; say 'Digital root'; say
numeric digits 30
say Show(0)
say Show(9)
say Show(10)
say Show(19)
say Show(199)
say Show(679)
say Show(6788)
say Show(39390)
say Show(588225)
say Show(2677889)
say Show(393900588225)
say Show(19999999999999999999999)
say Format(Time('e'),,3) 'seconds'
exit

Show:
arg x
return 'Number:' x 'Digital root:' Digitroot(x) 'Additive persistence:' Persistence(x)

Digitroot:
/* Digital root function */
procedure expose glob.
arg x
/* Formula */
return 1+(x-1)//9

Persistence:
/* Additive persistence function */
procedure expose glob.
arg x
/* Fast value */
if x < 10 then
   return 0
/* Cf definition */
do y = 1 until x < 10
   x = Digitsum(x)
end
return y

Digitsum:
/* Digitsum function = sum(digits) */
procedure expose glob.
arg x
/* Sum digits */
y = 0
do n = 1 to Length(x)
   y = y+Substr(x,n,1)
end
return y

include Functions
include Numbers
include Abend
