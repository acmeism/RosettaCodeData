Function sum_and_product(arr)
	sum = 0
	product = 1
	For i = 0 To UBound(arr)
		sum = sum + arr(i)
		product = product * arr(i)
	Next
	WScript.StdOut.Write "Sum: " & sum
	WScript.StdOut.WriteLine
	WScript.StdOut.Write "Product: " & product
	WScript.StdOut.WriteLine
End Function

myarray = Array(1,2,3,4,5,6)
sum_and_product(myarray)
