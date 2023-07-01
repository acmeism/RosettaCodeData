Option Explicit

Sub Main()
Dim myArr() As Variant, i As Long

    myArr = Remove_Duplicate(Array(1.23456789101112E+16, True, False, True, "Alpha", 1, 235, 4, 1.25, 1.25, "Beta", 1.23456789101112E+16, "Delta", "Alpha", "Charlie", 1, 2, "Foxtrot", "Foxtrot", "Alpha", 235))
'return :
    For i = LBound(myArr) To UBound(myArr)
        Debug.Print myArr(i)
    Next
End Sub

Private Function Remove_Duplicate(Arr As Variant) As Variant()
Dim myColl As New Collection, Temp() As Variant, i As Long, cpt As Long

    ReDim Temp(UBound(Arr))
    For i = LBound(Arr) To UBound(Arr)
        On Error Resume Next
        myColl.Add CStr(Arr(i)), CStr(Arr(i))
        If Err.Number > 0 Then
            On Error GoTo 0
        Else
            Temp(cpt) = Arr(i)
            cpt = cpt + 1
        End If
    Next i
    ReDim Preserve Temp(cpt - 1)
    Remove_Duplicate = Temp
End Function
