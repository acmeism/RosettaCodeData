-- 7 Aug 2025
include Settings

say 'ADDRESS OF A VARIABLE'
say version
say
if Pos('Regina',version) > 0 then
   call Library
call Primes 10
call SysDumpVariables
exit

Library:
call RxFuncAdd 'SysLoadFuncs','RegUtil','SysLoadFuncs'
call SysLoadFuncs
return

include Math
