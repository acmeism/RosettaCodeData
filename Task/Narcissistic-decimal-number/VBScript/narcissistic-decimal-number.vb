Function Narcissist(n)
	i = 0
	j = 0
	Do Until j = n
		sum = 0
		For k = 1 To Len(i)
			sum = sum + CInt(Mid(i,k,1)) ^ Len(i)
		Next
		If i = sum Then
			Narcissist = Narcissist & i & ", "
			j = j + 1
		End If
		i = i + 1
	Loop
End Function

WScript.StdOut.Write Narcissist(25)
