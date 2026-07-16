-- 14 Jul 2026
include Setting

say 'READ A SPECIFIC LINE FROM A FILE'
say version
say
parse arg file n
n/=1

say 'Generate test file...'
call Stream file,'c','open write replace'
do i=1 to 1000000
   call Lineout file,'Record' i
end
call Stream file,'c','close'
call Timer 'r'

call Stream file,'c','open read'
say 'Position' file 'at line' n-1'...'
call Linein file,n-1
call Timer 'r'

say 'Read and display' file 'line' n'...'
if Lines(file) then
   say Linein(file,n)
else
   say 'Record does not exist'
call Stream file,'c','close'
call Timer 'r'

'erase' file
exit

include Math
