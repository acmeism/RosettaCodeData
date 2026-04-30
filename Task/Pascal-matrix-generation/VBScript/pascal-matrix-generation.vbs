Function pascal_upper(i,j)
	WScript.StdOut.Write "Pascal Upper"
	WScript.StdOut.WriteLine
	For l = i To j
		For m = i To j
			If l <= m Then
				WScript.StdOut.Write binomial(m,l) & vbTab
			Else
				WScript.StdOut.Write 0 & vbTab
			End If
		Next
		WScript.StdOut.WriteLine
	Next
	WScript.StdOut.WriteLine
End Function

Function pascal_lower(i,j)
	WScript.StdOut.Write "Pascal Lower"
	WScript.StdOut.WriteLine
	For l = i To j
		For m = i To j
			If l >= m Then
				WScript.StdOut.Write binomial(l,m) & vbTab
			Else
				WScript.StdOut.Write 0 & vbTab
			End If
		Next
		WScript.StdOut.WriteLine
	Next
	WScript.StdOut.WriteLine	
End Function

Function pascal_symmetric(i,j)
	WScript.StdOut.Write "Pascal Symmetric"
	WScript.StdOut.WriteLine
	For l = i To j
		For m = i To j
			WScript.StdOut.Write binomial(l+m,m) & vbTab
		Next
		WScript.StdOut.WriteLine
	Next
End Function

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

'Test driving
Call pascal_upper(0,4)
Call pascal_lower(0,4)
Call pascal_symmetric(0,4)
