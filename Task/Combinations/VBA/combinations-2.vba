Private Sub comb(ByVal pool As Integer, ByVal needed As Integer, Optional ByVal done As Integer = 0, Optional ByVal chosen As Variant)
    If needed = 0 Then  '-- got a full set
        For Each x In chosen: Debug.Print x;: Next x
        Debug.Print
        Exit Sub
    End If
    If done + needed > pool Then Exit Sub '-- cannot fulfil
    '-- get all combinations with and without the next item:
    done = done + 1
    Dim tmp As Variant
    tmp = chosen
    If IsMissing(chosen) Then
        ReDim tmp(1)
    Else
        ReDim Preserve tmp(UBound(chosen) + 1)
    End If
    tmp(UBound(tmp)) = done
    comb pool, needed - 1, done, tmp
    comb pool, needed, done, chosen
End Sub

Public Sub main()
    comb 5, 3
End Sub
