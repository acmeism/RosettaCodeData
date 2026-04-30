iexpmax = 15
n=1
out=""
For iexp = 2 To iexpmax
	If iexp = 2 Then
		s = 0
	Else
		s = 4
	End If
	n = (n + 1) * 2 - 1
	For i = 1 To iexp - 2
		s = (s * s - 2) Mod n
	Next
	If s = 0 Then
		out=out & "M" & iexp & " "
	End If
Next
Wscript.echo out
