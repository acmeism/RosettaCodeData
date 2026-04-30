FilePath = "<SPECIFY FILE PATH HERE>"
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(FilePath,1)
Do Until objFile.AtEndOfStream
	WScript.Echo objFile.ReadLine
Loop
objFile.Close
Set objFSO = Nothing
