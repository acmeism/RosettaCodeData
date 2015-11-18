Function mad_libs(s)
	Do
		If InStr(1,s,"<") <> 0 Then
			start_position = InStr(1,s,"<") + 1
			end_position = InStr(1,s,">")
			parse_string = Mid(s,start_position,end_position-start_position)
			WScript.StdOut.Write parse_string & "? "
			input_string = WScript.StdIn.ReadLine
			s = Replace(s,"<" & parse_string & ">",input_string)
		Else
			Exit Do
		End If
	Loop
	mad_libs = s
End Function

WScript.StdOut.Write mad_libs("<name> went for a walk in the park. <he or she> found a <noun>. <name> decided to take it home.")
WScript.StdOut.WriteLine
