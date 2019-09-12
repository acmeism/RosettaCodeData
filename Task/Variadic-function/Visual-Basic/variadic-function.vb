Option Explicit
'--------------------------------------------------
Sub varargs(ParamArray a())
Dim n As Long, m As Long
    Debug.Assert VarType(a) = (vbVariant Or vbArray)
    For n = LBound(a) To UBound(a)
        If IsArray(a(n)) Then
            For m = LBound(a(n)) To UBound(a(n))
                Debug.Print a(n)(m)
            Next m
        Else
            Debug.Print a(n)
        End If
    Next
End Sub
'--------------------------------------------------
Sub Main()
Dim v As Variant

    Debug.Print "call 1"
    varargs 1, 2, 3

    Debug.Print "call 2"
    varargs 4, 5, 6, 7, 8

    v = Array(9, 10, 11)
    Debug.Print "call 3"
    varargs v

    ReDim v(0 To 2)
    v(0) = 12
    v(1) = 13
    v(2) = 14
    Debug.Print "call 4"
    varargs 11, v

    Debug.Print "call 5"
    varargs v(2), v(1), v(0), 11

End Sub
