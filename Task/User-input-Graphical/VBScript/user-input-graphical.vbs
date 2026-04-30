strUserIn = InputBox("Enter Data")
Wscript.Echo strUserIn
On Error Resume Next
If CLng(InputBox("Input integer 75000")) <> 75000 Then
  WScript.Echo "Input is not 75000"
Else
  WScript.Echo "Input is 75000"
End If
