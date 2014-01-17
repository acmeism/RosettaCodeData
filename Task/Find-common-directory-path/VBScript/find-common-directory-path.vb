' Read the list of paths (newline-separated) into an array...
strPaths = Split(WScript.StdIn.ReadAll, vbCrLf)

' Split each path by the delimiter (/)...
For i = 0 To UBound(strPaths)
	strPaths(i) = Split(strPaths(i), "/")
Next

With CreateObject("Scripting.FileSystemObject")

	' Test each path segment...
	For j = 0 To UBound(strPaths(0))
		
		' Test each successive path against the first...
		For i = 1 To UBound(strPaths)
			If strPaths(0)(j) <> strPaths(i)(j) Then Exit For
		Next

		' If we didn't make it all the way through, exit the block...
		If i <= UBound(strPaths) Then Exit For
		
		' Make sure this path exists...
		If Not .FolderExists(strPath & strPaths(0)(j) & "/") Then Exit For
		strPath = strPath & strPaths(0)(j) & "/"
		
	Next

End With

' Remove the final "/"...
WScript.Echo Left(strPath, Len(strPath) - 1)
