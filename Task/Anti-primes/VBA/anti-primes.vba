Private Function factors(n As Integer) As Collection
    Dim f As New Collection
    For i = 1 To Sqr(n)
        If n Mod i = 0 Then
            f.Add i
            If n / i <> i Then f.Add n / i
        End If
    Next i
    f.Add n
    Set factors = f
End Function
Public Sub anti_primes()
    Dim n As Integer, maxd As Integer
    Dim res As New Collection, lenght As Integer
    Dim lf As Integer
    n = 1: maxd = -1
    Length = 0
    Do While res.count < 20
        lf = factors(n).count
        If lf > maxd Then
            res.Add n
            maxd = lf
        End If
        n = n + IIf(n > 1, 2, 1)
    Loop
    Debug.Print "The first 20 anti-primes are:";
    For Each x In res
        Debug.Print x;
    Next x
End Sub
