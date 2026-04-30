arr = Array("710889",_
            "B0YBKJ",_
	    "406566",_
	    "B0YBLH",_
	    "228276",_
	    "B0YBKL",_
	    "557910",_
            "B0YBKR",_
	    "585284",_
	    "B0YBKT",_
	    "12345",_
	    "A12345",_
	    "B00030")

For j = 0 To UBound(arr)
	WScript.StdOut.Write arr(j) & getSEDOLCheckDigit(arr(j))
	WScript.StdOut.WriteLine
Next

Function getSEDOLCheckDigit(str)
	If Len(str) <> 6 Then
		getSEDOLCheckDigit = " is invalid. Only 6 character strings are allowed."
		Exit Function
	End If
	Set mult = CreateObject("Scripting.Dictionary")
	With mult
		.Add "1","1" : .Add "2", "3" : .Add "3", "1"
		.Add "4","7" : .Add "5", "3" : .Add "6", "9"
	End With
	total = 0
	For i = 1 To 6
		s  = Mid(str,i,1)
		If s = "A" Or s = "E" Or s = "I" Or s = "O" Or s = "U" Then
			getSEDOLCheckDigit = " is invalid. Vowels are not allowed."
			Exit Function
		End If
		If Asc(s) >= 48 And Asc(s) <=57 Then
			total = total + CInt(s) * CInt(mult.Item(CStr(i)))
		Else
			total = total + (Asc(s) - 55) * CInt(mult.Item(CStr(i)))
		End If
	Next
	getSEDOLCheckDigit = (10 - total Mod 10) Mod 10
End Function
