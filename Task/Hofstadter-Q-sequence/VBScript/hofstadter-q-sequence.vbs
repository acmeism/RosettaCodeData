Sub q_sequence(n)
	Dim Q()
	ReDim Q(n)
	Q(1)=1 : Q(2)=1 : Q(3)=2
	less_precede = 0
	For i = 4 To n
	 Q(i)=Q(i-Q(i-1))+Q(i-Q(i-2))
	 If Q(i) < Q(i-1) Then
	 	less_precede = less_precede + 1
	 End If
	Next
	WScript.StdOut.Write "First 10 terms of the sequence: "
	For j = 1 To 10
		If j < 10 Then
			WScript.StdOut.Write Q(j) & ", "
		Else
			WScript.StdOut.Write "and " & Q(j)
		End If
	Next
	WScript.StdOut.WriteLine
	WScript.StdOut.Write "1000th term of the sequence: " & Q(1000)
	WScript.StdOut.WriteLine
	WScript.StdOut.Write "Number of times the member of the sequence is less than its preceding term: " &_
		less_precede
End Sub

q_sequence(100000)
