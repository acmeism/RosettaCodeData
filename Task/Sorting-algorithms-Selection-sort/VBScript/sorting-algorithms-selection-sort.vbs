Function Selection_Sort(s)
	arr = Split(s,",")
	For i = 0 To UBound(arr)
		For j = i To UBound(arr)
			temp = arr(i)
			If arr(j) < arr(i) Then
				arr(i) = arr(j)
				arr(j) = temp
			End If
		Next
	Next
	Selection_Sort = (Join(arr,","))
End Function

WScript.StdOut.Write "Pre-Sort" & vbTab & "Sorted"
WScript.StdOut.WriteLine
WScript.StdOut.Write "3,2,5,4,1" & vbTab & Selection_Sort("3,2,5,4,1")
WScript.StdOut.WriteLine
WScript.StdOut.Write "c,e,b,a,d" & vbTab & Selection_Sort("c,e,b,a,d")
