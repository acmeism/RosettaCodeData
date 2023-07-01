Option Explicit

Sub Main()
Dim s As String, FF As Integer

'read a file line by line
FF = FreeFile
Open "C:\Users\" & Environ("username") & "\Desktop\input.txt" For Input As #FF
While Not EOF(FF)
    Line Input #FF, s
    Debug.Print s
Wend
Close #FF

'read a file
FF = FreeFile
Open "C:\Users\" & Environ("username") & "\Desktop\input.txt" For Input As #FF
    s = Input(LOF(1), #FF)
Close #FF
Debug.Print s

'write a file
FF = FreeFile
Open "C:\Users\" & Environ("username") & "\Desktop\output.txt" For Output As #FF
    Print #FF, s
Close #FF
End Sub
