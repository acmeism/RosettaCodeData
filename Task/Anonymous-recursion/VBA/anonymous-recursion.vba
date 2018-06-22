Sub Main()
Debug.Print F(-10)
Debug.Print F(10)
End Sub

Private Function F(N As Long) As Variant
    If N < 0 Then
        F = "Error. Negative argument"
    ElseIf N <= 1 Then
        F = N
    Else
        F = F(N - 1) + F(N - 2)
    End If
End Function
