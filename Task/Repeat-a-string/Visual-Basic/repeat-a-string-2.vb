Public Function StrRepeat(sText As String, n As Integer) As String
	StrRepeat = Replace(String(n, "*"), "*", sText)
End Function
