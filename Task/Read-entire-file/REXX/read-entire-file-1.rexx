-- 12 Jul 2026
include Setting

say 'READ ENTIRE FILE'
say version
say
call Task 'Rosetta.dat'
call Timer
exit

Task:
procedure
parse arg file
len=Chars(file)
say 'Reading' file'...'
call Stream file,'c','open read'
data=Charin(file,,len)
call Stream file,'c','close'
say Round(len/1038336,3)'MB read'
say 'First 100 characters are'
say Left(data,100)'...'
return

-- Timer Round
include Math
