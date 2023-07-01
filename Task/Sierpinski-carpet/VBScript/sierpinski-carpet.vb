Function InCarpet(i,j)
	If i > 0 And j > 0 Then
		Do While i > 0 And j > 0
			If i Mod 3 = 1 And j Mod 3 = 1 Then
				InCarpet = " "
				Exit Do
			Else
				InCarpet = "#"
			End If
				i = Int(i / 3)
				j = Int(j / 3)
		Loop
	Else
		InCarpet = "#"
	End If
End Function

Function Carpet(n)
	k = 3^n - 1
	x2 = 0
	y2 = 0
	For y = 0 To k
		For x = 0 To k
			x2 = x
			y2 = y
			WScript.StdOut.Write InCarpet(x2,y2)
		Next
		WScript.StdOut.WriteBlankLines(1)
	Next
End Function

Carpet(WScript.Arguments(0))
