'create and display the initial matrix
WScript.StdOut.WriteLine "Initial Matrix:"
x = 4 : y = 6 : n = 1
Dim matrix()
ReDim matrix(x,y)
For i = 0 To y
	For j = 0 To x
		matrix(j,i) = n
		If j < x Then
			WScript.StdOut.Write n & vbTab
		Else
			WScript.StdOut.Write n
		End If
		n = n + 1
	Next
	WScript.StdOut.WriteLine
Next

'display the trasposed matrix
WScript.StdOut.WriteBlankLines(1)
WScript.StdOut.WriteLine "Transposed Matrix:"
For i = 0 To x
	For j = 0 To y
		If j < y Then
			WScript.StdOut.Write matrix(i,j) & vbTab
		Else
			WScript.StdOut.Write matrix(i,j)
		End If
	Next
	WScript.StdOut.WriteLine
Next
