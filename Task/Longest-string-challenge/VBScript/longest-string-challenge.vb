'Read the input file.  This assumes that the file is in the same
'directory as the script.
Set objfso = CreateObject("Scripting.FileSystemObject")
Set objfile = objfso.OpenTextFile(objfso.GetParentFolderName(WScript.ScriptFullName) &_
	"\input.txt",1)

list = ""
previous_line = ""
l = Len(previous_line)

Do Until objfile.AtEndOfStream
	current_line = objfile.ReadLine
	If Mid(current_line,l+1,1) <> "" Then
		list = current_line & vbCrLf
		previous_line = current_line
		l = Len(previous_line)
	ElseIf Mid(current_line,l,1) <> ""  And Mid(current_line,(l+1),1) = "" Then
		list = list & current_line & vbCrLf
	End If
Loop

WScript.Echo list

objfile.Close
Set objfso = Nothing
