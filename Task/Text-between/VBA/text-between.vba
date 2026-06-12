Option Explicit

Private Const STRING_START As String = "Start"
Private Const STRING_END As String = "End"

Sub Main()
Dim Text As String, First As String, Last As String, Output As String
'Example 1. Both delimiters set
    Text = "Hello Rosetta Code world"
        First = "Hello "
            Last = " world"
    Output = "1- " & Text_Between(Text, First, Last) & vbCrLf
'Example 2. Start delimiter is the start of the string
    Text = "Hello Rosetta Code world"
        First = "Start"
            Last = " world"
    Output = Output & "2- " & Text_Between(Text, First, Last) & vbCrLf
'Example 3. End delimiter is the end of the string
    Text = "Hello Rosetta Code world"
        First = "Hello "
            Last = "End"
    Output = Output & "3- " & Text_Between(Text, First, Last) & vbCrLf
'Example 4. End delimiter appears before and after start delimiter
    Text = "</div><div style=\""chinese\"">你好嗎</div>..."
        First = "<div style=\""chinese\"">"
            Last = "</div>"
    Output = Output & "4- " & Text_Between(Text, First, Last) & vbCrLf
'Example 5. End delimiter not present
    Text = "<text>Hello <span>Rosetta Code</span> world</text><table style=\""myTable\"">"
        First = "<text>"
            Last = "<table>"
    Output = Output & "5- " & Text_Between(Text, First, Last) & vbCrLf
'Example 6. Start delimiter not present
    Text = "<table style=\""myTable\""><tr><td>hello world</td></tr></table>"
        First = "<table>"
            Last = "</table>"
    Output = Output & "6- " & Text_Between(Text, First, Last) & vbCrLf
'Example 7. Multiple instances of end delimiter after start delimiter (match until the first one)
    Text = "The quick brown fox jumps over the lazy other fox"
        First = "quick "
            Last = " fox"
    Output = Output & "7- " & Text_Between(Text, First, Last) & vbCrLf
'Example 8. Multiple instances of the start delimiter (start matching at the first one)
    Text = "One fish two fish red fish blue fish"
        First = "fish "
            Last = " red"
    Output = Output & "8- " & Text_Between(Text, First, Last) & vbCrLf
'Example 9. Start delimiter is end delimiter
    Text = "FooBarBazFooBuxQuux"
        First = "Foo"
            Last = "Foo"
    Output = Output & "9- " & Text_Between(Text, First, Last) & vbCrLf
'Example 10 : End delimiter appears before and NOT after start delimiter
    Text = "</div><div style=\""chinese\"">你好嗎..."
        First = "<div style=\""chinese\"">"
            Last = "</div>"
    Output = Output & "10- " & Text_Between(Text, First, Last) & vbCrLf
'Example 11. Text = ""
    Text = ""
        First = "Start"
            Last = "End"
    Output = Output & "11- " & Text_Between(Text, First, Last) & vbCrLf
'Example 12. Start and end delimiters use special values
    Text = "Hello Rosetta Code world"
        First = "Start"
            Last = "End"
    Output = Output & "12- " & Text_Between(Text, First, Last)
'Result :
    Debug.Print Output
End Sub

Private Function Text_Between(T$, F$, L$) As String
Dim i As Long
    i = InStr(T, L) + 1
    Select Case True
        Case T = "", F = "", InStr(T, F) = 0 And F <> STRING_START
            Text_Between = ""
        Case F = STRING_START And L = STRING_END
            Text_Between = T
        Case F = STRING_START
            Text_Between = Mid(T, 1, InStr(T, L) - 1)
        Case L = STRING_END, InStr(T, L) = 0, InStr(T, L) < InStr(T, F) And InStr(i, T, L) = 0
            Text_Between = Mid(T, Len(F) + InStr(T, F))
        Case F = L
            Text_Between = Mid(T, Len(F) + InStr(T, F), InStr(i, T, F) - Len(F) - 1)
        Case Else
            Text_Between = Mid(T, Len(F) + InStr(T, F), InStr(InStr(T, F), T, L) - (Len(F) + InStr(T, F)))
    End Select
End Function
