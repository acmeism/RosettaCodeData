Function string_compare(arr)
	lexical = "Pass"
	ascending = "Pass"
	For i = 0 To UBound(arr)
		If i+1 <= UBound(arr) Then
			If arr(i) <> arr(i+1) Then
				lexical = "Fail"
			End If
			If arr(i) >= arr(i+1) Then
				ascending = "Fail"
			End If
		End If	
	Next
	string_compare = "List: " & Join(arr,",") & vbCrLf &_
					 "Lexical Test: " & lexical & vbCrLf &_
					 "Ascending Test: " & ascending & vbCrLf
End Function

WScript.StdOut.WriteLine string_compare(Array("AA","BB","CC"))
WScript.StdOut.WriteLine string_compare(Array("AA","AA","AA"))
WScript.StdOut.WriteLine string_compare(Array("AA","CC","BB"))
WScript.StdOut.WriteLine string_compare(Array("AA","ACB","BB","CC"))
WScript.StdOut.WriteLine string_compare(Array("FF"))
