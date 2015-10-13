Sub truncate(fpath,n)
	'Check if file exist
	Set objfso = CreateObject("Scripting.FileSystemObject")
	If objfso.FileExists(fpath) = False Then
		WScript.Echo fpath & " does not exist"
		Exit Sub
	End If
	content = ""
	'stream the input file
	Set objinstream = CreateObject("Adodb.Stream")
	With objinstream
		.Type = 1
		.Open
		.LoadFromFile(fpath)
		'check if the specified size is larger than the file content
		If n <= .Size Then
			content = .Read(n)
		Else
			WScript.Echo "The specified size is larger than the file content"
			Exit Sub
		End If
		.Close
	End With
	'write the truncated version
	Set objoutstream = CreateObject("Adodb.Stream")
	With objoutstream
		.Type = 1
		.Open
		.Write content
		.SaveToFile fpath,2
		.Close
	End With
	Set objinstream = Nothing
	Set objoutstream = Nothing
	Set objfso = Nothing
End Sub

'testing
Call truncate("C:\temp\test.txt",30)
