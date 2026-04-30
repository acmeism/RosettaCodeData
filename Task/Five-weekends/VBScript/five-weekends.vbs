For y = 1900 To 2100
	For m = 1 To 12
		d = DateSerial(y, m + 1, 1) - 1
		If Day(d) = 31 And Weekday(d) = vbSunday Then
			WScript.Echo y & ", " & MonthName(m)
			i = i + 1
		End If
	Next
Next

WScript.Echo vbCrLf & "Total = " & i & " months"
