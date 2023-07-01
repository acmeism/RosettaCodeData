Deficient = 0
Perfect = 0
Abundant = 0
For i = 1 To 20000
	sum = 0
	For n = 1 To 20000
		If n < i Then
			If i Mod n = 0 Then
				sum = sum + n
			End If
		End If
	Next
	If sum < i Then
		Deficient = Deficient + 1
	ElseIf sum = i Then
		Perfect = Perfect + 1
	ElseIf sum > i Then
		Abundant = Abundant + 1
	End If
Next
WScript.Echo "Deficient = " & Deficient & vbCrLf &_
			 "Perfect = " & Perfect & vbCrLf &_
			 "Abundant = " & Abundant
