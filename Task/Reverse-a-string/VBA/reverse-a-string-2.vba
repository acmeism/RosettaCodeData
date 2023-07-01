Public Function RReverse(aString As String) As String
'returns the reversed string
'do it recursively: cut the string in two, reverse these fragments and put them back together in reverse order
Dim L As Integer    'length of string
Dim M As Integer    'cut point

L = Len(aString)
If L <= 1 Then   'no need to reverse
  RReverse = aString
Else
  M = Int(L / 2)
  RReverse = RReverse(Right$(aString, L - M)) & RReverse(Left$(aString, M))
End If
End Function
