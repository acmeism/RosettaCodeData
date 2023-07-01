Option Base 1
Private Function mi_one(ByVal a As Variant) As Variant
    If IsArray(a) Then
        a(1) = 1
    Else
        a = 1
    End If
    mi_one = a
End Function

Private Function mi_add(ByVal a As Variant, b As Variant) As Variant
    If IsArray(a) Then
        If IsArray(b) Then
             If a(2) <> b(2) Then
                mi_add = CVErr(2019)
            Else
                a(1) = (a(1) + b(1)) Mod a(2)
                mi_add = a
            End If
        Else
            mi_add = CVErr(2018)
        End If
    Else
        If IsArray(b) Then
            mi_add = CVErr(2018)
        Else
           a = a + b
           mi_add = a
        End If
    End If
End Function

Private Function mi_mul(ByVal a As Variant, b As Variant) As Variant
    If IsArray(a) Then
        If IsArray(b) Then
            If a(2) <> b(2) Then
                mi_mul = CVErr(2019)
            Else
                a(1) = (a(1) * b(1)) Mod a(2)
                mi_mul = a
            End If
        Else
            mi_mul = CVErr(2018)
        End If
    Else
        If IsArray(b) Then
            mi_mul = CVErr(2018)
        Else
            a = a * b
            mi_mul = a
        End If
    End If
End Function

Private Function mi_power(x As Variant, p As Integer) As Variant
    res = mi_one(x)
    For i = 1 To p
        res = mi_mul(res, x)
    Next i
    mi_power = res
End Function

Private Function mi_print(m As Variant) As Variant
    If IsArray(m) Then
        s = "modint(" & m(1) & "," & m(2) & ")"
    Else
        s = CStr(m)
    End If
    mi_print = s
End Function

Private Function f(x As Variant) As Variant
    f = mi_add(mi_power(x, 100), mi_add(x, mi_one(x)))
End Function

Private Sub test(x As Variant)
    Debug.Print "x^100 + x + 1 for x == " & mi_print(x) & " is " & mi_print(f(x))
End Sub
Public Sub main()
    test 10
    test [{10,13}]
End Sub
