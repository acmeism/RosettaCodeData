Private Function Ackermann_function(m As Variant, n As Variant) As Variant
    Dim result As Variant
    Debug.Assert m >= 0
    Debug.Assert n >= 0
    If m = 0 Then
        result = CDec(n + 1)
    Else
        If n = 0 Then
            result = Ackermann_function(m - 1, 1)
        Else
            result = Ackermann_function(m - 1, Ackermann_function(m, n - 1))
        End If
    End If
    Ackermann_function = CDec(result)
End Function
Public Sub main()
    Debug.Print "           n=",
    For j = 0 To 7
        Debug.Print j,
    Next j
    Debug.Print
    For i = 0 To 3
        Debug.Print "m=" & i,
        For j = 0 To 7
            Debug.Print Ackermann_function(i, j),
        Next j
        Debug.Print
    Next i
End Sub
