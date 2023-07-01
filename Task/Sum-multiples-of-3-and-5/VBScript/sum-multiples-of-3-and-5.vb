Function multsum35(n)
	For i = 1 To n - 1
		If i Mod 3 = 0 Or i Mod 5 = 0 Then
			multsum35 = multsum35 + i
		End If
	Next
End Function

WScript.StdOut.Write multsum35(CLng(WScript.Arguments(0)))
WScript.StdOut.WriteLine
