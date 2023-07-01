' FB 1.05.0 Win64

Type FilterType As Function(As Integer) As Boolean

Function isEven(n As Integer) As Boolean
  Return n Mod 2  = 0
End Function

Sub filterArray(a() As Integer, b() As Integer, filter As FilterType)
  If UBound(a) = -1 Then Return  '' empty array
  Dim count As Integer = 0
  Redim b(0 To UBound(a) - LBound(a))
  For i As Integer = LBound(a) To UBound(a)
    If filter(a(i)) Then
      b(count) = a(i)
      count += 1
    End If
  Next

  If count > 0 Then Redim Preserve b(0 To count - 1) '' trim excess elements
End Sub

' Note that da() must be a dynamic array as static arrays can't be redimensioned
Sub filterDestructArray(da() As Integer, filter As FilterType)
  If UBound(da) = -1 Then Return  '' empty array
  Dim count As Integer = 0
  For i As Integer = LBound(da) To UBound(da)
    If i > UBound(da) - count Then Exit For
    If Not filter(da(i)) Then '' remove this element by moving those still to be examined down one
      For j As Integer = i + 1 To UBound(da) - count
        da(j - 1) = da(j)
      Next j
      count += 1
      i -= 1
    End If
  Next i

  If count > 0 Then
    Redim Preserve da(LBound(da) To UBound(da) - count) '' trim excess elements
  End If
End Sub

Dim n As Integer = 12
Dim a(1 To n) As Integer '' creates dynamic array as upper bound is a variable
For i As Integer = 1 To n : Read a(i) : Next
Dim b() As Integer '' array to store results
filterArray a(), b(), @isEven
Print "The even numbers are (in new array)      : ";
For i As Integer = LBound(b) To UBound(b)
  Print b(i); " ";
Next
Print : Print
filterDestructArray a(), @isEven
Print "The even numbers are (in original array) : ";
For i As Integer = LBound(a) To UBound(a)
  Print a(i); " ";
Next
Print : Print
Print "Press any key to quit"
Sleep
End

Data 1, 2, 3, 7, 8, 10, 11, 16, 19, 21, 22, 27
