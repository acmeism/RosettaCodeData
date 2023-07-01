Option Base 1
Private Function Identity(n As Integer) As Variant
    Dim I() As Variant
    ReDim I(n, n)
    For j = 1 To n
        For k = 1 To n
            I(j, k) = 0
        Next k
    Next j
    For j = 1 To n
        I(j, j) = 1
    Next j
    Identity = I
End Function
 Function MatrixExponentiation(ByVal x As Variant, ByVal n As Integer) As Variant
    If n < 0 Then
        x = WorksheetFunction.MInverse(x)
        n = -n
    End If
    If n = 0 Then
        MatrixExponentiation = Identity(UBound(x))
        Exit Function
    End If
    Dim y() As Variant
    y = Identity(UBound(x))
    Do While n > 1
        If n Mod 2 = 0 Then
            x = WorksheetFunction.MMult(x, x)
            n = n / 2
        Else
            y = WorksheetFunction.MMult(x, y)
            x = WorksheetFunction.MMult(x, x)
            n = (n - 1) / 2
        End If
    Loop
    MatrixExponentiation = WorksheetFunction.MMult(x, y)
End Function
Public Sub pp(x As Variant)
    For i_ = 1 To UBound(x)
        For j_ = 1 To UBound(x)
            Debug.Print x(i_, j_),
        Next j_
        Debug.Print
    Next i_
End Sub
Public Sub main()
    M2 = [{3,2;2,1}]
    M3 = [{1,2,0;0,3,1;1,0,0}]
    pp MatrixExponentiation(M2, -1)
    Debug.Print
    pp MatrixExponentiation(M2, 0)
    Debug.Print
    pp MatrixExponentiation(M2, 10)
    Debug.Print
    pp MatrixExponentiation(M3, 10)
End Sub
