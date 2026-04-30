Function compound_duration(n)
	Do Until n = 0
		If n >= 604800 Then
			wk = Int(n/604800)
			n = n-(604800*wk)
			compound_duration = compound_duration & wk & " wk"
		End If
		If n >= 86400 Then
			d = Int(n/86400)
			n = n-(86400*d)
			If wk > 0 Then compound_duration = compound_duration & ", " End If
			compound_duration = compound_duration & d & " d"
		End If
		If n >= 3600 Then
			hr = Int(n/3600)
			n = n-(3600*hr)
			If d > 0 Then compound_duration = compound_duration & ", " End If
			compound_duration = compound_duration & hr & " hr"
		End If
		If n >= 60 Then
			min = Int(n/60)
			n = n-(60*min)
			If hr > 0 Then compound_duration = compound_duration & ", " End If
			compound_duration = compound_duration & min & " min"
		End If
		If n > 0 Then
			If min > 0 Then compound_duration = compound_duration & ", " End If
			compound_duration = compound_duration & ", " & n & " sec"
			n = 0
		End If
	Loop
End Function

'validating the function
WScript.StdOut.WriteLine compound_duration(7259)
WScript.StdOut.WriteLine compound_duration(86400)
WScript.StdOut.WriteLine compound_duration(6000000)
