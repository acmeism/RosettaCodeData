Public Sub create_file()
    Dim FileNumber As Integer
    FileNumber = FreeFile
    MkDir "docs"
    Open "docs\output.txt" For Output As #FreeFile
    Close #FreeFile
    MkDir "C:\docs"
    Open "C:\docs\output.txt" For Output As #FreeFile
    Close #FreeFile
End Sub
