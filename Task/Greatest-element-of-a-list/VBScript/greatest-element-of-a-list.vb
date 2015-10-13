Function greatest_element(arr)
	tmp_num = 0
	For i = 0 To UBound(arr)
		If i = 0 Then
			tmp_num = arr(i)
		ElseIf arr(i) > tmp_num Then
			tmp_num = arr(i)
		End If
	Next
	greatest_element = tmp_num
End Function

WScript.Echo greatest_element(Array(1,2,3,44,5,6,8))
