'check if the number is pernicious
Function IsPernicious(n)
	IsPernicious = False
	bin_num = Dec2Bin(n)
	sum = 0
	For h = 1 To Len(bin_num)
		sum = sum + CInt(Mid(bin_num,h,1))
	Next
	If IsPrime(sum) Then
		IsPernicious = True
	End If
End Function

'prime number validation
Function IsPrime(n)
	If n = 2 Then
		IsPrime = True
	ElseIf n <= 1 Or n Mod 2 = 0 Then
		IsPrime = False
	Else
		IsPrime = True
		For i = 3 To Int(Sqr(n)) Step 2
			If n Mod i = 0 Then
				IsPrime = False
				Exit For
			End If
		Next
	End If
End Function

'decimal to binary converter
Function Dec2Bin(n)
	q = n
	Dec2Bin = ""
	Do Until q = 0
		Dec2Bin = CStr(q Mod 2) & Dec2Bin
		q = Int(q / 2)
	Loop
End Function

'display the first 25 pernicious numbers
c = 0
WScript.StdOut.Write "First 25 Pernicious Numbers:"
WScript.StdOut.WriteLine
For k = 1 To 100
	If IsPernicious(k) Then
		WScript.StdOut.Write k & ", "
		c = c + 1
	End If
	If c = 25 Then
		Exit For
	End If
Next
WScript.StdOut.WriteBlankLines(2)

'display the pernicious numbers between  888,888,877 to 888,888,888 (inclusive)
WScript.StdOut.Write "Pernicious Numbers between 888,888,877 to 888,888,888 (inclusive):"
WScript.StdOut.WriteLine
For l = 888888877 To 888888888
	If IsPernicious(l) Then
		WScript.StdOut.Write l & ", "
	End If
Next
WScript.StdOut.WriteLine
