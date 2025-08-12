-- 8 Aug 2025
include Settings

say 'ASSOCIATIVE ARRAY: ITERATION'
say version
say
list=''; arra.=''; w=0
-- States with former capitals: key, name, capital
call SetStateCap 'al','Alabama','Tuscaloosa'
call SetStateCap 'ca','California','Benicia'
call SetStateCap 'co','Colorado','Denver City'
call SetStateCap 'ct','Connecticut','Hartford and New Haven'
call SetStateCap 'de','Delaware','New-Castle'
call SetStateCap 'ga','Georgia','Milledgeville'
call SetStateCap 'il','Illinois','Vandalia'
call SetStateCap 'in','Indiana','Corydon'
call SetStateCap 'ia','Iowa','Iowa City'
call SetStateCap 'la','Louisiana','New Orleans'
call SetStateCap 'me','Maine','Portland'
call SetStateCap 'mi','Michigan','Detroit'
call SetStateCap 'ms','Mississippi','Natchez'
call SetStateCap 'mo','Missouri','Saint Charles'
call SetStateCap 'mt','Montana','Virginia City'
call SetStateCap 'ne','Nebraska','Lancaster'
call SetStateCap 'nh','New Hampshire','Exeter'
call SetStateCap 'ny','New York','New York'
call SetStateCap 'nc','North Carolina','Fayetteville'
call SetStateCap 'oh','Ohio','Chillicothe'
call SetStateCap 'ok','Oklahoma','Guthrie'
call SetStateCap 'pa','Pennsylvania','Lancaster'
call SetStateCap 'sc','South Carolina','Charlestown'
call SetStateCap 'tn','Tennessee','Murfreesboro'
call SetStateCap 'vt','Vermont','Windsor'
arra.0=w
-- Loop through list
say 'Using a list...'
do w = 1 to words(list)
   a=Word(list,w)
   say 'The former capital of' stna.a '('a')' 'was' stca.a
end
say
-- Loop through aux array...'
say 'Using an array...'
do w = 1 to arra.0
   a=arra.w
   say 'The former capital of' stna.a '('a')' 'was' stca.a
end
say
-- Show all vars
say 'Variables...'
if pos('Regina',version) > 0 then
   call Library
call SysDumpVariables
exit

SetStateCap:
parse arg code,name,cap
code=Upper(code)
-- Next row in associative array
stna.code=name; stca.code=cap
-- Track keys in a list
list=list code
-- Track keys in an array
w=w+1; arra.w=code
return

Library:
call RxFuncAdd 'SysLoadFuncs','RegUtil','SysLoadFuncs'
call SysLoadFuncs
return

include Abend
