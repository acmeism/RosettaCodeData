Dim chosen(10)

For j = 1 To 1000000
	c = one_of_n(10)
	chosen(c) = chosen(c) + 1
Next

For k = 1 To 10
	WScript.StdOut.WriteLine k & ". " & chosen(k)
Next

Function one_of_n(n)
	Randomize
	For i = 1 To n
		If Rnd(1) < 1/i Then
			one_of_n = i
		End If
	Next
End Function
