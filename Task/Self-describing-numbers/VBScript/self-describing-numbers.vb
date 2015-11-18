Function IsSelfDescribing(n)
	IsSelfDescribing = False
	Set digit = CreateObject("Scripting.Dictionary")
	For i = 1 To Len(n)
		k = Mid(n,i,1)
		If digit.Exists(k) Then
			digit.Item(k) = digit.Item(k) + 1
		Else
			digit.Add k,1
		End If	
	Next
	c = 0
	For j = 0 To Len(n)-1
		l = Mid(n,j+1,1)
		If digit.Exists(CStr(j)) Then
			If digit.Item(CStr(j)) = CInt(l) Then
				c = c + 1
			End If
		ElseIf l = 0 Then
			c = c + 1
		Else
			Exit For
		End If
	Next
	If c = Len(n) Then
		IsSelfDescribing = True
	End If
End Function

'testing
start_time = Now
s = ""
For m = 1 To 100000000
	If 	IsSelfDescribing(m) Then
		WScript.StdOut.WriteLine m
	End If
Next
end_time = Now
WScript.StdOut.WriteLine "Elapse Time: " & DateDiff("s",start_time,end_time) & " seconds"
