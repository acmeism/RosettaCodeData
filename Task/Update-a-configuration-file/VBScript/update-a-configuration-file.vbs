Set objFSO = CreateObject("Scripting.FileSystemObject")

'Paramater lookups
Set objParamLookup = CreateObject("Scripting.Dictionary")
With objParamLookup
	.Add "FAVOURITEFRUIT", "banana"
	.Add "NEEDSPEELING", ""
	.Add "SEEDSREMOVED", ""
	.Add "NUMBEROFBANANAS", "1024"
	.Add "NUMBEROFSTRAWBERRIES", "62000"
End With

'Open the config file for reading.
Set objInFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
	"\IN_config.txt",1)
'Initialize output.
Output = ""	
Isnumberofstrawberries = False
With objInFile
	Do Until .AtEndOfStream
		line = .ReadLine
		If Left(line,1) = "#" Or line = "" Then
			Output = Output & line & vbCrLf
		ElseIf Left(line,1) = " " And InStr(line,"#") Then
			Output = Output & Mid(line,InStr(1,line,"#"),1000) & vbCrLf
		ElseIf Replace(Replace(line,";","")," ","") <> "" Then
			If InStr(1,line,"FAVOURITEFRUIT",1) Then
				Output = Output & "FAVOURITEFRUIT" & " " & objParamLookup.Item("FAVOURITEFRUIT") & vbCrLf
			ElseIf InStr(1,line,"NEEDSPEELING",1) Then
				Output = Output & "; " & "NEEDSPEELING" & vbCrLf
			ElseIf InStr(1,line,"SEEDSREMOVED",1) Then
				Output = Output & "SEEDSREMOVED" & vbCrLf
			ElseIf InStr(1,line,"NUMBEROFBANANAS",1) Then
				Output = Output & "NUMBEROFBANANAS" & " " & objParamLookup.Item("NUMBEROFBANANAS") & vbCrLf
			ElseIf InStr(1,line,"NUMBEROFSTRAWBERRIES",1) Then
				Output = Output & "NUMBEROFSTRAWBERRIES" & " " & objParamLookup.Item("NUMBEROFSTRAWBERRIES") & vbCrLf
				Isnumberofstrawberries = True
			End If
		End If
	Loop
	If Isnumberofstrawberries = False Then
		Output = Output & "NUMBEROFSTRAWBERRIES" & " " & objParamLookup.Item("NUMBEROFSTRAWBERRIES") & vbCrLf
		Isnumberofstrawberries = True
	End If
	.Close
End With
	
'Create a new config file.
Set objOutFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
	"\OUT_config.txt",2,True)
With objOutFile
	.Write Output
	.Close
End With

Set objFSO = Nothing
Set objParamLookup = Nothing
