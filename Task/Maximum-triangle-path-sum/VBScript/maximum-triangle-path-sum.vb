'Solution derived from http://stackoverflow.com/questions/8002252/euler-project-18-approach.

Set objfso = CreateObject("Scripting.FileSystemObject")
Set objinfile = objfso.OpenTextFile(objfso.GetParentFolderName(WScript.ScriptFullName) &_
	"\triangle.txt",1,False)
	
row = Split(objinfile.ReadAll,vbCrLf)

For i = UBound(row) To 0 Step -1
	row(i) = Split(row(i)," ")
	If i < UBound(row) Then
		For j = 0 To UBound(row(i))
			If (row(i)(j) + row(i+1)(j)) > (row(i)(j) + row(i+1)(j+1)) Then
				row(i)(j) = CInt(row(i)(j)) + CInt(row(i+1)(j))
			Else
				row(i)(j) = CInt(row(i)(j)) + CInt(row(i+1)(j+1))
			End If
		Next
	End If	
Next

WScript.Echo row(0)(0)

objinfile.Close
Set objfso = Nothing
