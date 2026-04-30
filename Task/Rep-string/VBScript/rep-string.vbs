Function rep_string(s)
	max_len = Int(Len(s)/2)
	tmp = ""
	If max_len = 0 Then
		rep_string = "No Repeating String"
		Exit Function
	End If
	For i = 1 To max_len
		If InStr(i+1,s,tmp & Mid(s,i,1))Then
			tmp = tmp & Mid(s,i,1)
		Else
			Exit For
		End If
	Next
	Do While Len(tmp) > 0
		If Mid(s,Len(tmp)+1,Len(tmp)) = tmp Then
			rep_string = tmp
			Exit Do
		Else
			tmp = Mid(tmp,1,Len(tmp)-1)
		End If
	Loop
	If Len(tmp) > 0 Then
		rep_string = tmp
	Else
		rep_string = "No Repeating String"
	End If
End Function

'testing the function
arr = Array("1001110011","1110111011","0010010010","1010101010",_
		"1111111111","0100101101","0100100","101","11","00","1")

For n = 0 To UBound(arr)
	WScript.StdOut.Write arr(n) & ": " & rep_string(arr(n))
	WScript.StdOut.WriteLine
Next
