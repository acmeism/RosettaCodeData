text = "I need more coffee!!!"
Set regex = New RegExp
regex.Global = True
regex.Pattern = "\s"
If regex.Test(text) Then
	WScript.StdOut.Write regex.Replace(text,vbCrLf)
Else
	WScript.StdOut.Write "No matching pattern"
End If
