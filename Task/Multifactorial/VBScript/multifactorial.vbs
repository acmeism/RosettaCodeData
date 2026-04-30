Function multifactorial(n,d)
	If n = 0 Then
		multifactorial = 1
	Else
		For i = n To 1 Step -d
			If i = n Then
				multifactorial = n
			Else
				multifactorial = multifactorial * i
			End If
		Next
	End If
End Function

For j = 1 To 5
	WScript.StdOut.Write "Degree " & j & ": "
	For k = 1 To 10
		If k = 10 Then
			WScript.StdOut.Write multifactorial(k,j)
		Else
			WScript.StdOut.Write multifactorial(k,j) & " "
		End If
	Next
	WScript.StdOut.WriteLine
Next
