test_arr_1 = Array(1,2,3,4,5,6,7,8,9,10)
test_arr_2 = Array(1,2,3,4,5,6,7,8,9,10)

WScript.StdOut.Write "Scenario 1: Create a new array"
WScript.StdOut.WriteLine
WScript.StdOut.Write "Input: " & Join(test_arr_1,",")
WScript.StdOut.WriteLine
WScript.StdOut.Write "Output: " & filter_create(test_arr_1)
WScript.StdOut.WriteBlankLines(2)

WScript.StdOut.Write "Scenario 2: Destructive approach"
WScript.StdOut.WriteLine
WScript.StdOut.Write "Input: " & Join(test_arr_2,",")
WScript.StdOut.WriteLine
WScript.StdOut.Write "Output: " & filter_destruct(test_arr_2)
WScript.StdOut.WriteBlankLines(2)

Function filter_create(arr)
	ReDim arr_new(0)
	For i = 0 To UBound(arr)
		If arr(i) Mod 2 = 0 Then
			If arr_new(0) = "" Then
				arr_new(0) = arr(i)
			Else
				ReDim Preserve arr_new(UBound(arr_new)+1)
				arr_new(UBound(arr_new)) = arr(i)
			End If
		End If
	Next
	filter_create = Join(arr_new,",")
End Function

Function filter_destruct(arr)
	count = 0
	For i = 0 To UBound(arr)
		If arr(i) Mod 2 <> 0 Then
			count = count + 1
			For j = i To UBound(arr)
				If j + 1 <= UBound(arr) Then
					arr(j) = arr(j+1)
				End If
			Next
		End If
	Next
	ReDim Preserve arr(UBound(arr)-count)
	filter_destruct = Join(arr,",")
End Function
