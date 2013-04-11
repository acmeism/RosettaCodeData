Public Sub zigzag(n)
Dim a() As Integer
'populate a (1,1) to a(n,n) in zigzag pattern

'check if n too small
If n < 1 Then
  Debug.Print "zigzag: enter a number greater than 1"
  Exit Sub
End If

'initialize
ReDim a(1 To n, 1 To n)
i = 1       'i is the row
j = 1       'j is the column
P = 0       'P is the next number
a(i, j) = P 'fill in initial value

'now zigzag through the matrix and fill it in
Do While (i <= n) And (j <= n)
  'move one position to the right or down the rightmost column, if possible
  If j < n Then
    j = j + 1
  ElseIf i < n Then
    i = i + 1
  Else
    Exit Do
  End If
  'fill in
  P = P + 1: a(i, j) = P
  'move down to the left
  While (j > 1) And (i < n)
    i = i + 1: j = j - 1
    P = P + 1: a(i, j) = P
  Wend
  'move one position down or to the right in the bottom row, if possible
  If i < n Then
    i = i + 1
  ElseIf j < n Then
    j = j + 1
  Else
    Exit Do
  End If
  P = P + 1: a(i, j) = P
  'move back up to the right
  While (i > 1) And (j < n)
    i = i - 1: j = j + 1
    P = P + 1: a(i, j) = P
  Wend
Loop

'print result
Debug.Print "Result for n="; n; ":"
For i = 1 To n
  For j = 1 To n
    Debug.Print a(i, j),
  Next
  Debug.Print
Next
End Sub
