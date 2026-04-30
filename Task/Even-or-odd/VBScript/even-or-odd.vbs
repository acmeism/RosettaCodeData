Function odd_or_even(n)
	If n Mod 2 = 0 Then
		odd_or_even = "Even"
	Else
		odd_or_even = "Odd"
	End If
End Function

WScript.StdOut.Write "Please enter a number: "
n = WScript.StdIn.ReadLine
WScript.StdOut.Write n & " is " & odd_or_even(CInt(n))
WScript.StdOut.WriteLine
