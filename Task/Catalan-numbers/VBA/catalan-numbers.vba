Public Sub Catalan1(n As Integer)
'Computes the first n Catalan numbers according to the first recursion given
Dim Cat() As Long
Dim sum As Long

ReDim Cat(n)
Cat(0) = 1
For i = 0 To n - 1
  sum = 0
  For j = 0 To i
    sum = sum + Cat(j) * Cat(i - j)
  Next j
  Cat(i + 1) = sum
Next i
Debug.Print
For i = 0 To n
  Debug.Print i, Cat(i)
Next
End Sub

Public Sub Catalan2(n As Integer)
'Computes the first n Catalan numbers according to the second recursion given
Dim Cat() As Long

ReDim Cat(n)
Cat(0) = 1
For i = 1 To n
  Cat(i) = 2 * Cat(i - 1) * (2 * i - 1) / (i + 1)
Next i
Debug.Print
For i = 0 To n
  Debug.Print i, Cat(i)
Next
End Sub
