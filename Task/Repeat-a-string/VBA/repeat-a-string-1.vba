Public Function RepeatStr(aString As String, aNumber As Integer) As String
	Dim bString As String, i As Integer
	bString = ""
	For i = 1 To aNumber
		bString = bString & aString
	Next i
	RepeatStr = bString
End Function

Debug.Print RepeatStr("ha", 5)
