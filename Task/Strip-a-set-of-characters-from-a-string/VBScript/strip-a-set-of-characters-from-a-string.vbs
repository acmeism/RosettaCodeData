Function stripchars(s1,s2)
	For i = 1 To Len(s1)
		If InStr(s2,Mid(s1,i,1)) Then
			s1 = Replace(s1,Mid(s1,i,1),"")
		End If
	Next
	stripchars = s1
End Function

WScript.StdOut.Write stripchars("She was a soul stripper. She took my heart!","aei")
