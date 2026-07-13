-- 12 Jul 2026
include Setting

say 'FILE INPUT/OUTPUT'
say version
say
in='Input.txt'; out='Output.txt'
call UseLines in,out
call Timer 'r','lines'
call UseChunks in,out
call Timer 'r','chunks'
call UseFile in,out
call Timer 'r','file'
exit

UseLines:
-- Read/write a text file line by line
-- Suitable for text files of any size, but slow
procedure
parse arg in,out
call Stream in,'c','open read'
call Stream out,'c','open write replace'
do while Lines(in)
   record=Linein(in)
   call Lineout out,record
end
call Stream in,'c','close'
call Stream out,'c','close'
return

UseChunks:
-- Read/write a file in chunks of a given size (here almost 1KB)
-- Suitable for files of any size, is fast
procedure
parse arg in,out
len=Chars(in); chunk=1E3
call Stream in,'c','open read'
call Stream out,'c','open write replace'
do while len>0
   record=Charin(in,,Min(chunk,len))
   len-=chunk
end
call Stream in,'c','close'
call Stream out,'c','close'
return

UseFile:
-- Read/write a file in one go
-- Suitable for files up to about 1GB, is very fast
procedure
parse arg in,out
len=Chars(in)
call Stream in,'c','open read'
call Stream out,'c','open write replace'
record=Charin(in,,len)
call Charout out,record
call Stream in,'c','close'
call Stream out,'c','close'
return

-- Timer
include Math
