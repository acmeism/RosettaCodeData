Option Explicit
'----------------------------------------------------------------------
Function TransposeMatrix(InitMatrix() As Long, TransposedMatrix() As Long)
Dim l1 As Long, l2 As Long, u1 As Long, u2 As Long, r As Long, c As Long
  l1 = LBound(InitMatrix, 1)
  l2 = LBound(InitMatrix, 2)
  u1 = UBound(InitMatrix, 1)
  u2 = UBound(InitMatrix, 2)
  ReDim TransposedMatrix(l2 To u2, l1 To u1)
  For r = l1 To u1
    For c = l2 To u2
      TransposedMatrix(c, r) = InitMatrix(r, c)
    Next c
  Next r
End Function
'----------------------------------------------------------------------
Sub PrintMatrix(a() As Long)
Dim l1 As Long, l2 As Long, u1 As Long, u2 As Long, r As Long, c As Long
Dim s As String * 8
  l1 = LBound(a(), 1)
  l2 = LBound(a(), 2)
  u1 = UBound(a(), 1)
  u2 = UBound(a(), 2)
  For r = l1 To u1
    For c = l2 To u2
      RSet s = Str$(a(r, c))
      Debug.Print s;
    Next c
  Debug.Print
  Next r
End Sub
'----------------------------------------------------------------------
Sub TranspositionDemo(ByVal DimSize1 As Long, ByVal DimSize2 As Long)
Dim r, c, cc As Long
Dim a() As Long
Dim b() As Long
  cc = DimSize2
  DimSize1 = DimSize1 - 1
  DimSize2 = DimSize2 - 1
  ReDim a(0 To DimSize1, 0 To DimSize2)
  For r = 0 To DimSize1
    For c = 0 To DimSize2
      a(r, c) = (cc * r) + c + 1
    Next c
  Next r
  Debug.Print "initial matrix:"
  PrintMatrix a()
  TransposeMatrix a(), b()
  Debug.Print "transposed matrix:"
  PrintMatrix b()
End Sub
'----------------------------------------------------------------------
Sub Main()
  TranspositionDemo 3, 3
  TranspositionDemo 3, 7
End Sub
