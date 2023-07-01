function pad(s,n) if n<0 then pad= right(space(-n) & s ,-n) else  pad= left(s& space(n),n) end if
End Function
Sub print(s):
  On Error Resume Next
  WScript.stdout.Write (s)
  If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
End Sub
For i=1 To 12
  print pad(i,-4)
Next
print vbCrLf & String(48,"_")
For i=1 To 12
  print vbCrLf
  For j=1 To 12
    if j<i Then print Space(4) Else  print pad(i*j,-4)
  Next
  print "|"& pad(i,-2)
Next
