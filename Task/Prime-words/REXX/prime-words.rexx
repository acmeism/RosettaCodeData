-- 24 Aug 2025
include Setting
numeric digits 10

say 'PRIME WORDS'
say version
say
call ShowWords
exit

ShowWords:
call Time('r')
dict = 'UnixDict.txt'
say 'Prime words in' dict'...'
n = 0
do r = 1 while Lines(dict) > 0
   l = Linein(dict)
   do i = 1 to Length(l)
      if \ Prime(C2d(Substr(l,i,1))) then
         iterate r
   end
   n = n+1
   call Charout ,Left(l,10)
   if n//10 = 0 then
      say
end
say
say r-1 'lines read'
say n 'prime words found'
say Format(Time('e'),,3) 'seconds'; say
return

include Math
