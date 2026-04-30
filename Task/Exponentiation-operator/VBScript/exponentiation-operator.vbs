Function pow(x,y)
	pow = 1
	If y < 0 Then
		For i = 1 To Abs(y)
			pow = pow * (1/x)
		Next
	Else
		For i = 1 To y
			pow = pow * x
		Next
	End If
End Function

WScript.StdOut.Write "2 ^ 0 = " & pow(2,0)
WScript.StdOut.WriteLine
WScript.StdOut.Write "7 ^ 6 = " & pow(7,6)
WScript.StdOut.WriteLine
WScript.StdOut.Write "3.14159265359 ^ 9 = " & pow(3.14159265359,9)
WScript.StdOut.WriteLine
WScript.StdOut.Write "4 ^ -6 = " & pow(4,-6)
WScript.StdOut.WriteLine
WScript.StdOut.Write "-3 ^ 5 = " & pow(-3,5)
WScript.StdOut.WriteLine
