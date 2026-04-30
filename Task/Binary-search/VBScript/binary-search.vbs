Function binary_search(arr,value,lo,hi)
		If hi < lo Then
			binary_search = 0
		Else
			middle=Int((hi+lo)/2)
			If value < arr(middle) Then
				binary_search = binary_search(arr,value,lo,middle-1)
			ElseIf value > arr(middle) Then
				binary_search = binary_search(arr,value,middle+1,hi)
			Else
				binary_search = middle
				Exit Function
			End If
		End If
End Function

'Tesing the function.
num_range = Array(2,3,5,6,8,10,11,15,19,20)
n = CInt(WScript.Arguments(0))
idx = binary_search(num_range,n,LBound(num_range),UBound(num_range))
If idx > 0 Then
	WScript.StdOut.Write n & " found at index " & idx
	WScript.StdOut.WriteLine
Else
	WScript.StdOut.Write n & " not found"
	WScript.StdOut.WriteLine
End If
