Function StripCtrlCodes(s)
	tmp = ""
	For i = 1 To Len(s)
		n = Asc(Mid(s,i,1))
		If (n >= 32 And n <= 126) Or n >=128 Then
			tmp = tmp & Mid(s,i,1)
		End If
	Next
	StripCtrlCodes = tmp	
End Function

Function StripCtrlCodesExtChrs(s)
	tmp = ""
	For i = 1 To Len(s)
		n = Asc(Mid(s,i,1))
		If n >= 32 And n <= 126 Then
			tmp = tmp & Mid(s,i,1)
		End If
	Next
	StripCtrlCodesExtChrs = tmp	
End Function

WScript.StdOut.Write "ab�cd�ef�gh€" & " = " & StripCtrlCodes("ab�cd�ef�gh€")
WScript.StdOut.WriteLine
WScript.StdOut.Write "ab�cd�ef�ghij†klð€" & " = " & StripCtrlCodesExtChrs("ab�cd�ef�ghij†klð€")
WScript.StdOut.WriteLine
