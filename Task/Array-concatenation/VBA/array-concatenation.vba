Option Explicit

Sub MainConcat_Array()
Dim Aray_1() As Variant, Aray_2() As Variant
Dim Result() As Variant

    Aray_1 = Array(1, 2, 3, 4, 5, #11/24/2017#, "azerty")
    Aray_2 = Array("A", "B", "C", 18, "End")
    Result = Concat_Array(Aray_1, Aray_2)
    Debug.Print "With Array 1 : " & Join(Aray_1, ", ")
    Debug.Print "And Array 2 : " & Join(Aray_2, ", ")
    Debug.Print "The result is Array 3 : " & Join(Result, ", ")
End Sub

Function Concat_Array(A1() As Variant, A2() As Variant) As Variant()
Dim TmpA1() As Variant, N As Long, i As Long

    N = UBound(A1) + 1
    TmpA1 = A1
    ReDim Preserve TmpA1(N + UBound(A2))
    For i = N To UBound(TmpA1)
        TmpA1(i) = A2(i - N)
    Next
    Concat_Array = TmpA1
End Function
