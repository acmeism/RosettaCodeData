Max=250

For X0=1 To Max
	For X1=1 To X0
		For X2=1 To X1
			For X3=1 To X2
				Sum=fnP5(X0)+fnP5(X1)+fnP5(X2)+fnP5(X3)
				S1=Int(Sum^0.2)
				If Sum=fnP5(S1) Then
					WScript.StdOut.Write X0 & " " & X1 & " " & X2 & " " & X3 & " " & S1
					WScript.Quit
				End If
			Next
		Next
	Next
Next

Function fnP5(n)
	fnP5 = n ^ 5
End Function
