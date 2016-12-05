build_matrix(7)

Sub build_matrix(n)
	Dim matrix()
	ReDim matrix(n-1,n-1)
	i = 0
	'populate the matrix
	For row = 0 To n-1
		For col = 0 To n-1
			If col = i Then
				matrix(row,col) = 1
			Else
				matrix(row,col) = 0
			End If	
		Next
		i = i + 1
	Next
	'display the matrix
	For row = 0 To n-1
		For col = 0 To n-1
			If col < n-1 Then
				WScript.StdOut.Write matrix(row,col) & " "
			Else
				WScript.StdOut.Write matrix(row,col)
			End If
		Next
		WScript.StdOut.WriteLine
	Next
End Sub
