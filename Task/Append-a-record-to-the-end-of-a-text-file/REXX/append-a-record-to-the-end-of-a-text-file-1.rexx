-- 12 Jul 2026
include Setting

say 'APPEND A RECORD TO THE END OF A TEXT FILE'
say version
say
file='Passwd.txt'
call Create file
say 'Original file...'
call Show file
call Append file
say 'Appended file...'
call Show file
exit

Create:
parse arg file
call Stream file,'c','open write replace'
line='jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash'
call Lineout file,line
line='jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash'
call Lineout file,line
call Stream file,'c','close'
return

Append:
parse arg file
call Stream file,'c','open write append'
line='xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash'
call Lineout file,line
call Stream file,'c','close'
return

Show:
parse arg file
call Stream file,'c','open read'
do while lines(file)
   say Linein(file)
end
call Stream file,'c','close'
say
return

include Math
