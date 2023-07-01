Option Explicit

Sub Main()
Dim a
   a = Array(1, 15, 19, 25, 13, 0, -125, 9)
   Debug.Print Max_VBA(a)
End Sub

Function Max_VBA(Arr As Variant) As Long
Dim i As Long, temp As Long
   temp = Arr(LBound(Arr))
   For i = LBound(Arr) + 1 To UBound(Arr)
      If Arr(i) > temp Then temp = Arr(i)
   Next i
   Max_VBA = temp
End Function
