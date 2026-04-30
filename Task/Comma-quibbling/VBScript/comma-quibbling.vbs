Function Quibble(s)
	arr = Split(s,",")
	If s = "" Then
		Quibble = "{}"
	ElseIf UBound(arr) = 0 Then
		Quibble = "{" & arr(0) & "}"
	Else
		Quibble = "{"
		For i = 0 To UBound(arr)
			If i = UBound(arr) - 1 Then
				Quibble = Quibble & arr(i) & " and " & arr(i + 1) & "}"
				Exit For
			Else
				Quibble = Quibble & arr(i) & ", "
			End If
		Next
	End If
End Function

WScript.StdOut.Write Quibble("")
WScript.StdOut.WriteLine
WScript.StdOut.Write Quibble("ABC")
WScript.StdOut.WriteLine
WScript.StdOut.Write Quibble("ABC,DEF")
WScript.StdOut.WriteLine
WScript.StdOut.Write Quibble("ABC,DEF,G,H")
WScript.StdOut.WriteLine
