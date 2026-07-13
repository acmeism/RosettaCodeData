-- 12 Jul 2026
include Setting

say 'MAKE A BACKUP FILE'
say version
say
file='A.txt'
call Create file
call Show file,'Original'
back=Newname(file)
call Backup file,back
call Show back,'Backup'
call Update file
call Show file,'Updated'
exit

Create:
procedure
parse arg file
call Stream file,'c','open write replace'
call Lineout file,'This is the original file.'
call Lineout file,'Since it will be overwritten,'
call Lineout file,'it must be backup up.'
call Stream file,'c','close'
return

Newname:
procedure
parse arg file
parse var file prefix'.'suffix
return prefix'.bak'

Backup:
procedure
parse arg file,back
call Stream file,'c','open read'
call Stream back,'c','open write replace'
call Charout back,Charin(file,,Chars(file))
call Stream file,'c','close'
call Stream back,'c','close'
return

Update:
procedure
parse arg file
call Stream file,'c','open write replace'
call Lineout file,'Overwritten!'
call Stream file,'c','close'
return

Show:
procedure
parse arg files,text
do while files<>''
   parse var files file';'files
   say text file
   call Stream file,'c','open read'
   do while Lines(file)
      say Linein(file)
   end
   call Stream file,'c','close'
   say
end
return

include Math
