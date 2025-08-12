-- 8 Aug 2025
include Settings

say 'ASSOCIATIVE ARRAY: CREATION'
say version
say
say 'Basic examples...'
cap.='Unknown'
cap.be='Brussels'
cap.fr='Paris'
cap.uk='London'
call Capital 'BE'
call Capital 'UK'
call Capital 'NO'
day.='Unknown'; week.=day.
day.jan.2=2; week.jan.2=1
day.mar.17=76; week.mar.17=12
day.aug.7=219; week.aug.7=32
call Calendar 'JAN',2
call Calendar 'AUG',7
call Calendar 'MAY',16
say
say 'Keys can have any value...'
a.cat='civet'; say 'a.cat =' a.cat
a1='dog'; a.a1='pitbull'
a2=a1; say 'a.'a2 '=' a.a2
a1='x.y.z'; a.a1='periods'
a2=a1; say 'a.'a2 '=' a.a2
a1='x y z'; a.a1='spaces'
a2=a1; say 'a.'a2 '=' a.a2
a1='ÀÁÂÃÄÅ'; a.a1='special characters'
a2=a1; say 'a.'a2 '=' a.a2
say
if Pos('Regina',version) > 0 then
   call Library
call SysDumpVariables
exit

Capital:
arg country
say 'The capital of' country 'is' cap.country
return

Calendar:
arg mm,dd
say mm dd 'is day no' day.mm.dd 'and week no' week.mm.dd
return

Library:
call RxFuncAdd 'SysLoadFuncs','RegUtil','SysLoadFuncs'
call SysLoadFuncs
return

include Abend
