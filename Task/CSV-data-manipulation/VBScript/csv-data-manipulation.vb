'Instatiate FSO.
Set objFSO = CreateObject("Scripting.FileSystemObject")
'Open the CSV file for reading. The file is in the same folder as the script and named csv_sample.csv.
Set objInCSV = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) & "\csv_sample.csv",1,False)
'Set header status to account for the first line as the column headers.
IsHeader = True
'Initialize the var for the output string.
OutTxt = ""
'Read each line of the file.
Do Until objInCSV.AtEndOfStream
	line = objInCSV.ReadLine
	If IsHeader Then
		OutTxt = OutTxt & line & ",SUM" & vbCrLf
		IsHeader = False
	Else
		OutTxt = OutTxt & line & "," & AddElements(line) & vbCrLf
	End If
Loop
'Close the file.
objInCSV.Close
'Open the same file for writing.
Set objOutCSV = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) & "\csv_sample.csv",2,True)
'Write the var OutTxt to the file overwriting existing contents.
objOutCSV.Write OutTxt
'Close the file.
objOutCSV.Close
Set objFSO = Nothing

'Routine to add each element in a row.
Function AddElements(s)
	arr = Split(s,",")
	For i = 0 To UBound(arr)
		AddElements = AddElements + CInt(arr(i))
	Next
End Function
