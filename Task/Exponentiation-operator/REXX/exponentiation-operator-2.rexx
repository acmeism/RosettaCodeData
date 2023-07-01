pp: Procedure
Parse Arg x,y
If x=0 & y<0 Then call errMsg x"**" y "is invalid"
yp=abs(y)
p.1=x
x.1=1
i=1
Do k=2 By 1 While i<=yp%2
  i=2*i
  kk=k-1
  p.k=p.kk*p.kk
  x.k=i
  /* Say k i x.k p.k */
  End
pp=1
Do i=k-1 To 1 By -1
  If x.i<=yp Then Do
    pp=pp*p.i
    yp=yp-x.i
    End
  End
If y<0 Then
  pp=1/pp
Return pp
