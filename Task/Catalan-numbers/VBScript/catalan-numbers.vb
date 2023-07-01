Function catalan(n)
	catalan = factorial(2*n)/(factorial(n+1)*factorial(n))
End Function

Function factorial(n)
	If n = 0 Then
		Factorial = 1
	Else
		For i = n To 1 Step -1
			If i = n Then
				factorial = n
			Else
				factorial = factorial * i
			End If
		Next
	End If
End Function

'Find the first 15 Catalan numbers.
For j = 1 To 15
	WScript.StdOut.Write j & " = " & catalan(j)
	WScript.StdOut.WriteLine
Next
