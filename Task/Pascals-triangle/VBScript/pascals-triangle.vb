Pascal_Triangle(WScript.Arguments(0))
Function Pascal_Triangle(n)
	Dim values(100)
	values(1) = 1
	WScript.StdOut.Write values(1)
	WScript.StdOut.WriteLine
	For row = 2 To n
		For i = row To 1 Step -1
			values(i) = values(i) + values(i-1)
			WScript.StdOut.Write values(i) & " "
		Next
		WScript.StdOut.WriteLine
	Next
End Function
