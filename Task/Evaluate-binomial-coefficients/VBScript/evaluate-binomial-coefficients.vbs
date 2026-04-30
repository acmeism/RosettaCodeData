Function binomial(n,k)
	binomial = factorial(n)/(factorial(n-k)*factorial(k))
End Function

Function factorial(n)
	If n = 0 Then
		factorial = 1
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

'calling the function
WScript.StdOut.Write "the binomial coefficient of 5 and 3 = " & binomial(5,3)
WScript.StdOut.WriteLine
