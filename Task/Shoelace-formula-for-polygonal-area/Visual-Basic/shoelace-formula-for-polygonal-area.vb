Option Explicit

Public Function ShoelaceArea(x() As Double, y() As Double) As Double
Dim i As Long, j As Long
Dim Area As Double

  j = UBound(x())
  For i = LBound(x()) To UBound(x())
    Area = Area + (y(j) + y(i)) * (x(j) - x(i))
    j = i
  Next i
  ShoelaceArea = Abs(Area) / 2
End Function

Sub Main()
Dim v As Variant
Dim n As Long, i As Long, j As Long
  v = Array(3, 4, 5, 11, 12, 8, 9, 5, 5, 6)
  n = (UBound(v) - LBound(v) + 1) \ 2 - 1
  ReDim x(0 To n) As Double, y(0 To n) As Double
  j = 0
  For i = 0 To n
    x(i) = v(j)
    y(i) = v(j + 1)
    j = j + 2
  Next i
  Debug.Print ShoelaceArea(x(), y())
End Sub
