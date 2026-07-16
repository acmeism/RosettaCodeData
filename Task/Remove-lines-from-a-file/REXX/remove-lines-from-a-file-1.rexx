-- 14 Jul 2026
include Setting

say 'REMOVE LINE FROM A FILE'
say version
say
parse arg file first last
first/=1; last/=1
say file 'before removals...'
'type' file; say
call Remove file,first,last
say file 'after removals...'
'type' file
exit

Remove:
procedure
arg file,first,last
temp='Temp.txt'; n=0
call Stream file,'c','open read'
call Stream temp,'c','open write replace'
do while Lines(file)
   line=Linein(file); n+=1
   if n<first | n>last then
      call Lineout temp,line
end
call Stream file,'c','close'
call Stream temp,'c','close'
if n<last then do
   say 'Not all lines in range are found'
   say 'File' file 'is not changed'
   'erase' temp
end
else do
   'erase' file
   'rename' temp file
end
return 0
exit

include Math
