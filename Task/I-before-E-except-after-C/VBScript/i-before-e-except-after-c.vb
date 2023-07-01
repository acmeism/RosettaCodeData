Set objFSO = CreateObject("Scripting.FileSystemObject")
Set srcFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
	"\unixdict.txt",1,False,0)
	
cei = 0 : cie = 0 : ei = 0 : ie = 0

Do Until srcFile.AtEndOfStream
	word = srcFile.ReadLine
	If InStr(word,"cei") Then
		cei = cei + 1
	ElseIf InStr(word,"cie") Then
		cie = cie + 1
	ElseIf InStr(word,"ei") Then
		ei = ei + 1
	ElseIf InStr(word,"ie") Then
		ie = ie + 1
	End If
Loop

FirstClause = False
SecondClause = False
Overall = False

'testing the first clause
If  ie > ei*2 Then
	WScript.StdOut.WriteLine "I before E when not preceded by C is plausible."
	FirstClause = True
Else
	WScript.StdOut.WriteLine "I before E when not preceded by C is NOT plausible."
End If

'testing the second clause
If cei > cie*2 Then
	WScript.StdOut.WriteLine "E before I when not preceded by C is plausible."
	SecondClause = True
Else
	WScript.StdOut.WriteLine "E before I when not preceded by C is NOT plausible."
End If

'overall clause
If FirstClause And SecondClause Then
	WScript.StdOut.WriteLine "Overall it is plausible."
Else
	WScript.StdOut.WriteLine "Overall it is NOT plausible."
End If

srcFile.Close
Set objFSO = Nothing
