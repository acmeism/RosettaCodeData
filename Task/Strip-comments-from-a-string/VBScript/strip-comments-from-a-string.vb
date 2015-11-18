Function strip_comments(s,char)
	If InStr(1,s,char) > 0 Then
		arr = Split(s,char)
		strip_comments = RTrim(arr(0))
	Else
		strip_comments = s
	End If
End Function

WScript.StdOut.WriteLine strip_comments("apples, pears # and bananas","#")
WScript.StdOut.WriteLine strip_comments("apples, pears ; and bananas",";")
