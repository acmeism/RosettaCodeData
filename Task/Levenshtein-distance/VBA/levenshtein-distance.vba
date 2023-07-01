Option Base 1
Function levenshtein(s1 As String, s2 As String) As Integer
    Dim n As Integer: n = Len(s1) + 1
    Dim m As Integer: m = Len(s2) + 1
    Dim d() As Integer, i As Integer, j As Integer
    ReDim d(n, m)

    If n = 1 Then
        levenshtein = m - 1
        Exit Function
    Else
        If m = 1 Then
            levenshtein = n - 1
            Exit Function
        End If
    End If

    For i = 1 To n
        d(i, 1) = i - 1
    Next i

    For j = 1 To m
        d(1, j) = j - 1
    Next j

    For i = 2 To n
        For j = 2 To m
            d(i, j) = WorksheetFunction.Min( _
                           d(i - 1, j) + 1, _
                           d(i, j - 1) + 1, _
                           (d(i - 1, j - 1) - (Mid(s1, i - 1, 1) <> Mid(s2, j - 1, 1))) _
                           )
        Next j
    Next i

    levenshtein = d(n, m)
End Function
Public Sub main()
    Debug.Print levenshtein("kitten", "sitting")
    Debug.Print levenshtein("rosettacode", "raisethysword")
End Sub
