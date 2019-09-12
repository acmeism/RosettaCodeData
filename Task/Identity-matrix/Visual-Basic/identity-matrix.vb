Option Explicit
'------------
Public Function BuildIdentityMatrix(ByVal Size As Long) As Byte()
Dim i As Long
Dim b() As Byte

  Size = Size - 1
  ReDim b(0 To Size, 0 To Size)
  'at this point, the matrix is allocated and
  'all elements are initialized to 0 (zero)
  For i = 0 To Size
    b(i, i) = 1   'set diagonal elements to 1
  Next i
  BuildIdentityMatrix = b

End Function
'------------
Sub IdentityMatrixDemo(ByVal Size As Long)
Dim b() As Byte
Dim i As Long, j As Long

  b() = BuildIdentityMatrix(Size)
  For i = LBound(b(), 1) To UBound(b(), 1)
    For j = LBound(b(), 2) To UBound(b(), 2)
      Debug.Print CStr(b(i, j));
    Next j
  Debug.Print
  Next i

End Sub
'------------
Sub Main()

  IdentityMatrixDemo 5
  Debug.Print
  IdentityMatrixDemo 10

End Sub
