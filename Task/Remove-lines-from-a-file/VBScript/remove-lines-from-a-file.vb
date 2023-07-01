Sub remove_lines(filepath,start,number)
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set InFile = objFSO.OpenTextFile(filepath,1,False)
	line_count = 1
	discard_count = 1
	out_txt = ""
	Do Until InFile.AtEndOfStream
		line = InFile.ReadLine
		If line_count <> start Then
			If InFile.AtEndOfStream = False Then
				out_txt = out_txt & line & vbCrLf
			Else
				out_txt = out_txt & line
			End If
			line_count = line_count + 1
		Else
			Do Until discard_count = number
				InFile.SkipLine
				discard_count = discard_count + 1
			Loop
		line_count = line_count + 1
		End If
	Loop
	InFile.Close
	Set OutFile = objFSO.OpenTextFile(filepath,2,False)
	OutFile.Write(out_txt)
	OutFile.Close
	Set objFSO = Nothing
End Sub

Call remove_lines("C:\Test.txt",3,4)
