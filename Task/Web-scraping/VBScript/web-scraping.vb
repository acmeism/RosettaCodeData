Function GetUTC()
	url = "http://tycho.usno.navy.mil/cgi-bin/timer.pl"
	With CreateObject("MSXML2.XMLHTTP.6.0")
		.open "GET", url, False
		.send
		arrt = Split(.responseText,vbLf)
	End With
	For Each t In arrt
		If InStr(t,"UTC") Then
			GetUTC = StripHttpTags(t)
			Exit For
		End If
	Next
End Function

Function StripHttpTags(s)
	With New RegExp
		.Global = True
		.Pattern = "\<.+?\>"
		If .Test(s) Then
			StripHttpTags = .Replace(s,"")
		Else
			StripHttpTags = s
		End If
	End With
End Function

WScript.StdOut.Write GetUTC
WScript.StdOut.WriteLine
