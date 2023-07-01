Sub show_files(folder_path,pattern)
	Set objfso = CreateObject("Scripting.FileSystemObject")
	For Each file In objfso.GetFolder(folder_path).Files
		If InStr(file.Name,pattern) Then
			WScript.StdOut.WriteLine file.Name
		End If
	Next
End Sub

Call show_files("C:\Windows",".exe")
