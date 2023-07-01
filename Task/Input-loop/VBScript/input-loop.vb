filepath = "SPECIFY PATH TO TEXT FILE HERE"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objInFile = objFSO.OpenTextFile(filepath,1,False,0)

Do Until objInFile.AtEndOfStream
	line = objInFile.ReadLine
	WScript.StdOut.WriteLine line
Loop

objInFile.Close
Set objFSO = Nothing
