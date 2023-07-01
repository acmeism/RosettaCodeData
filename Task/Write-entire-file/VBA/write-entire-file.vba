Option Explicit

Const strName As String = "MyFileText.txt"
Const Text As String = "(Over)write a file so that it contains a string. " & vbCrLf & _
           "The reverse of Read entire file—for when you want to update or " & vbCrLf & _
           "create a file which you would read in its entirety all at once."

Sub Main()
Dim Nb As Integer

Nb = FreeFile
Open "C:\Users\" & Environ("username") & "\Desktop\" & strName For Output As #Nb
    Print #1, Text
Close #Nb
End Sub
