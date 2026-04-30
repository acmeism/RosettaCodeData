Option Explicit

Dim objFSO, objInFile, objOutFile
Dim srcDir, line

Set objFSO = CreateObject("Scripting.FileSystemObject")

srcDir = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\"

Set objInFile = objFSO.OpenTextFile(srcDir & "In.txt",1,False,0)

Set objOutFile = objFSO.OpenTextFile(srcDir & "Out.txt",2,True,0)

Do Until objInFile.AtEndOfStream
	line = objInFile.ReadLine
	If line = "" Then
		objOutFile.WriteLine ""
	Else
		objOutFile.WriteLine Reverse_String(line)
	End If
Loop

Function Reverse_String(s)
	Dim arr, i
	arr = Split(s," ")
	For i = UBound(arr) To LBound(arr) Step -1
		If arr(i) <> "" Then
			If i = UBound(arr) Then
				Reverse_String = Reverse_String & arr(i)
			Else
				Reverse_String = Reverse_String & " " & arr(i)
			End If
		End If
	Next
End Function

objInFile.Close
objOutFile.Close
Set objFSO = Nothing
