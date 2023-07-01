fid='pgm.rex'
cnt.=0
funl=''
Do While lines(fid)>0
  l=linein(fid)
  Do Until p=0
    p=pos('(',l)
    If p>0 Then Do
      do i=p-1 To 1 By -1 While is_tc(substr(l,i,1))
        End
      fn=substr(l,i+1,p-i-1)
      If fn<>'' Then
        Call store fn
      l=substr(l,p+1)
      End
    End
  End
Do While funl<>''
  Parse Var funl fn funl
  Say right(cnt.fn,3) fn
  End
Exit
x=a(3)+bbbbb(5,c(555))
special=date('S') 'DATE'() "date"()
is_tc:
abc='abcdefghijklmnopqrstuvwxyz'
Return pos(arg(1),abc||translate(abc)'1234567890_''"')>0

store:
Parse Arg fun
cnt.fun=cnt.fun+1
If cnt.fun=1 Then
  funl=funl fun
Return
