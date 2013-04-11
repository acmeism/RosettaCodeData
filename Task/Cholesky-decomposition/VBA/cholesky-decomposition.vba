Function Cholesky(Mat As Range) As Variant

Dim A() As Double, L() As Double, sum As Double, sum2 As Double
Dim m As Byte, i As Byte, j As Byte, k As Byte

'Ensure matrix is square
    If Mat.Rows.Count <> Mat.Columns.Count Then
        MsgBox ("Correlation matrix is not square")
        Exit Function
    End If

    m = Mat.Rows.Count

'Initialize and populate matrix A of values and matrix L which will be the lower Cholesky
    ReDim A(0 To m - 1, 0 To m - 1)
    ReDim L(0 To m - 1, 0 To m - 1)
    For i = 0 To m - 1
        For j = 0 To m - 1
            A(i, j) = Mat(i + 1, j + 1).Value2
            L(i, j) = 0
        Next j
    Next i

'Handle the simple cases explicitly to save time
    Select Case m
        Case Is = 1
            L(0, 0) = Sqr(A(0, 0))

        Case Is = 2
            L(0, 0) = Sqr(A(0, 0))
            L(1, 0) = A(1, 0) / L(0, 0)
            L(1, 1) = Sqr(A(1, 1) - L(1, 0) * L(1, 0))

        Case Else
            L(0, 0) = Sqr(A(0, 0))
            L(1, 0) = A(1, 0) / L(0, 0)
            L(1, 1) = Sqr(A(1, 1) - L(1, 0) * L(1, 0))
            For i = 2 To m - 1
                sum2 = 0
                For k = 0 To i - 1
                    sum = 0
                    For j = 0 To k
                        sum = sum + L(i, j) * L(k, j)
                    Next j
                    L(i, k) = (A(i, k) - sum) / L(k, k)
                    sum2 = sum2 + L(i, k) * L(i, k)
                Next k
                L(i, i) = Sqr(A(i, i) - sum2)
            Next i
    End Select
    Cholesky = L
End Function
