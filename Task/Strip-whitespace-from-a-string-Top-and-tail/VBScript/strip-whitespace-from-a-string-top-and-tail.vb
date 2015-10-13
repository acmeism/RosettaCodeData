Function LeftTrim(s)
	Set regex = New RegExp
	With regex
		.Pattern = "^\s*"
		If .Test(s) Then
			LeftTrim = .Replace(s,"")
		Else
			LeftTrim = s
		End If
	End With
End Function

Function RightTrim(s)
	Set regex = New RegExp
	With regex
		.Pattern = "\s*$"
		If .Test(s) Then
			RightTrim = .Replace(s,"")
		Else
			RightTrim = s
		End If
	End With
End Function

'testing the functions
WScript.StdOut.WriteLine LeftTrim("			   RosettaCode")
WScript.StdOut.WriteLine RightTrim("RosettaCode			  		")
WScript.StdOut.WriteLine LeftTrim(RightTrim("  	RosettaCode			  		"))
