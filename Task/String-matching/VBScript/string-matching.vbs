Function StartsWith(s1,s2)
	StartsWith = False
	If Left(s1,Len(s2)) = s2 Then
		StartsWith = True
	End If
End Function

Function Contains(s1,s2)
	Contains = False
	If InStr(1,s1,s2) Then
		Contains = True & " at positions "
		j = 1
		Do Until InStr(j,s1,s2) = False
			Contains = Contains & InStr(j,s1,s2) & ", "
			If j = 1 Then
				If Len(s2) = 1 Then
					j = j + InStr(j,s1,s2)
				Else
					j = j + (InStr(j,s1,s2) + (Len(s2) - 1))
				End If
			Else
				If Len(s2) = 1 Then
					j = j + ((InStr(j,s1,s2) - j) + 1)
				Else
					j = j + ((InStr(j,s1,s2) - j) + (Len(s2) - 1))
				End If
			End If
		Loop
	End If
End Function

Function EndsWith(s1,s2)
	EndsWith = False
	If Right(s1,Len(s2)) = s2 Then
		EndsWith = True
	End If
End Function

WScript.StdOut.Write "Starts with test, 'foo' in 'foobar': " & StartsWith("foobar","foo")
WScript.StdOut.WriteLine
WScript.StdOut.Write "Contains test, 'o' in 'fooooobar': " & Contains("fooooobar","o")
WScript.StdOut.WriteLine
WScript.StdOut.Write "Ends with test, 'bar' in 'foobar': " & EndsWith("foobar","bar")
