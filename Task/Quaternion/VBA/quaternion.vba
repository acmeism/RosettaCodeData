Option Base 1
Private Function norm(q As Variant) As Double
    norm = Sqr(WorksheetFunction.SumSq(q))
End Function

Private Function negative(q) As Variant
    Dim res(4) As Double
    For i = 1 To 4
        res(i) = -q(i)
    Next i
    negative = res
End Function

Private Function conj(q As Variant) As Variant
    Dim res(4) As Double
    res(1) = q(1)
    For i = 2 To 4
        res(i) = -q(i)
    Next i
    conj = res
End Function

Private Function addr(r As Double, q As Variant) As Variant
    Dim res As Variant
    res = q
    res(1) = r + q(1)
    addr = res
End Function

Private Function add(q1 As Variant, q2 As Variant) As Variant
    add = WorksheetFunction.MMult(Array(1, 1), Array(q1, q2))
End Function

Private Function multr(r As Double, q As Variant) As Variant
    multr = WorksheetFunction.MMult(r, q)
End Function

Private Function mult(q1 As Variant, q2 As Variant)
    Dim res(4) As Double
    res(1) = q1(1) * q2(1) - q1(2) * q2(2) - q1(3) * q2(3) - q1(4) * q2(4)
    res(2) = q1(1) * q2(2) + q1(2) * q2(1) + q1(3) * q2(4) - q1(4) * q2(3)
    res(3) = q1(1) * q2(3) - q1(2) * q2(4) + q1(3) * q2(1) + q1(4) * q2(2)
    res(4) = q1(1) * q2(4) + q1(2) * q2(3) - q1(3) * q2(2) + q1(4) * q2(1)
    mult = res
End Function

Private Sub quats(q As Variant)
    Debug.Print q(1); IIf(q(2) < 0, " - " & Abs(q(2)), " + " & q(2));
    Debug.Print IIf(q(3) < 0, "i - " & Abs(q(3)), "i + " & q(3));
    Debug.Print IIf(q(4) < 0, "j - " & Abs(q(4)), "j + " & q(4)); "k"
End Sub

Public Sub quaternions()
    q = [{ 1, 2, 3, 4}]
    q1 = [{2, 3, 4, 5}]
    q2 = [{3, 4, 5, 6}]
    Dim r_ As Double
    r_ = 7#
    Debug.Print "q            = ";: quats q
    Debug.Print "q1           = ";: quats q1
    Debug.Print "q2           = ";: quats q2
    Debug.Print "r            = "; r_
    Debug.Print "norm(q)      = "; norm(q)
    Debug.Print "negative(q)  = ";: quats negative(q)
    Debug.Print "conjugate(q) = ";: quats conj(q)
    Debug.Print "r + q        = ";: quats addr(r_, q)
    Debug.Print "q1 + q2      = ";: quats add(q1, q2)
    Debug.Print "q * r        = ";: quats multr(r_, q)
    Debug.Print "q1 * q2      = ";: quats mult(q1, q2)
    Debug.Print "q2 * q1      = ";: quats mult(q2, q1)
End Sub
