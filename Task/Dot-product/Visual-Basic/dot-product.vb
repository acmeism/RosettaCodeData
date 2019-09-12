Option Explicit

Function DotProduct(a() As Long, b() As Long) As Long
Dim l As Long, u As Long, i As Long
  Debug.Assert DotProduct = 0 'return value automatically initialized with 0
  l = LBound(a())
  If l = LBound(b()) Then
    u = UBound(a())
    If u = UBound(b()) Then
      For i = l To u
        DotProduct = DotProduct + a(i) * b(i)
      Next i
    Exit Function
    End If
  End If
  Err.Raise vbObjectError + 123, , "invalid input"
End Function

Sub Main()
Dim a() As Long, b() As Long, x As Long
  ReDim a(2)
  a(0) = 1
  a(1) = 3
  a(2) = -5
  ReDim b(2)
  b(0) = 4
  b(1) = -2
  b(2) = -1
  x = DotProduct(a(), b())
  Debug.Assert x = 3
  ReDim Preserve a(3)
  a(3) = 10
  ReDim Preserve b(3)
  b(3) = 2
  x = DotProduct(a(), b())
  Debug.Assert x = 23
  ReDim Preserve a(4)
  a(4) = 10
  On Error Resume Next
  x = DotProduct(a(), b())
  Debug.Assert Err.Number = vbObjectError + 123
  Debug.Assert Err.Description = "invalid input"
End Sub
