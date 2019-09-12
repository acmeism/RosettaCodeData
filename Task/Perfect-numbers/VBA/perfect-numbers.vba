Private Function Factors(x As Long) As String
    Application.Volatile
    Dim i As Long
    Dim cooresponding_factors As String
    Factors = 1
    corresponding_factors = x
    For i = 2 To Sqr(x)
        If x Mod i = 0 Then
            Factors = Factors & ", " & i
            If i <> x / i Then corresponding_factors = x / i & ", " & corresponding_factors
        End If
    Next i
    If x <> 1 Then Factors = Factors & ", " & corresponding_factors
End Function
Private Function is_perfect(n As Long)
    fs = Split(Factors(n), ", ")
    Dim f() As Long
    ReDim f(UBound(fs))
    For i = 0 To UBound(fs)
        f(i) = Val(fs(i))
    Next i
    is_perfect = WorksheetFunction.Sum(f) - n = n
End Function
Public Sub main()
    Dim i As Long
    For i = 2 To 100000
        If is_perfect(i) Then Debug.Print i
    Next i
End Sub
