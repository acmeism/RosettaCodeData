Function mean(arr)
	size = UBound(arr) + 1
	mean = 0
	For i = 0 To UBound(arr)
		mean = mean + arr(i)
	Next
	mean = mean/size
End Function

'Example
WScript.Echo mean(Array(3,1,4,1,5,9))
