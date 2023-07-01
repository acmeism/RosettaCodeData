Sub fibonacci()
    Const n = 139
    Dim i As Integer
    Dim f1 As Variant, f2 As Variant, f3 As Variant 'for Decimal
    f1 = CDec(0): f2 = CDec(1) 'for Decimal setting
    Debug.Print "fibo("; 0; ")="; f1
    Debug.Print "fibo("; 1; ")="; f2
    For i = 2 To n
        f3 = f1 + f2
        Debug.Print "fibo("; i; ")="; f3
        f1 = f2
        f2 = f3
    Next i
End Sub 'fibonacci
