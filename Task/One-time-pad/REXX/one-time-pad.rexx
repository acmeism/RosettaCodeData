-- 16 Jul 2026
include Setting

say 'ONE-TIME PAD'
say version
say
parse arg input encrypt decrypt
key=Left(input,Pos('.',input)-1)'.1tp'
-- For reproducible output
call Random ,,12345
-- Subtasks
call Showtxt input
call Onetimepad input key
call Showhex key
call Encrypt input key encrypt
call Showhex encrypt
call Decrypt encrypt key decrypt
call Showtxt decrypt
exit

Onetimepad:
procedure
parse arg input key
call Stream input,'c','open read'
call Stream key,'c','open write replace'
do Chars(input)
   call Charout key,D2c(Random(0,255))
end
call Stream input,'c','close'
call Stream key,'c','close'
return 0

Encrypt:
procedure
parse arg input key encrypt
call Stream input,'c','open read'
call Stream key,'c','open read'
call Stream encrypt,'c','open write replace'
do Chars(input)
   call Charout encrypt,D2c((C2d(Charin(input))+C2d(Charin(key)))//255)
end
call Stream input,'c','close'
call Stream key,'c','close'
call Stream encrypt,'c','close'
return 0

Decrypt:
procedure
parse arg encrypt key decrypt
call Stream encrypt,'c','open read'
call Stream key,'c','open read'
call Stream decrypt,'c','open write replace'
do Chars(encrypt)
   d=C2d(Charin(encrypt))-C2d(Charin(key))
   if d<0 then
      d+=255
   call Charout decrypt,D2c(d)
end
call Stream encrypt,'c','close'
call Stream key,'c','close'
call Stream decrypt,'c','close'
return 0

Showtxt:
procedure
parse arg file
say 'Contents of text file' file'...'
call Stream file,'c','open read'
do while Lines(file)>0
   say Linein(file)
end
call Stream file,'c','close'
say
return 0

Showhex:
procedure
parse arg file
say 'Contents of hex file' file'...'
call Stream file,'c','open read'
do 20
   call Charout ,C2x(Charin(file))
end
call Stream file,'c','close'
say '...'; say
return 0

include Math
