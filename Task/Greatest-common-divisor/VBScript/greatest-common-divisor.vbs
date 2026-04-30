Function GCD(a,b)
	Do
		If a Mod b > 0 Then
			c = a Mod b
			a = b
			b = c
		Else
			GCD = b
			Exit Do
		End If
	Loop
End Function

WScript.Echo "The GCD of 48 and 18 is " & GCD(48,18) & "."
WScript.Echo "The GCD of 1280 and 240 is " & GCD(1280,240) & "."
WScript.Echo "The GCD of 1280 and 240 is " & GCD(3475689,23566319) & "."
WScript.Echo "The GCD of 1280 and 240 is " & GCD(123456789,234736437) & "."
