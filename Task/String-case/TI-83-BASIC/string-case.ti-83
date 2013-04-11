:"ABCDEFGHIJKLMNOPQRSTUVWXYZ"→Str9
:"abcdefghijklmnopqrstuvwxyz"→Str0
:Input ">",Str1
:":"+Str1+":"→Str1
:Prompt U
:If U:Then
:For(I,2,length(Str1))
:If inString(Str0,sub(Str1,I,1)) and sub(Str1,I,1)≠":"
:sub(Str1,1,I-1)+sub(Str9,inString(Str0,sub(Str1,I,1)),1)+sub(Str1,I+1,length(Str1)-I)→Str1
:End
:Else
:For(I,2,length(Str1))
:If inString(Str9,sub(Str1,I,1)) and sub(Str1,I,1)≠":"
:sub(Str1,1,I-1)+sub(Str0,inString(Str9,sub(Str1,I,1)),1)+sub(Str1,I+1,length(Str1)-I)→Str1
:End
:End
:sub(Str1,2,length(Str1)-2)→Str1
:Pause Str1
