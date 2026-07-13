-- 13 Jul 2026
include Setting

say 'READ A FILE LINE BY LINE'
say version
say
parse arg file
say 'Read and display' file'...'
call Stream file,'c','open read'
do while Lines(file)
   say Linein(file)
end
call Stream file,'c','close'
exit

include Math
