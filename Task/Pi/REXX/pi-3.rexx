-- 12 Sep 2025
include Setting
signal on halt
parse arg digs','slice
if digs = '' then
   digs=1000
if slice = '' then
   slice=1

say 'PI - Chudnovsky or AGM repeated pi calculation (in' 1000%slice 'slices)'
say version
say
do i = 1 to digs+1
   if i//slice = 0 then do
      numeric digits i+2; call CharOut ,SubStr(Pi(),i-slice+1,slice)
   end
end
say
say 'Specified' digs 'digits exhausted.'
call Timer
exit

Halt:
say
say 'Halted because of Ctrl-Break.'
call Timer
exit

include Math
