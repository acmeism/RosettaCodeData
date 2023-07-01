Set objFSO = CreateObject("Scripting.FileSystemObject")

'Open the input csv file for reading. The file is in the same folder as the script.
Set objInFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
	"\in.csv",1)
	
'Create the output html file.
Set objOutHTML = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
	"\out.html",2,True)

'Write the html opening tags.
objOutHTML.Write "<html><head></head><body>" & vbCrLf

'Declare table properties.
objOutHTML.Write "<table border=1 cellpadding=10 cellspacing=0>" & vbCrLf

'Write column headers.
objOutHTML.Write "<tr><th></th><th>X</th><th>Y</th><th>Z</th></tr>" & vbCrLf

'Go through each line of the input csv file and write to the html output file.
n = 1
Do Until objInFile.AtEndOfStream
	line = objInFile.ReadLine
	If Len(line) > 0 Then
		token = Split(line,",")
		objOutHTML.Write "<tr align=""right""><td>" & n & "</td>"
		For i = 0 To UBound(token)
			objOutHTML.Write "<td>" & token(i) & "</td>"
		Next
		objOutHTML.Write "</tr>" & vbCrLf
	End If
	n = n + 1
Loop

'Write the html closing tags.
objOutHTML.Write "</table></body></html>"

objInFile.Close
objOutHTML.Close
Set objFSO = Nothing
