data = Array(2,4,4,4,5,5,7,9)

For i = 0 To UBound(data)
	WScript.StdOut.Write "value = " & data(i) &_
		" running sd = " & sd(data,i)
	WScript.StdOut.WriteLine
Next

Function sd(arr,n)
	mean = 0
	variance = 0
	For j = 0 To n
		mean = mean + arr(j)
	Next
	mean = mean/(n+1)
	For k = 0 To n
		variance = variance + ((arr(k)-mean)^2)
	Next
	variance = variance/(n+1)
	sd = FormatNumber(Sqr(variance),6)
End Function
