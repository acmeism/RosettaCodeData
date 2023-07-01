Private Function ordinal(s As String) As String
    Dim irregs As New Collection
    irregs.Add "first", "one"
    irregs.Add "second", "two"
    irregs.Add "third", "three"
    irregs.Add "fifth", "five"
    irregs.Add "eighth", "eight"
    irregs.Add "ninth", "nine"
    irregs.Add "twelfth", "twelve"
    Dim i As Integer
    For i = Len(s) To 1 Step -1
        ch = Mid(s, i, 1)
        If ch = " " Or ch = "-" Then Exit For
    Next i
    On Error GoTo 1
    ord = irregs(Right(s, Len(s) - i))
    ordinal = Left(s, i) & ord
    Exit Function
1:
    If Right(s, 1) = "y" Then
        s = Left(s, Len(s) - 1) & "ieth"
    Else
        s = s & "th"
    End If
    ordinal = s
End Function
Public Sub ordinals()
    tests = [{1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003, 123, 00123.0, 1.23E2}]
    init
    For i = 1 To UBound(tests)
        Debug.Print ordinal(spell(tests(i)))
    Next i
End Sub
