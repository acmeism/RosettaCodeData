' version 28-01-2019
' compile with: fbc -s console

Dim As String blocks(1 To 20, 1 To 2) => {{"B", "O"}, {"X", "K"}, {"D", "Q"}, _
{"C", "P"}, {"N", "A"}, {"G", "T"}, {"R", "E"}, {"T", "G"}, {"Q", "D"}, _
{"F", "S"}, {"J", "W"}, {"H", "U"}, {"V", "I"}, {"A", "N"}, {"O", "B"}, _
{"E", "R"}, {"F", "S"}, {"L", "Y"}, {"P", "C"}, {"Z", "M"}}

Dim As UInteger i, x, y, b()
Dim As String word, char
Dim As boolean possible

Do
    Read word
    If word = "" Then Exit Do
    word = UCase(word)
    ReDim b(1 To 20)
    possible = TRUE

    For i = 1 To Len(word)
        char = Mid(word, i, 1)

        For x = 1 To 20
            If b(x) = 0 Then
                If blocks(x, 1) = char Or blocks(x, 2) = char Then
                    b(x) = 1
                    Exit For
                End If
            End If
        Next
        If x = 21 Then possible = FALSE
    Next

    Print word, possible
Loop

Data  "A", "Bark", "Book", "Treat", "Common", "Squad", "Confuse", ""

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
