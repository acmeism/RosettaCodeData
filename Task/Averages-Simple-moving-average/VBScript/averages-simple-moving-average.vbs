data = "1,2,3,4,5,5,4,3,2,1"
token = Split(data,",")
stream = ""
WScript.StdOut.WriteLine "Number" & vbTab & "SMA3" & vbTab & "SMA5"
For j = LBound(token) To UBound(token)
	If Len(stream) = 0 Then
		stream = token(j)
	Else
		stream = stream & "," & token(j)
	End If
	WScript.StdOut.WriteLine token(j) & vbTab & Round(SMA(stream,3),2) & vbTab & Round(SMA(stream,5),2)
Next

Function SMA(s,p)
	If Len(s) = 0 Then
		SMA = 0
		Exit Function
	End If
	d = Split(s,",")
	sum = 0
	If UBound(d) + 1 >= p Then
		c = 0
		For i = UBound(d) To LBound(d) Step -1
			sum = sum + Int(d(i))
			c = c + 1
			If c = p Then
				Exit For
			End If
		Next
		SMA = sum / p
	Else
		For i = UBound(d) To LBound(d) Step -1
			sum = sum + Int(d(i))
		Next
		SMA = sum / (UBound(d) + 1)
	End If
End Function
