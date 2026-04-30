-- 25 Apr 2026
include Setting
numeric digits 12

say 'RANDOM NUMBER GENERATOR (DEVICE)'
say version
say
call ShowSeed
call Examples
exit

ShowSeed:
procedure
-- Courtesy Walter Pachl:
-- Function Rand in module Randoms uses a oneliner with Translate
say 'Datetime =' Date('s')||Time('l')
say 'Extract  =' '  AABBCCDD EE FF GHI'
d = Date('s')
a = SubStr(d,3,2); b = SubStr(d,5,2); c = SubStr(d,7,2)
t = Time('l')
d = SubStr(t,1,2); e = SubStr(t,4,2); f = SubStr(t,7,2)
g = SubStr(t,10,1); h = SubStr(t,11,1); i = SubStr(t,12,1)
say 'Seed     =' h||f||d||b||a||c||e||g||i '= HFFDDBBAACCEEGI'
say
return

Examples:
procedure expose Memo.
-- Reset seed
call Rand(12345)
-- Real uniform distributed
say 'Rand5()       = ' Right(Rand5(),14)  '5-digit between 0 and 1'
say 'Rand12()      = ' Right(Rand12(),14)  '12-digit between 0 and 1'
-- Integer uniform distributed
say 'Rand()        = ' Right(Rand(),14) 'Between 0 and 1E12-1'
say 'Randu(10)     = ' Right(Randu(10),14)  'Between 0 and 10'
say 'Randu(-10,10) = ' Right(Randu(-10,10),14)  'Between -10 and 10'
-- Real normal distributed
say 'Randn(5,2)    = ' Right(Randn(5,2),14)  'Average 5 and deviation 2'
say
return

-- Rand; Rand5; Rand12; Randu; Randn
include Math
