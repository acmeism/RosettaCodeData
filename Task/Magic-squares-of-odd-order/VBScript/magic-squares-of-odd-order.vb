Sub magic_square(n)
	Dim ms()
	ReDim ms(n-1,n-1)
	inc = 0
	count = 1
	row = 0
	col = Int(n/2)
	Do While count <= n*n
		ms(row,col) = count
		count = count + 1
		If inc < n-1 Then
			inc = inc + 1
			row = row - 1
			col = col + 1
			If row >= 0 Then
				If col > n-1 Then
					col = 0
				End If
			Else
				row = n-1
			End If
		Else
			inc = 0
			row = row + 1
		End If
	Loop
	For i = 0 To n-1
		For j = 0 To n-1
			If j = n-1 Then
				WScript.StdOut.Write ms(i,j)
			Else
				WScript.StdOut.Write ms(i,j) & vbTab
			End If
		Next
		WScript.StdOut.WriteLine
	Next
End Sub

magic_square(5)
