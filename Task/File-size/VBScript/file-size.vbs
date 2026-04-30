With CreateObject("Scripting.FileSystemObject")
	WScript.Echo .GetFile("input.txt").Size
	WScript.Echo .GetFile("\input.txt").Size
End With
