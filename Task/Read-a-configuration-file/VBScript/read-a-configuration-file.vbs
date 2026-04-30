Set ofso = CreateObject("Scripting.FileSystemObject")
Set config = ofso.OpenTextFile(ofso.GetParentFolderName(WScript.ScriptFullName)&"\config.txt",1)

config_out = ""

Do Until config.AtEndOfStream
	line = config.ReadLine
	If Left(line,1) <> "#" And Len(line) <> 0 Then
		config_out = config_out & parse_var(line) & vbCrLf
	End If
Loop

WScript.Echo config_out

Function parse_var(s)
	'boolean false
	If InStr(s,";") Then
		parse_var = Mid(s,InStr(1,s,";")+2,Len(s)-InStr(1,s,";")+2) & " = FALSE"
	'boolean true
	ElseIf UBound(Split(s," ")) = 0 Then
		parse_var = s & " = TRUE"
	'multiple parameters
	ElseIf InStr(s,",") Then
		var = Left(s,InStr(1,s," ")-1)
		params = Split(Mid(s,InStr(1,s," ")+1,Len(s)-InStr(1,s," ")+1),",")
		n = 1 : tmp = ""
		For i = 0 To UBound(params)
			parse_var = parse_var & var & "(" & n & ") = " & LTrim(params(i)) & vbCrLf
			n = n + 1
		Next
	'single var and paramater
	Else
		parse_var = Left(s,InStr(1,s," ")-1) & " = " & Mid(s,InStr(1,s," ")+1,Len(s)-InStr(1,s," ")+1)
	End If
End Function

config.Close
Set ofso = Nothing
