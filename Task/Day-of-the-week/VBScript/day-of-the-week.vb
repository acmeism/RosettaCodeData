For i = 2008 To 2121
	If Weekday(i & "-12-25") = 1 Then
		WScript.StdOut.Write i
		WScript.StdOut.WriteLine
	End If
Next
