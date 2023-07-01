For k = 1 To 5
	count = 0
	increment = 1
	WScript.StdOut.Write "K" & k & ": "
	Do Until count = 10
		If PrimeFactors(increment) = k Then
			WScript.StdOut.Write increment & " "
			count = count + 1
		End If
		increment = increment + 1
	Loop
	WScript.StdOut.WriteLine
Next

Function PrimeFactors(n)
	PrimeFactors = 0
	arrP = Split(ListPrimes(n)," ")
	divnum = n
	Do Until divnum = 1
		For i = 0 To UBound(arrP)-1
			If divnum = 1 Then
				Exit For
			ElseIf divnum Mod arrP(i) = 0 Then
				divnum = divnum/arrP(i)
				PrimeFactors = PrimeFactors + 1
			End If
		Next
	Loop
End Function

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

Function ListPrimes(n)
	ListPrimes = ""
	For i = 1 To n
		If IsPrime(i) Then
			ListPrimes = ListPrimes & i & " "
		End If
	Next
End Function
