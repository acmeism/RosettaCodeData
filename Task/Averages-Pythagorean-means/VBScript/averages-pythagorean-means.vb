Function arithmetic_mean(arr)
	sum = 0
	For i = 0 To UBound(arr)
		sum = sum + arr(i)
	Next
	arithmetic_mean = sum / (UBound(arr)+1)
End Function

Function geometric_mean(arr)
	product = 1
	For i = 0 To UBound(arr)
		product = product * arr(i)
	Next
	geometric_mean = product ^ (1/(UBound(arr)+1))
End Function

Function harmonic_mean(arr)
	sum = 0
	For i = 0 To UBound(arr)
		sum = sum + (1/arr(i))
	Next
	harmonic_mean = (UBound(arr)+1) / sum
End Function

WScript.StdOut.WriteLine arithmetic_mean(Array(1,2,3,4,5,6,7,8,9,10))
WScript.StdOut.WriteLine geometric_mean(Array(1,2,3,4,5,6,7,8,9,10))
WScript.StdOut.WriteLine harmonic_mean(Array(1,2,3,4,5,6,7,8,9,10))
