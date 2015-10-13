Function build_spiral(n)
	'declare a two dimentional array
	Dim matrix()
	ReDim matrix(n-1,n-1)
	'determine starting point
	x = (n-1)/2 : y = (n-1)/2
	'set the initial iterations
	x_max = 1 : y_max = 1 : count = 1
	'set initial direction
	dir = "R"
	'populate the array
	For i = 1 To n*n
		l = Len(n*n)
		If IsPrime(i) Then
			matrix(x,y) = Right("000" & i,l)
		Else
			matrix(x,y) = String(l,"-")
		End If
		Select Case dir
			Case "R"
				If x_max > 0 Then
					x = x + 1 : x_max = x_max - 1
				Else
					dir = "U" : y_max = count
					y = y - 1 : y_max = y_max - 1
				End If
			Case "U"
				If y_max > 0 Then
					y = y - 1 : y_max = y_max - 1
				Else
					dir = "L" : count = count + 1 : x_max = count
					x = x - 1 : x_max = x_max - 1
				End If
			Case "L"
				If x_max > 0 Then
					x = x - 1 : x_max = x_max - 1
				Else
					dir = "D" : y_max = count
					y = y + 1 : y_max = y_max - 1
				End If
			Case "D"
				If y_max > 0 Then
					y = y + 1 : y_max = y_max - 1
				Else
					dir = "R" : count = count + 1 : x_max = count
					x = x + 1 : x_max = x_max - 1
				End If
		End Select
	Next
	'print the matrix
	For y = 0 To n - 1
		For x = 0 To n - 1
			If x = n - 1 Then
				WScript.StdOut.Write matrix(x,y)
			Else
				WScript.StdOut.Write matrix(x,y) & vbTab
			End If
		Next
		WScript.StdOut.WriteLine
	Next
End Function

Function IsPrime(n)
	If n = 2 Then
		IsPrime = True
	ElseIf n <= 1 Or n Mod 2 = 0 Then
		IsPrime = False
	Else
		IsPrime = True
		For i = 3 To Int(Sqr(n)) Step 2
			If n Mod i = 0 Then
				IsPrime = False
				Exit For
			End If
		Next
	End If
End Function

'test with 9
build_spiral(9)
