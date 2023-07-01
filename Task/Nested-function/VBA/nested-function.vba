Option Explicit

Private Const Sep As String = ". "
Private Counter As Integer
Sub Main()
Dim L As Variant
    Counter = 0
    L = MakeList(Array("first", "second", "third"))
    Debug.Print L
End Sub
Function MakeList(Datas) As Variant
Dim i As Integer
    For i = LBound(Datas) To UBound(Datas)
        MakeList = MakeList & MakeItem(Datas(i))
    Next i
End Function
Function MakeItem(Item As Variant) As Variant
    Counter = Counter + 1
    MakeItem = Counter & Sep & Item & vbCrLf
End Function
