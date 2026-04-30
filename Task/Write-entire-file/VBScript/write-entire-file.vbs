Set objFSO = CreateObject("Scripting.FileSystemObject")

SourceFile = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\out.txt"
Content = "(Over)write a file so that it contains a string." & vbCrLf &_
		"The reverse of Read entire file—for when you want to update or create a file which you would read in its entirety all at once."
		
With objFSO.OpenTextFile(SourceFile,2,True,0)
	.Write Content
	.Close
End With

Set objFSO = Nothing
