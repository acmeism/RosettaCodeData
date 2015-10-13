Function sum_of_squares(arr)
	If UBound(arr) = -1 Then
		sum_of_squares = 0
	End If
	For i = 0 To UBound(arr)
		sum_of_squares = sum_of_squares + (arr(i)^2)
	Next
End Function

WScript.StdOut.WriteLine sum_of_squares(Array(1,2,3,4,5))
WScript.StdOut.WriteLine sum_of_squares(Array())
