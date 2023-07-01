Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
			"\readings.txt",1)
Set objDateStamp = CreateObject("Scripting.Dictionary")

Total_Records = 0
Valid_Records = 0
Duplicate_TimeStamps = ""

Do Until objFile.AtEndOfStream
	line = objFile.ReadLine
	If line <> "" Then
		token = Split(line,vbTab)
		If objDateStamp.Exists(token(0)) = False Then
			objDateStamp.Add token(0),""
			Total_Records = Total_Records + 1
			If IsValid(token) Then
				Valid_Records = Valid_Records + 1
			End If
		Else
			Duplicate_TimeStamps = Duplicate_TimeStamps & token(0) & vbCrLf
			Total_Records = Total_Records + 1
		End If
	End If 	
Loop

Function IsValid(arr)
	IsValid = True
	Bad_Readings = 0
	n = 1
	Do While n <= UBound(arr)
		If n + 1 <= UBound(arr) Then
			If CInt(arr(n+1)) < 1 Then
				Bad_Readings = Bad_Readings + 1	
			End If
		End If
		n = n + 2
	Loop
	If Bad_Readings > 0 Then
		IsValid = False
	End If
End Function

WScript.StdOut.Write "Total Number of Records = " & Total_Records
WScript.StdOut.WriteLine
WScript.StdOut.Write "Total Valid Records = " & Valid_Records
WScript.StdOut.WriteLine
WScript.StdOut.Write "Duplicate Timestamps:"
WScript.StdOut.WriteLine
WScript.StdOut.Write Duplicate_TimeStamps
WScript.StdOut.WriteLine

objFile.Close
Set objFSO = Nothing
