Parse Version v; Say v
Parse Source s; Say s
Call time  'R'
ol=''
do n=1 To 70
  k=n
  Do i=1 By 1 while digitsum(k)<>n
    k+=n
    End
  ol=ol||right(i,8)' '
  If n//10=0 Then Do
    Say ol
    ol=''
    End
  End
Say time('E') 'seconds'
Exit
digitsum:
Parse Arg s
sum=0
Do while s<>''
  Parse Var s c +1 s
  sum+=c
  End
Return sum
