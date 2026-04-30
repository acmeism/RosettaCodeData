-- 21 Feb 2026
include Setting

say 'CALL A FUNCTION IN A SHARED LIBRARY'
say version
say 'Dump the variable pool'
say
if Glob.Regina | Glob.ooRexx then
   call SysDumpVariables
else
   say 'Sorry! Not supported for your interpreter.'
exit

include Math
