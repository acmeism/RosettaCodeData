Public Function StrRepeat(s As String, n As Integer) As String
	Dim r As String, i As Integer
	r = ""
	For i = 1 To n
		r = r & s
	Next i
	StrRepeat = r
End Function

Debug.Print StrRepeat("ha", 5)
