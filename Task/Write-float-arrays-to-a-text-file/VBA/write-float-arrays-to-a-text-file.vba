Public Sub main()
    x = [{1, 2, 3, 1e11}]
    y = [{1, 1.4142135623730951, 1.7320508075688772, 316227.76601683791}]
    Dim TextFile As Integer
    TextFile = FreeFile
    Open "filename" For Output As TextFile
    For i = 1 To UBound(x)
        Print #TextFile, Format(x(i), "0.000E-000"), Format(y(i), "0.00000E-000")
    Next i
    Close TextFile
End Sub
