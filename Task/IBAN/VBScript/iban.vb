Function validate_iban(s)
	validate_iban = Chr(34) & s & Chr(34) & " is NOT valid."
	Set cn_len = CreateObject("Scripting.Dictionary")
	With cn_len
		.Add "AL",28 : .Add "AD",24 : .Add "AT",20 : .Add "AZ",28 : .Add "BH",22 : .Add "BE",16
		.Add "BA",20 : .Add "BR",29 : .Add "BG",22 : .Add "CR",21 : .Add "HR",21 : .Add "CY",28
		.Add "CZ",24 : .Add "DK",18 : .Add "DO",28 : .Add "EE",20 : .Add "FO",18 : .Add "FI",18
		.Add "FR",27 : .Add "GE",22 : .Add "DE",22 : .Add "GI",23 : .Add "GR",27 : .Add "GL",18
		.Add "GT",28 : .Add "HU",28 : .Add "IS",26 : .Add "IE",22 : .Add "IL",23 : .Add "IT",27
		.Add "JO",30 : .Add "KZ",20 : .Add "KW",30 : .Add "LV",21 : .Add "LB",28 : .Add "LI",21
		.Add "LT",20 : .Add "LU",20 : .Add "MK",19 : .Add "MT",31 : .Add "MR",27 : .Add "MU",30
		.Add "MC",27 : .Add "MD",24 : .Add "ME",22 : .Add "NL",18 : .Add "NO",15 : .Add "PK",24
		.Add "PS",29 : .Add "PL",28 : .Add "PT",25 : .Add "QA",29 : .Add "RO",24 : .Add "SM",27
		.Add "SA",24 : .Add "RS",22 : .Add "SK",24 : .Add "SI",19 : .Add "ES",24 : .Add "SE",24
		.Add "CH",21 : .Add "TN",24 : .Add "TR",26 : .Add "AE",23 : .Add "GB",22 : .Add "VG",24
	End With
	iban = Replace(s," ","")
	If cn_len.Exists(Left(iban,2)) And Len(iban) = cn_len.Item(Left(iban,2)) Then
		'move the first 4 characters to the end
		iban = Mid(iban,5,Len(iban)-4) & Left(iban,4)
		'convert letters to numbers A=10 to Z=35
		D = ""
		For i = 1 To Len(iban)
			If Asc(Mid(iban,i,1)) >= 65 And Asc(Mid(iban,i,1)) <= 90 Then
				D = D & CStr(Asc(Mid(iban,i,1)) - 55)
			Else
				D = D & Mid(iban,i,1)
			End If
		Next
		'piece-wise modulo calculation
		Do
			If Len(D) > 9 Then
				N = CLng(Left(D,9)) Mod 97
				D = CStr(N) & Mid(D,10,Len(D)-9)
			Else
				N = CLng(Left(D,9)) Mod 97
				Exit Do
			End If
		Loop
		If N = 1 Then
			validate_iban = Chr(34) & s & Chr(34) & " is valid."
		End If
	End If
End Function

'test several scenarios
WScript.StdOut.WriteLine validate_iban("GB82 WEST 1234 5698 7654 32")
WScript.StdOut.WriteLine validate_iban("GB82WEST12345698765432")
WScript.StdOut.WriteLine validate_iban("gb82 west 1234 5698 7654 32")
WScript.StdOut.WriteLine validate_iban("GB82 TEST 1234 5698 7654 32")
WScript.StdOut.WriteLine validate_iban("GR16 0110 1250 0000 0001 2300 695")
WScript.StdOut.WriteLine validate_iban("GB29 NWBK 6016 1331 9268 19")
WScript.StdOut.WriteLine validate_iban("SA03 8000 0000 6080 1016 7519")
WScript.StdOut.WriteLine validate_iban("CH93 0076 2011 6238 5295 7")
WScript.StdOut.WriteLine validate_iban("IL62 0108 0000 0009 9999 999")
WScript.StdOut.WriteLine validate_iban("IL62-0108-0000-0009-9999-999")
WScript.StdOut.WriteLine validate_iban("US12 3456 7890 0987 6543 210")
WScript.StdOut.WriteLine validate_iban("GR16 0110 1250 0000 0001 2300 695X")
