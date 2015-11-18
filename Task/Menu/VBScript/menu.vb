Do
	WScript.StdOut.Write "1. fee fie" & vbCrLf
	WScript.StdOut.Write "2. huff puff" & vbCrLf
	WScript.StdOut.Write "3. mirror mirror" & vbCrLf
	WScript.StdOut.Write "4. tick tock" & vbCrLf
	WScript.StdOut.Write "Please Enter Your Choice: " & vbCrLf
	choice = WScript.StdIn.ReadLine
	Select Case choice
		Case "1"
			WScript.StdOut.Write "fee fie" & vbCrLf
			Exit Do
		Case "2"
			WScript.StdOut.Write "huff puff" & vbCrLf
			Exit Do
		Case "3"
			WScript.StdOut.Write "mirror mirror" & vbCrLf
			Exit Do
		Case "4"
			WScript.StdOut.Write "tick tock" & vbCrLf
			Exit Do
		Case Else
			WScript.StdOut.Write choice & " is an invalid choice. Please try again..." &_
				vbCrLf & vbCrLf
	End Select
Loop
