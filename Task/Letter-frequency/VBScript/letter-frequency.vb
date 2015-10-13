filepath = "SPECIFY FILE PATH HERE"

Set objfso = CreateObject("Scripting.FileSystemObject")
Set objdict = CreateObject("Scripting.Dictionary")
Set objfile = objfso.OpenTextFile(filepath,1)

txt = objfile.ReadAll

For i = 1 To Len(txt)
	char = Mid(txt,i,1)
	If objdict.Exists(char) Then
		objdict.Item(char) = objdict.Item(char) + 1
	Else
		objdict.Add char,1
	End If
Next

For Each key In objdict.Keys
	WScript.StdOut.WriteLine key & " = " & objdict.Item(key)
Next	

objfile.Close
Set objfso = Nothing
Set objdict = Nothing
