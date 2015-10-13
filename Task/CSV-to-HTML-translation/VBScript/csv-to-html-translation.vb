Set objfso = CreateObject("Scripting.FileSystemObject")

parent_folder = objfso.GetParentFolderName(WScript.ScriptFullName) & "\"

Set objcsv = objfso.OpenTextFile(parent_folder & "in.csv",1,False)
Set objhtml = objfso.OpenTextFile(paren_folder & "out.html",2,True)

objhtml.Write(csv_to_html(objcsv.ReadAll))

objcsv.Close
objhtml.Close
Set objfso = Nothing

Function csv_to_html(s)
	row = Split(s,vbCrLf)
	'write the header
	tmp = "<html><head><head/><body><table border=1 cellpadding=10 cellspacing=0>"
	For i = 0 To UBound(row)
		field = Split(row(i),",")
		If i = 0 Then
			tmp = tmp & "<tr><th>" & replace_chars(field(0)) & "</th><th>" & replace_chars(field(1)) & "</th><tr>"		
		Else
			tmp = tmp & "<tr><td>" & replace_chars(field(0)) & "</td><td>" & replace_chars(field(1)) & "</td><tr>"
		End If
	Next
	'write the footer
	tmp = tmp & "</table></body></html>"
	csv_to_html = tmp
End Function

Function replace_chars(s)
	replace_chars = Replace(Replace(s,"<","&lt;"),">","&gt;")
End Function
