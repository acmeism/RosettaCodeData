Private Function mul_inv(a As Long, n As Long) As Variant
    If n < 0 Then n = -n
    If a < 0 Then a = n - ((-a) Mod n)
    Dim t As Long: t = 0
    Dim nt As Long: nt = 1
    Dim r As Long: r = n
    Dim nr As Long: nr = a
    Dim q As Long
    Do While nr <> 0
        q = r \ nr
        tmp = t
        t = nt
        nt = tmp - q * nt
        tmp = r
        r = nr
        nr = tmp - q * nr
    Loop
    If r > 1 Then
        mul_inv = "a is not invertible"
    Else
        If t < 0 Then t = t + n
        mul_inv = t
    End If
End Function
Public Sub mi()
    Debug.Print mul_inv(42, 2017)
    Debug.Print mul_inv(40, 1)
    Debug.Print mul_inv(52, -217) '/* Pari semantics for negative modulus */
    Debug.Print mul_inv(-486, 217)
    Debug.Print mul_inv(40, 2018)
End Sub
