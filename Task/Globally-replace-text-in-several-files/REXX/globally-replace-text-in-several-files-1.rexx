-- 12 Jul 2026
include Setting

say 'GLOBALLY REPLACE TEXT IN SEVERAL FILES'
say version
say
files='A.txt;B.txt'
repla='Goodbye London!;Hello New York!'
call Testfiles
call Show files,'Original'
call ReplaceTxt files,repla
call Show files,'Updated'
exit

Testfiles:
procedure
a='A.txt'; b='B.txt'
call Stream a,'c','open write replace'
call Stream b,'c','open write replace'
call Lineout a,'The UK is the place to be'
call Lineout a,'but now for the USA'
call Lineout a,'So we say Goodbye London!'
call Lineout b,'Now we say Goodbye London!'
call Lineout b,'We had a wonderful time in the UK'
call Lineout b,'but the USA is our new destination'
call Stream a,'c','close'
call Stream b,'c','close'
return

ReplaceTxt:
procedure
parse arg files,repla
parse var repla fromtxt';'totxt
do while files<>''
   parse var files file';'files
   len=Chars(file)
   call Stream file,'c','open read'
   record=Changestr(fromtxt,Charin(file,,len),totxt)
   call Stream file,'c','close'
   call Stream file,'c','open write replace'
   call Charout file,record
   call Stream file,'c','close'
end
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
