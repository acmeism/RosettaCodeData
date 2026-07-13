-- 12 Jul 2026
include Setting
arg count
if count='' then
   count=1E6
count/=1

say 'WRITE ENTIRE FILE'
say version
say
call Task 'Rosetta.dat',count
call Timer
exit

Task:
procedure
parse arg file,count
text='This text is repeated' count 'times'
data=Copies(text,count)
say 'Writing' file'...'
call Stream file,'c','open write replace'
call Charout file,data
call Stream file,'c','close'
say Round(Length(data)/1038336,3)'MB written'
return

-- Timer Round
include Math
