Public Const precision = 10000
Private Function continued_fraction(steps As Integer, rid_a As String, rid_b As String) As Double
    Dim res As Double
    res = 0
    For n = steps To 1 Step -1
       res = Application.Run(rid_b, n) / (Application.Run(rid_a, n) + res)
    Next n
    continued_fraction = Application.Run(rid_a, 0) + res
End Function

Function sqr2_a(n As Integer) As Integer
    sqr2_a = IIf(n = 0, 1, 2)
End Function

Function sqr2_b(n As Integer) As Integer
    sqr2_b = 1
End Function

Function nap_a(n As Integer) As Integer
    nap_a = IIf(n = 0, 2, n)
End Function

Function nap_b(n As Integer) As Integer
    nap_b = IIf(n = 1, 1, n - 1)
End Function

Function pi_a(n As Integer) As Integer
    pi_a = IIf(n = 0, 3, 6)
End Function

Function pi_b(n As Integer) As Long
    pi_b = IIf(n = 1, 1, (2 * n - 1) ^ 2)
End Function

Public Sub main()
    Debug.Print "Precision:", precision
    Debug.Print "Sqr(2):", continued_fraction(precision, "sqr2_a", "sqr2_b")
    Debug.Print "Napier:", continued_fraction(precision, "nap_a", "nap_b")
    Debug.Print "Pi:", continued_fraction(precision, "pi_a", "pi_b")
End Sub
