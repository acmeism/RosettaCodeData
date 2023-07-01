' Read a file line by line
Sub Main()
    Dim fInput As String, fOutput As String 'File names
    Dim sInput As String, sOutput As String 'Lines
    fInput = "input.txt"
    fOutput = "output.txt"
    Open fInput For Input As #1
    Open fOutput For Output As #2
    While Not EOF(1)
        Line Input #1, sInput
        sOutput = Process(sInput) 'do something
        Print #2, sOutput
    Wend
    Close #1
    Close #2
End Sub 'Main
