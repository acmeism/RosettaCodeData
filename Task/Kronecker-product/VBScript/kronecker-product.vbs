' Kronecker product - 05/04/2017 ' array boundary iteration corrections 06/13/2023
dim a(),b(),r()

sub kroneckerproduct '(a,b)
    m=ubound(a,1): n=ubound(a,2)
    p=ubound(b,1): q=ubound(b,2)
    rtn=m*p
    ctn=n*q
    redim r(rtn,ctn)
    for i=1 to m
        for j=1 to n
            for k=1 to p
                for l=1 to q
                    r(p*(i-1)+k,q*(j-1)+l)=a(i,j)*b(k,l)
    next: next: next: next
end sub 'kroneckerproduct

Private Sub printmatrix(text, m, w)
    wscript.stdout.writeline text
    Dim myArr()
    Select Case m
        Case "a": myArr = a()
        Case "b": myArr = b()
        Case "r": myArr = r()
    End Select
    For i = LBound(myArr, 1) To UBound(myArr, 1)
        text = vbNullString
        For j = LBound(myArr, 2) To UBound(myArr, 2)
            Select Case m
                Case "a": k = a(i, j)
                Case "b": k = b(i, j)
                Case "r": k = r(i, j)
            End Select
            text = text & " " & k
        Next
        wscript.stdout.writeline text
    Next
End Sub 'printmatrix

sub printall(w)
    printmatrix "matrix a:", "a", w
    printmatrix "matrix b:", "b", w
    printmatrix "kronecker product:", "r", w
end sub 'printall

sub main()
    xa = Array(1, 2, _
               3, 4)
    ReDim a(LBound(xa, 1) To LBound(xa, 1) + 1, LBound(xa, 1) To LBound(xa, 1) + 1)
    k = LBound(a, 1)
    For i = LBound(a, 1) To UBound(a, 1): For j = LBound(a, 1) To UBound(a, 1)
        a(i, j) = xa(k): k = k + 1
    Next: Next
    xb = Array(0, 5, _
               6, 7)
    ReDim b(LBound(xb, 1) To LBound(xb, 1) + 1, LBound(xb, 1) To LBound(xb, 1) + 1)
    k = LBound(b, 1)
    For i = LBound(b, 1) To UBound(b, 1): For j = LBound(b, 2) To UBound(b, 2)
        b(i, j) = xb(k): k = k + 1
    Next: Next
    kroneckerproduct
    printall 3

    xa = Array(0, 1, 0, _
               1, 1, 1, _
               0, 1, 0)
    ReDim a(LBound(xa, 1) To LBound(xa, 1) + 2, LBound(xa, 1) To LBound(xa, 1) + 2)
    k = LBound(a, 1)
    For i = LBound(a, 1) To UBound(a, 1): For j = LBound(a, 1) To UBound(a, 1)
        a(i, j) = xa(k): k = k + 1
    Next: Next
    xb = Array(1, 1, 1, 1, _
               1, 0, 0, 1, _
               1, 1, 1, 1)
    ReDim b(LBound(xb, 1) To LBound(xb, 1) + 2, LBound(xb, 1) To LBound(xb, 1) + 3)
    k = LBound(b, 1)
    For i = LBound(b, 1) To UBound(b, 1): For j = LBound(b, 2) To UBound(b, 2)
        b(i, j) = xb(k): k = k + 1
    Next: Next

    kroneckerproduct
    printall 2
end sub 'main

main
