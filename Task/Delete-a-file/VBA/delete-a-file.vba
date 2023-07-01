Option Explicit

Sub DeleteFileOrDirectory()
Dim myPath As String
    myPath = "C:\Users\surname.name\Desktop\Docs"
'delete file
    Kill myPath & "\input.txt"
'delete Directory
    RmDir myPath
End Sub
