WScript.Echo DotProduct("1,3,-5","4,-2,-1")

Function DotProduct(vector1,vector2)
	arrv1 = Split(vector1,",")
	arrv2 = Split(vector2,",")
	If UBound(arrv1) <> UBound(arrv2) Then
		WScript.Echo "The vectors are not of the same length."
		Exit Function
	End If
	DotProduct = 0
	For i = 0 To UBound(arrv1)
		DotProduct = DotProduct + (arrv1(i) * arrv2(i))
	Next
End Function
