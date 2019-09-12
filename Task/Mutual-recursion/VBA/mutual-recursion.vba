Private Function F(ByVal n As Integer) As Integer
    If n = 0 Then
        F = 1
    Else
        F = n - M(F(n - 1))
    End If
End Function

Private Function M(ByVal n As Integer) As Integer
    If n = 0 Then
        M = 0
    Else
        M = n - F(M(n - 1))
    End If
End Function

Public Sub MR()
    Dim i As Integer
    For i = 0 To 20
        Debug.Print F(i);
    Next i
    Debug.Print
    For i = 0 To 20
        Debug.Print M(i);
    Next i
End Sub
