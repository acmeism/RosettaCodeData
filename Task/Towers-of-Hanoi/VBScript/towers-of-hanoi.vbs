Sub Move(n,fromPeg,toPeg,viaPeg)
	If n > 0 Then
		Move n-1, fromPeg, viaPeg, toPeg
		WScript.StdOut.Write "Move disk from " & fromPeg & " to " & toPeg
		WScript.StdOut.WriteBlankLines(1)
		Move n-1, viaPeg, toPeg, fromPeg
	End If
End Sub

Move 4,1,2,3
WScript.StdOut.Write("Towers of Hanoi puzzle completed!")
