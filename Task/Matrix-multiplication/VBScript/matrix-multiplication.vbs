Dim matrix1(2,2)
matrix1(0,0) = 3 : matrix1(0,1) = 7 : matrix1(0,2) = 4
matrix1(1,0) = 5 : matrix1(1,1) = -2 : matrix1(1,2) = 9
matrix1(2,0) = 8 : matrix1(2,1) = -6 : matrix1(2,2) = -5
Dim matrix2(2,2)
matrix2(0,0) = 9 : matrix2(0,1) = 2 : matrix2(0,2) = 1
matrix2(1,0) = -7 : matrix2(1,1) = 3 : matrix2(1,2) = -10
matrix2(2,0) = 4 : matrix2(2,1) = 5 : matrix2(2,2) = -6

function getMatrixProduct(firstMatrix,secondMatrix)
	if ubound(firstMatrix,2) <> ubound(secondMatrix,1) then exit function
	redim resultMatrix(ubound(firstMatrix,1),ubound(secondMatrix,2))
	for i = 0 to ubound(firstMatrix,1) : for j = 0 to ubound(secondMatrix,2) : for k = 0 to ubound(firstMatrix,2)
				resultMatrix(i,j) = resultMatrix(i,j) + (firstMatrix(i,k) * secondMatrix(k,j))
	next : next : next
	getMatrixProduct = resultMatrix
End function

dim resultMatrix : resultMatrix = getMatrixProduct(matrix1,matrix2)
dim outputString
for a = 0 to ubound(resultMatrix,1)
	for b = 0 to ubound(resultMatrix,2)
		outputString = outputString & resultMatrix(a,b) & vbTab
	next
	outputString = outputString & vbCrlf
next
msgbox outputString
