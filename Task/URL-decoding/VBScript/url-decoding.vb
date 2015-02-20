Function UrlDecode(s)
	For i = 1 To Len(s)
		If Mid(s,i,1) = "%" Then
			UrlDecode = UrlDecode & Chr("&H" & Mid(s,i+1,2))
			i = i + 2
		Else
			UrlDecode = UrlDecode & Mid(s,i,1)
		End If
	Next
End Function

url = "http%3A%2F%2Ffoo%20bar%2F"
WScript.Echo "Encoded URL: " & url & vbCrLf &_
	"Decoded URL: " & UrlDecode(url)
