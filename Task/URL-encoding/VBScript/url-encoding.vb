Function UrlEncode(url)
	For i = 1 To Len(url)
		n = Asc(Mid(url,i,1))
		If (n >= 48 And n <=57) Or (n >= 65 And n <= 90) _
			Or (n >= 97 And n <= 122) Then
			UrlEncode = UrlEncode & Mid(url,i,1)
		Else
			UrlEncode = UrlEncode & "%" & Hex(Asc(Mid(url,i,1)))
		End If
	Next
End Function

WScript.Echo UrlEncode("http://foo bar/")
