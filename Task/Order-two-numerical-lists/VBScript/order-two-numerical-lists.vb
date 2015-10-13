Function order_list(arr1,arr2)
	order_list = "FAIL"
	n1 = UBound(arr1): n2 = UBound(arr2)
	n = 0 : p = 0
	If n1 > n2 Then
		max = n2
	Else
		max = n1
	End If
	For i = 0 To max
		If arr1(i) > arr2(i) Then
			n = n + 1
		ElseIf arr1(i) = arr2(i) Then
			p = p + 1
		End If	
	Next
	If (n1 < n2 And n = 0) Or _
		 (n1 = n2 And n = 0 And p - 1 <> n1) Or _
		 (n1 > n2 And n = 0 And p = n2) Then
			order_list = "PASS"
	End If
End Function

WScript.StdOut.WriteLine order_list(Array(-1),Array(0))
WScript.StdOut.WriteLine order_list(Array(0),Array(0))
WScript.StdOut.WriteLine order_list(Array(0),Array(-1))
WScript.StdOut.WriteLine order_list(Array(0),Array(0,-1))
WScript.StdOut.WriteLine order_list(Array(0),Array(0,0))
WScript.StdOut.WriteLine order_list(Array(0),Array(0,1))
WScript.StdOut.WriteLine order_list(Array(0,-1),Array(0))
WScript.StdOut.WriteLine order_list(Array(0,0),Array(0))
WScript.StdOut.WriteLine order_list(Array(0,0),Array(1))
WScript.StdOut.WriteLine order_list(Array(1,2,1,3,2),Array(1,2,0,4,4,0,0,0))
