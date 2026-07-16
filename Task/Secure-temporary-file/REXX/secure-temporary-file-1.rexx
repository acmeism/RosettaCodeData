-- 14 Jul 2026
include Setting

say 'SECURE TEMPORARY FILE'
say version
say
file='File.txt'
call Stream file,'c','open write replace'
call Lineout file,'Rexx tries to create'
call Lineout file,'this temporary file'
call Lineout file,'securely and exclusively.'
call Stream file,'c','close'
say file 'created'
exit

include Math
