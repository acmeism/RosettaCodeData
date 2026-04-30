'http://rosettacode.org/wiki/Middle_three_digits

Function mid3n(n)
	'Remove the number's sign.
	n = CStr(Abs(n))
	If Len(n) < 3 Or Len(n) Mod 2 = 0 Then
		mid3n = "Invalid: Either the length of n < 3 or an even number."
	ElseIf Round(Len(n)/2) > Len(n)/2 Then
		mid3n = Mid(n,Round(Len(n)/2)-1,3)
	Else
		mid3n = Mid(n,Round(Len(n)/2),3)
	End If
End Function

'Calling the function.
arrn = Array(123,12345,1234567,987654321,10001,-10001,-123,-100,100,-12345,_
			1,2,-1,-10,2002,-2002,0)
For Each n In arrn
	WScript.StdOut.Write n & ": " & mid3n(n)
	WScript.StdOut.WriteLine
Next
