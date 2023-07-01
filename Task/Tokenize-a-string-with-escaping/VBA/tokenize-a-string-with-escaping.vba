Private Function tokenize(s As String, sep As String, esc As String) As Collection
    Dim ret As New Collection
    Dim this As String
    Dim skip As Boolean

    If Len(s) <> 0 Then
        For i = 1 To Len(s)
            si = Mid(s, i, 1)
            If skip Then
                this = this & si
                skip = False
            Else
                If si = esc Then
                    skip = True
                Else
                    If si = sep Then
                        ret.Add this
                        this = ""
                    Else
                        this = this & si
                    End If
                End If
            End If
        Next i
        ret.Add this
    End If
    Set tokenize = ret
End Function

Public Sub main()
    Dim out As Collection
    Set out = tokenize("one^|uno||three^^^^|four^^^|^cuatro|", "|", "^")
    Dim outstring() As String
    ReDim outstring(out.Count - 1)
    For i = 0 To out.Count - 1
        outstring(i) = out(i + 1)
    Next i
    Debug.Print Join(outstring, ", ")
End Sub
