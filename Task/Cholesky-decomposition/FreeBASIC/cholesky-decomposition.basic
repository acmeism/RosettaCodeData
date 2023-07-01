' version 18-01-2017
' compile with: fbc -s console

Sub Cholesky_decomp(array() As Double)

    Dim As Integer i, j, k
    Dim As Double s, l(UBound(array), UBound(array, 2))

    For i = 0 To UBound(array)
        For j = 0 To i
            s = 0
            For k = 0 To j -1
                s += l(i, k) * l(j, k)
            Next
            If i = j Then
                l(i, j) = Sqr(array(i, i) - s)
            Else
                l(i, j) = (array(i, j) - s) / l(j, j)
            End If
        Next
    Next

    For i = 0 To UBound(array)
        For j = 0 To UBound(array, 2)
            Swap array(i, j), l(i, j)
        Next
    Next

End Sub

Sub Print_(array() As Double)

    Dim As Integer i, j

    For i = 0 To UBound(array)
        For j = 0 To UBound(array, 2)
            Print Using "###.#####";array(i,j);
        Next
        Print
    Next

End Sub

' ------=< MAIN >=------

Dim  m1(2,2) As Double  => {{25, 15, -5}, _
                            {15, 18,  0}, _
                            {-5,  0, 11}}

Dim m2(3, 3) As Double => {{18, 22,  54,  42}, _
                           {22, 70,  86,  62}, _
                           {54, 86, 174, 134}, _
                           {42, 62, 134, 106}}

Cholesky_decomp(m1())
Print_(m1())

Print
Cholesky_decomp(m2())
Print_(m2())

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
