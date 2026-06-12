-- 11 Nov 2025
include Setting

say 'COUNT HOW MANY VOWELS AND CONSONANTS OCCUR IN A STRING'
say version
say
call Task 'Now is the time for all good men to come to the aid of their country.'
call Task 'abcde'
call Task 'ABCDE'
call Task '1A3B5'
call Task '12345'
call Task ''
exit

Task:
procedure
parse arg text
txt=Upper(text); vow='AEIOU'; con='BCDFGHJKLMNPQRTSVWXYZ'
v=0; c=0
do i=1 to Length(vow)
   v+=Countstr(Substr(vow,i,1),txt)
end i
do i=1 to Length(con)
   c+=Countstr(Substr(con,i,1),txt)
end i
say 'Text' '"'text'"' 'has' v 'vowels and' c 'consonants'
return

include Abend
