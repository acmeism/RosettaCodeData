Function IsPerfect(n)
	IsPerfect = False
	i = n - 1
	sum = 0
	Do While i > 0
		If n Mod i = 0 Then
			sum = sum + i
		End If
		i = i - 1
	Loop
	If sum = n Then
		IsPerfect = True
	End If
End Function

WScript.StdOut.Write IsPerfect(CInt(WScript.Arguments(0)))
WScript.StdOut.WriteLine
