Function tpk(s)
	arr = Split(s," ")
	For i = UBound(arr) To 0 Step -1
		n = fx(CDbl(arr(i)))
		If  n > 400 Then
			WScript.StdOut.WriteLine arr(i) & " = OVERFLOW"
		Else
			WScript.StdOut.WriteLine arr(i) & " = " & n
		End If
	Next
End Function

Function fx(x)
	fx = Sqr(Abs(x))+5*x^3
End Function

'testing the function
WScript.StdOut.Write "Please enter a series of numbers:"
list = WScript.StdIn.ReadLine
tpk(list)
