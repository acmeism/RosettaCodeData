arr = Array(-7,1,5,2,-4,3,0)
WScript.StdOut.Write equilibrium(arr,UBound(arr))
WScript.StdOut.WriteLine

Function equilibrium(arr,n)
	sum = 0
	leftsum = 0
	'find the sum of the whole array
	For i = 0 To UBound(arr)
		sum = sum + arr(i)
	Next
	For i = 0 To UBound(arr)
		sum = sum - arr(i)
		If leftsum = sum Then
			equilibrium = equilibrium & i & ", "
		End If
		leftsum = leftsum + arr(i)
	Next
End Function
