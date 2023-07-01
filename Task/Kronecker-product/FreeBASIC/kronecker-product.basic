' version 06-04-2017
' compile with: fbc -s console

Sub kronecker_product(a() As Long, b() As Long, frmt As String = "#")

    Dim As Long i, j, k, l
    Dim As Long la1 = LBound(a, 1) : Dim As Long ua1 = UBound(a, 1)
    Dim As Long la2 = LBound(a, 2) : Dim As Long ua2 = UBound(a, 2)
    Dim As Long lb1 = LBound(b, 1) : Dim As Long ub1 = UBound(b, 1)
    Dim As Long lb2 = LBound(b, 2) : Dim As Long ub2 = UBound(b, 2)

    For i = la1 To ua1
        For k = lb1 To ub1
            Print "[";
            For j = la2 To ua2
                For l = lb2 To ub2
                    Print Using frmt; a(i, j) * b(k, l);
                    If j = ua1 And l = ub2 Then
                        Print "]"
                    Else
                        Print " ";
                    End If
                Next
            Next
        Next
    Next

End Sub

' ------=< MAIN >=-----

Dim As Long a(1 To 2, 1 To 2) = {{1, 2}, _
                                 {3, 4}}
Dim As Long b(1 To 2, 1 To 2) = {{0, 5}, _
                                 {6, 7}}
kronecker_product(a(), b(), "##")

Print
Dim As Long x(1 To 3, 1 To 3) = {{0, 1, 0}, _
                                 {1, 1, 1}, _
                                 {0, 1, 0}}
Dim As Long y(1 To 3, 1 To 4) = {{1, 1, 1, 1}, _
                                 {1, 0, 0, 1}, _
                                 {1, 1, 1, 1}}
kronecker_product(x(), y())

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
