Function IsLeapYear(yr)
	IsLeapYear = False
	If yr Mod 4 = 0 And (yr Mod 400 = 0 Or yr Mod 100 <> 0) Then
		IsLeapYear = True
	End If
End Function

'Testing the function.
arr_yr = Array(1900,1972,1997,2000,2001,2004)

For Each yr In arr_yr
	If IsLeapYear(yr) Then
		WScript.StdOut.WriteLine yr & " is leap year."
	Else
		WScript.StdOut.WriteLine yr & " is NOT leap year."
	End If
Next
