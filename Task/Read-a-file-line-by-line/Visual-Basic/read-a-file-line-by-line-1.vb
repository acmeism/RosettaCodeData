' Read a file line by line
Sub Main()
    Dim fInput As String, fOutput As String 'File names
    Dim sInput As String, sOutput As String 'Lines
    Dim nRecord As Long
    fInput = "input.txt"
    fOutput = "output.txt"
    On Error GoTo InputError
    Open fInput For Input As #1
    On Error GoTo 0 'reset error handling
    Open fOutput For Output As #2
    nRecord = 0
    While Not EOF(1)
        Line Input #1, sInput
        sOutput = Process(sInput) 'do something
        nRecord = nRecord + 1
        Print #2, sOutput
    Wend
    Close #1
    Close #2
    Exit Sub
InputError:
    MsgBox "File: " & fInput & " not found"
End Sub 'Main
