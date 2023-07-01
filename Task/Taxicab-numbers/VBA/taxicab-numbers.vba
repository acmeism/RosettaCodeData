Public Type tuple
    i As Variant
    j As Variant
    sum As Variant
End Type
Public Type tuple3
    i1 As Variant
    j1 As Variant
    i2 As Variant
    j2 As Variant
    i3 As Variant
    j3 As Variant
    sum As Variant
End Type
Sub taxicab_numbers()
    Dim i As Variant, j As Variant
    Dim k As Long
    Const MAX = 2019
    Dim p(MAX) As Variant
    Const bigMAX = (MAX + 1) * (MAX / 2)
    Dim big(1 To bigMAX) As tuple
    Const resMAX = 4400
    Dim res(1 To resMAX) As tuple3
    For i = 1 To MAX
        p(i) = CDec(i * i * i) 'convert Variant to Decimal
    Next i                     'wich hold numbers upto 10^28

    k = 1
    For i = 1 To MAX
        For j = i To MAX
            big(k).i = CDec(i)
            big(k).j = CDec(j)
            big(k).sum = CDec(p(i) + p(j))
            k = k + 1
        Next j
    Next i
    n = 1
    Quicksort big, LBound(big), UBound(big)
    For i = 1 To bigMAX - 1
        If big(i).sum = big(i + 1).sum Then
            res(n).i1 = CStr(big(i).i)
            res(n).j1 = CStr(big(i).j)
            res(n).i2 = CStr(big(i + 1).i)
            res(n).j2 = CStr(big(i + 1).j)
            If big(i + 1).sum = big(i + 2).sum Then
                res(n).i3 = CStr(big(i + 2).i)
                res(n).j3 = CStr(big(i + 2).j)
                i = i + 1
            End If
            res(n).sum = CStr(big(i).sum)
            n = n + 1
            i = i + 1
        End If
    Next i
    Debug.Print n - 1; " taxis"
    For i = 1 To 25
        With res(i)
            Debug.Print String$(4 - Len(CStr(i)), " "); i;
            Debug.Print String$(11 - Len(.sum), " "); .sum; " = ";
            Debug.Print String$(4 - Len(.i1), " "); .i1; "^3 +";
            Debug.Print String$(4 - Len(.j1), " "); .j1; "^3 = ";
            Debug.Print String$(4 - Len(.i2), " "); .i2; "^3 +";
            Debug.Print String$(4 - Len(.j2), " "); .j2; "^3"
        End With
    Next i
    Debug.Print
    For i = 2000 To 2006
        With res(i)
            Debug.Print String$(4 - Len(CStr(i)), " "); i;
            Debug.Print String$(11 - Len(.sum), " "); .sum; " = ";
            Debug.Print String$(4 - Len(.i1), " "); .i1; "^3 +";
            Debug.Print String$(4 - Len(.j1), " "); .j1; "^3 = ";
            Debug.Print String$(4 - Len(.i2), " "); .i2; "^3 +";
            Debug.Print String$(4 - Len(.j2), " "); .j2; "^3"
        End With

    Next i
    Debug.Print
    For i = 1 To resMAX
        If res(i).i3 <> "" Then
            With res(i)
                Debug.Print String$(4 - Len(CStr(i)), " "); i;
                Debug.Print String$(11 - Len(.sum), " "); .sum; " = ";
                Debug.Print String$(4 - Len(.i1), " "); .i1; "^3 +";
                Debug.Print String$(4 - Len(.j1), " "); .j1; "^3 = ";
                Debug.Print String$(4 - Len(.i2), " "); .i2; "^3 +";
                Debug.Print String$(4 - Len(.j2), " "); .j2; "^3";
                Debug.Print String$(4 - Len(.i3), " "); .i3; "^3 +";
                Debug.Print String$(4 - Len(.j3), " "); .j3; "^3"
            End With
        End If
    Next i
End Sub
Sub Quicksort(vArray() As tuple, arrLbound As Long, arrUbound As Long)
    'https://wellsr.com/vba/2018/excel/vba-quicksort-macro-to-sort-arrays-fast/
    'Sorts a one-dimensional VBA array from smallest to largest
    'using a very fast quicksort algorithm variant.
    'Adapted to multidimensions/typedef
    Dim pivotVal As Variant
    Dim vSwap    As tuple
    Dim tmpLow   As Long
    Dim tmpHi    As Long

    tmpLow = arrLbound
    tmpHi = arrUbound
    pivotVal = vArray((arrLbound + arrUbound) \ 2).sum

    While (tmpLow <= tmpHi) 'divide
        While (vArray(tmpLow).sum < pivotVal And tmpLow < arrUbound)
            tmpLow = tmpLow + 1
        Wend

        While (pivotVal < vArray(tmpHi).sum And tmpHi > arrLbound)
            tmpHi = tmpHi - 1
        Wend

        If (tmpLow <= tmpHi) Then
             vSwap.i = vArray(tmpLow).i
             vSwap.j = vArray(tmpLow).j
             vSwap.sum = vArray(tmpLow).sum
             vArray(tmpLow).i = vArray(tmpHi).i
             vArray(tmpLow).j = vArray(tmpHi).j
             vArray(tmpLow).sum = vArray(tmpHi).sum
             vArray(tmpHi).i = vSwap.i
             vArray(tmpHi).j = vSwap.j
             vArray(tmpHi).sum = vSwap.sum
             tmpLow = tmpLow + 1
             tmpHi = tmpHi - 1
        End If
    Wend

    If (arrLbound < tmpHi) Then Quicksort vArray, arrLbound, tmpHi 'conquer
    If (tmpLow < arrUbound) Then Quicksort vArray, tmpLow, arrUbound 'conquer
End Sub
