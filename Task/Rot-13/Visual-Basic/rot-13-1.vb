Function ROT13(ByVal a As String) As String
  Dim i As Long
  Dim n As Integer, e As Integer

  ROT13 = a
  For i = 1 To Len(a)
    n = Asc(Mid$(a, i, 1))
    Select Case n
      Case 65 To 90
        e = 90
        n = n + 13
      Case 97 To 122
        e = 122
        n = n + 13
      Case Else
        e = 255
    End Select

    If n > e Then
      n = n - 26
    End If
    Mid$(ROT13, i, 1) = Chr$(n)
  Next i
End Function
