Dim matrix1(2,2)
matrix1(0,0) = 3 : matrix1(0,1) = 7 : matrix1(0,2) = 4
matrix1(1,0) = 5 : matrix1(1,1) = -2 : matrix1(1,2) = 9
matrix1(2,0) = 8 : matrix1(2,1) = -6 : matrix1(2,2) = -5
Dim matrix2(2,2)
matrix2(0,0) = 9 : matrix2(0,1) = 2 : matrix2(0,2) = 1
matrix2(1,0) = -7 : matrix2(1,1) = 3 : matrix2(1,2) = -10
matrix2(2,0) = 4 : matrix2(2,1) = 5 : matrix2(2,2) = -6

Call multiply_matrix(matrix1,matrix2)

Sub multiply_matrix(arr1,arr2)
	For i = 0 To UBound(arr1)
		For j = 0 To 2
			WScript.StdOut.Write (arr1(i,j) * arr2(i,j)) & vbTab
		Next
		WScript.StdOut.WriteLine
	Next
End Sub
