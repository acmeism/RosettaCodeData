Function div(num,den)
	On Error Resume Next
	n = num/den
	If Err.Number <> 0 Then
		div = Err.Description & " is not allowed."
	Else
		div = n
	End If
End Function

WScript.StdOut.WriteLine div(6,3)
WScript.StdOut.WriteLine div(6,0)
WScript.StdOut.WriteLine div(7,-4)
