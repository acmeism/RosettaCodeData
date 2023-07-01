Private Function mean(v() As Double, ByVal leng As Integer) As Variant
    Dim sum As Double, i As Integer
    sum = 0: i = 0
    For i = 0 To leng - 1
        sum = sum + vv
    Next i
    If leng = 0 Then
        mean = CVErr(xlErrDiv0)
    Else
        mean = sum / leng
    End If
End Function
Public Sub main()
    Dim v(4) As Double
    Dim i As Integer, leng As Integer
    v(0) = 1#
    v(1) = 2#
    v(2) = 2.178
    v(3) = 3#
    v(4) = 3.142
    For leng = 5 To 0 Step -1
        Debug.Print "mean[";
        For i = 0 To leng - 1
            Debug.Print IIf(i, "; " & v(i), "" & v(i));
        Next i
        Debug.Print "] = "; mean(v, leng)
    Next leng
End Sub
