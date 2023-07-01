Numeric digits 1000
Say 'enter some numbers to be summed:'
parse pull y
sum=0
yplus=''
Do i=1 By 1 While y<>''
  Parse Var y n y
  If datatype(n)<>'NUM' Then Do
    Say 'you entered  something that is not recognized to be a number:' n
    Exit
    End
  Select
    When i=1 Then
      yplus=n
    When n>0 Then yplus||='+'abs(n)
    Otherwise yplus||=n
    End
  sum+=n
  End
Say yplus '=' sum/1
Exit
