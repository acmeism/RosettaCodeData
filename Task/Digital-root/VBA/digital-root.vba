Option Base 1
Private Sub digital_root(n As Variant)
    Dim s As String, t() As Integer
    s = CStr(n)
    ReDim t(Len(s))
    For i = 1 To Len(s)
        t(i) = Mid(s, i, 1)
    Next i
    Do
        dr = WorksheetFunction.Sum(t)
        s = CStr(dr)
        ReDim t(Len(s))
        For i = 1 To Len(s)
            t(i) = Mid(s, i, 1)
        Next i
        persistence = persistence + 1
    Loop Until Len(s) = 1
    Debug.Print n; "has additive persistence"; persistence; "and digital root of "; dr & ";"
End Sub
Public Sub main()
    digital_root 627615
    digital_root 39390
    digital_root 588225
    digital_root 393900588225#
End Sub
