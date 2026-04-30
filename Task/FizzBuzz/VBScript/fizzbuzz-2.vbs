With WScript.StdOut
	For i = 1 To 100
		If i Mod 3 = 0 Then .Write "Fizz"
		If i Mod 5 = 0 Then .Write "Buzz"
		If .Column = 1 Then .WriteLine i Else .WriteLine ""
	Next
End With
