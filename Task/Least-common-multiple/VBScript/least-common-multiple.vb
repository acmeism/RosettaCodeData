Function LCM(a,b)
	LCM = POS((a * b)/GCD(a,b))
End Function

Function GCD(a,b)
	Do
		If a Mod b > 0 Then
			c = a Mod b
			a = b
			b = c
		Else
			GCD = b
			Exit Do
		End If
	Loop
End Function

Function POS(n)
	If n < 0 Then
		POS = n * -1
	Else
		POS = n
	End If
End Function

i = WScript.Arguments(0)
j = WScript.Arguments(1)

WScript.StdOut.Write "The LCM of " & i & " and " & j & " is " & LCM(i,j) & "."
WScript.StdOut.WriteLine
