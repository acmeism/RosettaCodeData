-- 1 Jun 2025
include Settings

say 'A+B'
say version
say
do forever
   call Charout, 'REXX '
   pull x
   if x = '' then
      leave
   parse var x a b
   say
   say 'As given...'
   say 'A   =' a
   say 'B   =' b
   say 'A+B =' a+b
   say
   say 'Normalized...'
   say 'A   =' a/1
   say 'B   =' b/1
   say 'A+B =' (a+b)/1
   say
end
exit

include Abend
