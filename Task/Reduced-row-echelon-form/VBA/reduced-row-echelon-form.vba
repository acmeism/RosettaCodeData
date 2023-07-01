Private Function ToReducedRowEchelonForm(M As Variant) As Variant
    Dim lead As Integer: lead = 0
    Dim rowCount As Integer: rowCount = UBound(M)
    Dim columnCount As Integer: columnCount = UBound(M(0))
    Dim i As Integer
    For r = 0 To rowCount
        If lead >= columnCount Then
            Exit For
        End If
        i = r
        Do While M(i)(lead) = 0
            i = i + 1
            If i = rowCount Then
                i = r
                lead = lead + 1
                If lead = columnCount Then
                    Exit For
                End If
            End If
        Loop
        Dim tmp As Variant
        tmp = M(r)
        M(r) = M(i)
        M(i) = tmp
        If M(r)(lead) <> 0 Then
            div = M(r)(lead)
            For t = LBound(M(r)) To UBound(M(r))
                M(r)(t) = M(r)(t) / div
            Next t
        End If
        For j = 0 To rowCount
            If j <> r Then
                subt = M(j)(lead)
                For t = LBound(M(j)) To UBound(M(j))
                    M(j)(t) = M(j)(t) - subt * M(r)(t)
                Next t
            End If
        Next j
        lead = lead + 1
    Next r
    ToReducedRowEchelonForm = M
End Function

Public Sub main()
    r = ToReducedRowEchelonForm(Array( _
        Array(1, 2, -1, -4), _
        Array(2, 3, -1, -11), _
        Array(-2, 0, -3, 22)))
    For i = LBound(r) To UBound(r)
        Debug.Print Join(r(i), vbTab)
    Next i
End Sub
