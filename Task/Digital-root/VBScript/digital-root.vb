Function digital_root(n)
	ap = 0
	Do Until Len(n) = 1
		x = 0
		For i = 1 To Len(n)
			x = x + CInt(Mid(n,i,1))
		Next
		n = x
		ap = ap + 1
	Loop
	digital_root = "Additive Persistence = " & ap & vbCrLf &_
		"Digital Root = " & n & vbCrLf	
End Function

WScript.StdOut.Write digital_root(WScript.Arguments(0))
