-- 14 Jul 2026
include Setting

say 'WRITE FLOAT ARRAYS TO A TEXT FILE'
say version
say
file='Arrays.txt'
-- Reproduceble output
call Random ,,12345
-- Task
call Generate
call Showarrays
call Writearrays file,3,5
call Showfile file
exit

Generate:
procedure expose stem1. stem2.
-- stem1 random numbers
call MakeSt 'stem1.',10,'r'
-- stem2 corresponding square roots
call CopySt 'stem1.','stem2.'
call MapSt 'stem2.','Sqrt(x)'
return

Showarrays:
procedure expose stem1. stem2.
call ShowSt 'stem1.','random numbers',5,15
say
call ShowSt 'stem2.','square roots',5,15
say
return

Writearrays:
procedure expose stem1. stem2.
parse arg file,first,second
call Stream file,'c','open write replace'
do i=1 to stem1.0
   call Lineout file,Digit(stem1.i,first) Digit(stem2.i,second)
end
call Stream file,'c','close'
return

Showfile:
procedure
parse arg file
say file '10 lines linked values'
call Stream file,'c','open read'
do while Lines(file)
    say Linein(file)
end
call Stream file,'c','close'
return

-- MakeSt CopySt MapSt ShowSt Digit
include Math
