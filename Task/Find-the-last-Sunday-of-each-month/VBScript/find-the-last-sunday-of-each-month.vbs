strYear = WScript.StdIn.ReadLine

For i = 1 To 12
	d = DateSerial(strYear, i + 1, 1) - 1
	WScript.Echo d - Weekday(d) + 1
Next
