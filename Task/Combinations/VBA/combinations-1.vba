Option Explicit
Option Base 0
'Option Base 1

Private ArrResult

Sub test()
    'compute
    Main_Combine 5, 3

    'return
    Dim j As Long, i As Long, temp As String
    For i = LBound(ArrResult, 1) To UBound(ArrResult, 1)
        temp = vbNullString
        For j = LBound(ArrResult, 2) To UBound(ArrResult, 2)
            temp = temp & " " & ArrResult(i, j)
        Next
        Debug.Print temp
    Next
    Erase ArrResult
End Sub

Private Sub Main_Combine(M As Long, N As Long)
Dim MyArr, i As Long
    ReDim MyArr(M - 1)
    If LBound(MyArr) > 0 Then ReDim MyArr(M) 'Case Option Base 1
    For i = LBound(MyArr) To UBound(MyArr)
        MyArr(i) = i
    Next i
    i = IIf(LBound(MyArr) > 0, N, N - 1)
    ReDim ArrResult(i, LBound(MyArr))
    Combine MyArr, N, LBound(MyArr), LBound(MyArr)
    ReDim Preserve ArrResult(UBound(ArrResult, 1), UBound(ArrResult, 2) - 1)
    'In VBA Excel we can use Application.Transpose instead of personal Function Transposition
    ArrResult = Transposition(ArrResult)
End Sub

Private Sub Combine(MyArr As Variant, Nb As Long, Deb As Long, Ind As Long)
Dim i As Long, j As Long, N As Long
    For i = Deb To UBound(MyArr, 1)
        ArrResult(Ind, UBound(ArrResult, 2)) = MyArr(i)
        N = IIf(LBound(ArrResult, 1) = 0, Nb - 1, Nb)
        If Ind = N Then
            ReDim Preserve ArrResult(UBound(ArrResult, 1), UBound(ArrResult, 2) + 1)
            For j = LBound(ArrResult, 1) To UBound(ArrResult, 1)
                ArrResult(j, UBound(ArrResult, 2)) = ArrResult(j, UBound(ArrResult, 2) - 1)
            Next j
        Else
            Call Combine(MyArr, Nb, i + 1, Ind + 1)
        End If
    Next i
End Sub

Private Function Transposition(ByRef MyArr As Variant) As Variant
Dim T, i As Long, j As Long
    ReDim T(LBound(MyArr, 2) To UBound(MyArr, 2), LBound(MyArr, 1) To UBound(MyArr, 1))
    For i = LBound(MyArr, 1) To UBound(MyArr, 1)
        For j = LBound(MyArr, 2) To UBound(MyArr, 2)
            T(j, i) = MyArr(i, j)
        Next j
    Next i
    Transposition = T
    Erase T
End Function
