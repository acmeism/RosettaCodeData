start_time = Now

lt = 0
rt = 0

For h = 1 To 1000000
	If IsLeftTruncatable(h) And h > lt Then
		lt = h
	End If
	If IsRightTruncatable(h) And h > rt Then
		rt = h
	End If
Next

end_time = now

WScript.StdOut.WriteLine "Largest LTP from 1..1000000: " & lt
WScript.StdOut.WriteLine "Largest RTP from 1..1000000: " & rt
WScript.StdOut.WriteLine "Elapse Time(seconds)       : " & DateDiff("s",start_time,end_time)

'------------
Function IsLeftTruncatable(n)
	IsLeftTruncatable = False
	c = 0
	For i = Len(n) To 1 Step -1
		If InStr(1,n,"0") > 0 Then
			Exit For
		End If
		If IsPrime(Right(n,i)) Then
			c = c + 1
		End If
	Next
	If c = Len(n) Then
		IsLeftTruncatable = True
	End If
End Function

Function IsRightTruncatable(n)
	IsRightTruncatable = False
	c = 0
	For i = Len(n) To 1 Step -1
		If InStr(1,n,"0") > 0 Then
			Exit For
		End If
		If IsPrime(Left(n,i)) Then
			c = c + 1
		End If
	Next
	If c = Len(n) Then
		IsRightTruncatable = True
	End If
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
