ZigZag(Cint(WScript.Arguments(0)))

Function ZigZag(n)
	Dim arrZ()
	ReDim arrZ(n-1,n-1)
	i = 1
	j = 1
	For e = 0 To (n^2) - 1
		arrZ(i-1,j-1) = e
		If ((i + j ) And 1) = 0 Then
			If j < n Then
				j = j + 1
			Else
				i = i + 2
			End If
			If i > 1 Then
				i = i - 1
			End If
		Else
			If i < n Then
				i = i + 1
			Else
				j = j + 2
			End If
			If j > 1 Then
				j = j - 1
			End If
		End If
	Next
	For k = 0 To n-1
		For l = 0 To n-1
			WScript.StdOut.Write Right("  " & arrZ(k,l),3)
		Next
		WScript.StdOut.WriteLine
	Next
End Function
