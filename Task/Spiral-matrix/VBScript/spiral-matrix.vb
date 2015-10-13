Function build_spiral(n)
	botcol = 0 : topcol = n - 1
	botrow = 0 : toprow = n - 1
	'declare a two dimensional array
	Dim matrix()
	ReDim matrix(topcol,toprow)
	dir = 0 : col = 0 : row = 0
	'populate the array
	For i = 0 To n*n-1
		matrix(col,row) = i
		Select Case dir
			Case 0
				If col < topcol Then
					col = col + 1
				Else
					dir = 1 : row = row + 1 : botrow = botrow + 1
				End If
			Case 1
				If row < toprow Then
					row = row + 1
				Else
					dir = 2 : col = col - 1 : topcol = topcol - 1	
				End If
			Case 2
				If col > botcol Then
					col = col - 1
				Else
					dir = 3 : row = row - 1 : toprow = toprow - 1
				End If
			Case 3
				If row > botrow Then
					row = row - 1
				Else
					dir = 0 : col = col + 1 : botcol = botcol + 1
				End If
		End Select
	Next
	'print the array
	For y = 0 To n-1
		For x = 0 To n-1
			WScript.StdOut.Write matrix(x,y) & vbTab
		Next
		WScript.StdOut.WriteLine
	Next
End Function

build_spiral(CInt(WScript.Arguments(0)))
