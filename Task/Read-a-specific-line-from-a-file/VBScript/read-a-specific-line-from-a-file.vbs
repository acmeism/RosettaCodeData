Function read_line(filepath,n)
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.OpenTextFile(filepath,1)
	arrLines = Split(objFile.ReadAll,vbCrLf)
	If UBound(arrLines) >= n-1 Then
		If arrLines(n-1) <> "" Then
			read_line = arrLines(n-1)
		Else
			read_line = "Line " & n & " is null."
		End If
	Else
		read_line = "Line " & n & " does not exist."
	End If
	objFile.Close
	Set objFSO = Nothing
End Function

WScript.Echo read_line("c:\temp\input.txt",7)
