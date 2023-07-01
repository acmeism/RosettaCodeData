Function Luhn_Test(cc)
	cc = RevString(cc)
	s1 = 0
	s2 = 0
	For i = 1 To Len(cc)
		If i Mod 2 > 0 Then
			s1 = s1 + CInt(Mid(cc,i,1))
		Else
			tmp = CInt(Mid(cc,i,1))*2
			If  tmp < 10 Then
				s2 = s2 + tmp
			Else
				s2 = s2 + CInt(Right(CStr(tmp),1)) + 1
			End If
		End If
	Next
	If Right(CStr(s1 + s2),1) = "0" Then
		Luhn_Test = "Valid"
	Else
		Luhn_Test = "Invalid"
	End If
End Function

Function RevString(s)
	For i = Len(s) To 1 Step -1
		RevString = RevString & Mid(s,i,1)
	Next
End Function

WScript.Echo "49927398716 is " & Luhn_Test("49927398716")
WScript.Echo "49927398717 is " & Luhn_Test("49927398717")			
WScript.Echo "1234567812345678 is " & Luhn_Test("1234567812345678")
WScript.Echo "1234567812345670 is " & Luhn_Test("1234567812345670")
