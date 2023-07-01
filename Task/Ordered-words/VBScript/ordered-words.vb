Set objFSO = CreateObject("Scripting.FileSystemObject")
Set infile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) & "\" &_
			"unixdict.txt",1)
list = ""
length = 0

Do Until inFile.AtEndOfStream
	line = infile.ReadLine
	If IsOrdered(line) Then
		If Len(line) > length Then
			length = Len(line)
			list = line & vbCrLf
		ElseIf Len(line) = length Then
			list = list & line & vbCrLf
		End If
	End If
Loop

WScript.StdOut.Write list

Function IsOrdered(word)
	IsOrdered = True
	prev_val = 0
	For i = 1 To Len(word)
		If i = 1 Then
			prev_val = Asc(Mid(word,i,1))
		ElseIf Asc(Mid(word,i,1)) >= prev_val Then
			prev_val = Asc(Mid(word,i,1))
		Else
			IsOrdered = False
			Exit For
		End If
	Next
End Function
