For i = 1 To 100
	If i Mod 15 = 0 Then
		WScript.Echo "FizzBuzz"
	ElseIf i Mod 5 = 0 Then
		WScript.Echo "Buzz"
	ElseIf i Mod 3 = 0 Then
		WScript.Echo "Fizz"
	Else
		WScript.Echo i
	End If
Next
