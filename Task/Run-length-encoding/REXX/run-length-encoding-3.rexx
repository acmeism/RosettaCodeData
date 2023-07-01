/*REXX*/
s='WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'
Say '  s='s
enc=encode(s)
Say 'enc='enc
dec=decode(enc)
Say 'dec='dec
if dec==s Then Say 'OK'
Exit

encode: Procedure
Parse Arg s
c=left(s,1)
cnt=1
ol=''
Do i=2 To length(s)
  If substr(s,i,1)=c Then
    cnt=cnt+1
  Else Do
    If cnt=1 Then
      Call o c
    Else
      Call o cnt||c
    c=substr(s,i,1)
    cnt=1
    End
  End
Call o cnt||c
Return ol

decode: Procedure
Parse Arg s
abc='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
ol=''
Do While s<>''
  p=verify(s,abc,'M')
  If pos(left(s,1),abc)>0 Then Do
    Parse Var s c +1 s
    Call o c
    End
  Else Do
    Parse Var s cnt =(p) c +1 s
    Call o copies(c,cnt)
    End
  End
Return ol

o: ol=ol||arg(1)
   Return
