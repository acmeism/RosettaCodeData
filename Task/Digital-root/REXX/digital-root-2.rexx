-- 8 May 2025
include Settings

say 'DIGITAL ROOT'
say version
say
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

include Functions
include Special
include Numbers
include Abend
