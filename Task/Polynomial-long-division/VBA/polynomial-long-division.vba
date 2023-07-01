Option Base 1
Function degree(p As Variant)
    For i = UBound(p) To 1 Step -1
        If p(i) <> 0 Then
            degree = i
            Exit Function
        End If
    Next i
    degree = -1
End Function

Function poly_div(ByVal n As Variant, ByVal d As Variant) As Variant
    If UBound(d) < UBound(n) Then
        ReDim Preserve d(UBound(n))
    End If
    Dim dn As Integer: dn = degree(n)
    Dim dd As Integer: dd = degree(d)
    If dd < 0 Then
        poly_div = CVErr(xlErrDiv0)
        Exit Function
    End If
    Dim quot() As Integer
    ReDim quot(dn)
    Do While dn >= dd
        Dim k As Integer: k = dn - dd
        Dim qk As Integer: qk = n(dn) / d(dd)
        quot(k + 1) = qk
        Dim d2() As Variant
        d2 = d
        ReDim Preserve d2(UBound(d) - k)
        For i = 1 To UBound(d2)
            n(UBound(n) + 1 - i) = n(UBound(n) + 1 - i) - d2(UBound(d2) + 1 - i) * qk
        Next i
        dn = degree(n)
    Loop
    poly_div = Array(quot, n) '-- (n is now the remainder)
End Function

Function poly(si As Variant) As String
'-- display helper
    Dim r As String
    For t = UBound(si) To 1 Step -1
        Dim sit As Integer: sit = si(t)
        If sit <> 0 Then
            If sit = 1 And t > 1 Then
                r = r & IIf(r = "", "", " + ")
            Else
                If sit = -1 And t > 1 Then
                    r = r & IIf(r = "", "-", " - ")
                Else
                    If r <> "" Then
                        r = r & IIf(sit < 0, " - ", " + ")
                        sit = Abs(sit)
                    End If
                    r = r & CStr(sit)
                End If
            End If
            r = r & IIf(t > 1, "x" & IIf(t > 2, t - 1, ""), "")
        End If
    Next t
    If r = "" Then r = "0"
    poly = r
End Function

Function polyn(s As Variant) As String
    Dim t() As String
    ReDim t(2 * UBound(s))
    For i = 1 To 2 * UBound(s) Step 2
        t(i) = poly(s((i + 1) / 2))
    Next i
    t(1) = String$(45 - Len(t(1)) - Len(t(3)), " ") & t(1)
    t(2) = "/"
    t(4) = "="
    t(6) = "rem"
    polyn = Join(t, " ")
End Function

Public Sub main()
    Dim tests(7) As Variant
    tests(1) = Array(Array(-42, 0, -12, 1), Array(-3, 1))
    tests(2) = Array(Array(-3, 1), Array(-42, 0, -12, 1))
    tests(3) = Array(Array(-42, 0, -12, 1), Array(-3, 1, 1))
    tests(4) = Array(Array(2, 3, 1), Array(1, 1))
    tests(5) = Array(Array(3, 5, 6, -4, 1), Array(1, 2, 1))
    tests(6) = Array(Array(3, 0, 7, 0, 0, 0, 0, 0, 3, 0, 0, 1), Array(1, 0, 0, 5, 0, 0, 0, 1))
    tests(7) = Array(Array(-56, 87, -94, -55, 22, -7), Array(2, 0, 1))
    Dim num As Variant, denom As Variant, quot As Variant, rmdr As Variant
    For i = 1 To 7
        num = tests(i)(1)
        denom = tests(i)(2)
        tmp = poly_div(num, denom)
        quot = tmp(1)
        rmdr = tmp(2)
        Debug.Print polyn(Array(num, denom, quot, rmdr))
    Next i
End Sub
