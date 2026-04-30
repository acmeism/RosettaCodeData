Function lcs(string1,string2)
	For i = 1 To Len(string1)
		tlcs = tlcs & Mid(string1,i,1)
		If InStr(string2,tlcs) Then
			If Len(tlcs) > Len(lcs) Then
				lcs = tlcs
			End If
		Else
			tlcs = ""
		End If
	Next
End Function

WScript.Echo lcs(WScript.Arguments(0),WScript.Arguments(1))
