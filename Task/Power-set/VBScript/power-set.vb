Function Dec2Bin(n)
	q = n
	Dec2Bin = ""
	Do Until q = 0
		Dec2Bin = CStr(q Mod 2) & Dec2Bin
		q = Int(q / 2)
	Loop
	Dec2Bin = Right("00000" & Dec2Bin,6)
End Function

Function PowerSet(s)
	arrS = Split(s,",")
	PowerSet = "{"
	For i = 0 To 2^(UBound(arrS)+1)-1
		If i = 0 Then
			PowerSet = PowerSet & "{},"
		Else
			binS = Dec2Bin(i)
			PowerSet = PowerSet & "{"
			c = 0
			For j = Len(binS) To 1 Step -1
				If CInt(Mid(binS,j,1)) = 1 Then
					PowerSet = PowerSet & arrS(c) & ","	
				End If
				c = c + 1
			Next
			PowerSet = Mid(PowerSet,1,Len(PowerSet)-1) & "},"
		End If
	Next
	PowerSet = Mid(PowerSet,1,Len(PowerSet)-1) & "}"
End Function

WScript.StdOut.Write PowerSet("1,2,3,4")
