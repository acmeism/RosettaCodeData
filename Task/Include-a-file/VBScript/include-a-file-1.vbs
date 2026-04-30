Include "D:\include\pad.vbs"

Wscript.Echo lpad(12,14,"-")

Sub Include (file)
   dim fso: set fso = CreateObject("Scripting.FileSystemObject")
   if fso.FileExists(file) then ExecuteGlobal fso.OpenTextFile(file).ReadAll
End Sub
