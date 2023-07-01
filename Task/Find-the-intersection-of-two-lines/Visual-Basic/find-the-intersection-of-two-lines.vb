Option Explicit

Public Type Point
  x As Double
  y As Double
  invalid As Boolean
End Type

Public Type Line
  s As Point
  e As Point
End Type

Public Function GetIntersectionPoint(L1 As Line, L2 As Line) As Point
Dim a1 As Double
Dim b1 As Double
Dim c1 As Double
Dim a2 As Double
Dim b2 As Double
Dim c2 As Double
Dim det As Double

  a1 = L1.e.y - L1.s.y
  b1 = L1.s.x - L1.e.x
  c1 = a1 * L1.s.x + b1 * L1.s.y
  a2 = L2.e.y - L2.s.y
  b2 = L2.s.x - L2.e.x
  c2 = a2 * L2.s.x + b2 * L2.s.y
  det = a1 * b2 - a2 * b1

  If det Then
    With GetIntersectionPoint
      .x = (b2 * c1 - b1 * c2) / det
      .y = (a1 * c2 - a2 * c1) / det
    End With
  Else
    GetIntersectionPoint.invalid = True
  End If
End Function

Sub Main()
Dim ln1 As Line
Dim ln2 As Line
Dim ip As Point

  ln1.s.x = 4
  ln1.s.y = 0
  ln1.e.x = 6
  ln1.e.y = 10
  ln2.s.x = 0
  ln2.s.y = 3
  ln2.e.x = 10
  ln2.e.y = 7
  ip = GetIntersectionPoint(ln1, ln2)
  Debug.Assert Not ip.invalid
  Debug.Assert ip.x = 5 And ip.y = 5

  LSet ln2.s = ln2.e
  ip = GetIntersectionPoint(ln1, ln2)
  Debug.Assert ip.invalid

  LSet ln2 = ln1
  ip = GetIntersectionPoint(ln1, ln2)
  Debug.Assert ip.invalid

End Sub
