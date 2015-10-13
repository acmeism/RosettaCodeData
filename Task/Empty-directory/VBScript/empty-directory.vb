Function IsDirEmpty(path)
	IsDirEmpty = False
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(path)
	If objFolder.Files.Count = 0 And objFolder.SubFolders.Count = 0 Then
		IsDirEmpty = True
	End If
End Function

'Test
WScript.StdOut.WriteLine IsDirEmpty("C:\Temp")
WScript.StdOut.WriteLine IsDirEmpty("C:\Temp\test")
