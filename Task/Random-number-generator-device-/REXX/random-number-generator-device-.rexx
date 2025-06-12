-- 8 May 2025
include Settings
numeric digits 12

say 'RANDOM NUMBER GENERATOR (DEVICE)'
say version
say
call ShowSeed
call Examples
call Timer
exit

ShowSeed:
procedure
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
procedure expose glob.
say 'Randu()       = ' Right(Randu(),14) 'Real, uniform distributed over (0,1)'
say 'Randu(100)    = ' Right(Randu(100),14)  'Integer, between 0 and 100'
say 'Randu(-10,10) = ' Right(Randu(-10,10),14)  'Integer, between -10 and 10'
say 'Randn()       = ' Right(Randn(),14)  'Real, normal distributed, average 0 and deviation 1'
say
return

include Functions
include Constants
include Helper
include Abend
