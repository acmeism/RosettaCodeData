Private Function IsEqualOrAscending(myList) As String
Dim i&, boolEqual As Boolean, boolAsc As Boolean

    On Error Resume Next
    If UBound(myList) > 0 Then
        If Err.Number > 0 Then
            IsEqualOrAscending = "Error " & Err.Number & " : Empty array"
            On Error GoTo 0
            Exit Function
        Else
            For i = 1 To UBound(myList)
                If myList(i) <> myList(i - 1) Then boolEqual = True
                If myList(i) <= myList(i - 1) Then boolAsc = True
            Next
        End If
    End If
    IsEqualOrAscending = "List : " & Join(myList, ",") & ", IsEqual : " & (Not boolEqual) & ", IsAscending : " & Not boolAsc
End Function
