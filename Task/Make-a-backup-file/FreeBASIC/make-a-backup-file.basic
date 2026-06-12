Sub saveWithBackup(filePath As String, lines() As String)
    Dim As String origPath = filePath
    If Len(Dir(origPath)) > 0 Then
        Dim As String backupPath = origPath & ".backup"
        Name(origPath, backupPath)  'Renames a file on disk
    End If
    Open origPath For Output As #1
    For i As Integer = 1 To Ubound(lines)
        Print #1, lines(i)
    Next i
    Close #1
End Sub

Dim lines(1 To 3) As String => {"fourth", "fifth", "sixth"}
saveWithBackup("original.txt", lines())

Dim As String linea
' check it worked
Print "Current contents of original.txt:"
Open "original.txt" For Input As #1
While Not Eof(1)
    Line Input #1, linea
    Print linea
Wend
Close #1

Print !"\nContents of original.txt.backup:"
Open "original.txt.backup" For Input As #1
While Not Eof(1)
    Line Input #1, linea
    Print linea
Wend
Close #1

Sleep
