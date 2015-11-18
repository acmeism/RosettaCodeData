Function consolidate(s)
	sets = Split(s,",")
	n = UBound(sets)
	For i = 1 To n
		p = i
		ts = ""
		For j = i To 1 Step -1
			If ts = "" Then
				p = j
			End If
			ts = ""
			For k = 1 To Len(sets(p))
				If InStr(1,sets(j-1),Mid(sets(p),k,1)) = 0 Then
					ts = ts & Mid(sets(p),k,1)
				End If
			Next
			If Len(ts) < Len(sets(p)) Then
				sets(j-1) = sets(j-1) & ts
				sets(p) = "-"
				ts = ""
			Else
				p = i
			End If
		Next	
	Next
	consolidate = s & " = " & Join(sets," , ")
End Function

'testing
test = Array("AB","AB,CD","AB,CD,DB","HIK,AB,CD,DB,FGH")
For Each t In test
	WScript.StdOut.WriteLine consolidate(t)
Next
