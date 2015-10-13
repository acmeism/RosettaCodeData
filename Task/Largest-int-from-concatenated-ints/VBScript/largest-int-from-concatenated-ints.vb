Function largestint(list)
	nums = Split(list,",")
	Do Until IsSorted = True
		IsSorted = True
		For i = 0 To UBound(nums)
			If i <> UBound(nums) Then
				a = nums(i)
				b = nums(i+1)
				If CLng(a&b) < CLng(b&a) Then
					tmpnum = nums(i)
					nums(i) = nums(i+1)
					nums(i+1) = tmpnum
					IsSorted = False
				End If
			End If
		Next
	Loop
	For j = 0 To UBound(nums)
		largestint = largestint & nums(j)
	Next
End Function

WScript.StdOut.Write largestint(WScript.Arguments(0))
WScript.StdOut.WriteLine
