Function CountSubstring(str,substr)
	CountSubstring = 0
	For i = 1 To Len(str)
		If Len(str) >= Len(substr) Then
			If InStr(i,str,substr) Then
				CountSubstring = CountSubstring + 1
				i = InStr(i,str,substr) + Len(substr) - 1
			End If
		Else
			Exit For
		End If
	Next
End Function

WScript.StdOut.Write CountSubstring("the three truths","th") & vbCrLf
WScript.StdOut.Write CountSubstring("ababababab","abab") & vbCrLf
