'pancake sort
'uses two auxiliary routines "printarray" and "flip"

Public Sub printarray(A)
  For i = LBound(A) To UBound(A)
    Debug.Print A(i),
  Next
  Debug.Print
End Sub

Public Sub Flip(ByRef A, p1, p2, trace)
'flip first elements of A (p1 to p2)
 If trace Then Debug.Print "we'll flip the first "; p2 - p1 + 1; "elements of the array"
 Cut = Int((p2 - p1 + 1) / 2)
 For i = 0 To Cut - 1
   'flip position i and (n - i + 1)
   temp = A(i)
   A(i) = A(p2 - i)
   A(p2 - i) = temp
 Next
End Sub

Public Sub pancakesort(ByRef A(), Optional trace As Boolean = False)
'sort A into ascending order using pancake sort

lb = LBound(A)
ub = UBound(A)
Length = ub - lb + 1
If Length <= 1 Then 'no need to sort
  Exit Sub
End If

For i = ub To lb + 1 Step -1
  'find position of max. element in subarray A(lowerbound to i)
  P = lb
  Maximum = A(P)
  For j = lb + 1 To i
    If A(j) > Maximum Then
      P = j
      Maximum = A(j)
    End If
  Next j
  'check if maximum is already at end - then we don't need to flip
  If P < i Then
    'flip the first part of the array up to the maximum so it is at the head - skip if it is already there
    If P > 1 Then
      Flip A, lb, P, trace
      If trace Then printarray A
    End If
    'now flip again so that it is in its final position
    Flip A, lb, i, trace
    If trace Then printarray A
  End If
Next i
End Sub

'test routine
Public Sub TestPancake(Optional trace As Boolean = False)
Dim A()
A = Array(5, 7, 8, 3, 1, 10, 9, 23, 50, 0)
Debug.Print "Initial array:"
printarray A
pancakesort A, trace
Debug.Print "Final array:"
printarray A
End Sub
