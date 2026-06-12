Function lcp(s)
	'declare an array
	str = Split(s,",")
	'indentify the length of the shortest word in the array
	For i = 0 To UBound(str)
		If i = 0 Then
			l = Len(str(i))
		ElseIf Len(str(i)) < l Then
			l = Len(str(i))
		End If
	Next
	'check prefixes and increment index
	idx = 0
	For j = 1 To l
		For k = 0 To UBound(str)
			If UBound(str) = 0 Then
				idx = Len(str(0))
			Else
				If k = 0 Then
					tstr = Mid(str(k),j,1)
				ElseIf k <> UBound(str) Then
					If Mid(str(k),j,1) <> tstr Then
						Exit For
					End If
				Else
					If Mid(str(k),j,1) <> tstr Then
						Exit For
					Else
						idx = idx + 1
					End If
				End If	
			End If
		Next
		If idx = 0 Then
			Exit For
		End If
	Next
	'return lcp
	If idx = 0 Then
		lcp = "No Matching Prefix"
	Else
		lcp = Mid(str(0),1,idx)
	End If
End Function

'Calling the function for test cases.
test = Array("interspecies,interstellar,interstate","throne,throne","throne,dungeon","cheese",_
		"","prefix,suffix")
		
For n = 0 To UBound(test)
	WScript.StdOut.Write "Test case " & n & " " & test(n) & " = " & lcp(test(n))
	WScript.StdOut.WriteLine
Next
