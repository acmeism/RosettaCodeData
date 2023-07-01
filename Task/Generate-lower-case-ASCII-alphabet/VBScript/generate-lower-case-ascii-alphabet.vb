Function ASCII_Sequence(range)
	arr = Split(range,"..")
	For i = Asc(arr(0)) To Asc(arr(1))
		ASCII_Sequence = ASCII_Sequence & Chr(i) & " "
	Next
End Function

WScript.StdOut.Write ASCII_Sequence(WScript.Arguments(0))
WScript.StdOut.WriteLine
