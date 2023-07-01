Private Function OddWordSecond(Words As String) As String
Dim i&, count&, t$, cpt&, j&, l&, d&, f As Boolean
Const PUNCT As String = ",;:"
   For i = 1 To Len(Words)
      'first word
      If i = 1 Then
         cpt = 1
         Do
            t = t & Mid(Words, cpt, 1)
            cpt = cpt + 1
         Loop While InStr(PUNCT, Mid(Words, cpt, 1)) = 0 And cpt < Len(Words)
         i = cpt
         t = t & Mid(Words, i, 1)
      End If
      If Right(t, 1) = "." Then Exit For
      'Odd words ==> reverse
      While InStr(PUNCT, Mid(Words, cpt + 1, 1)) = 0 And cpt < Len(Words)
         cpt = cpt + 1
      Wend
      l = IIf(f = True, i, i + 1)
      d = IIf(cpt = Len(Words), cpt - 1, cpt)
      For j = d To l Step -1
         t = t & Mid(Words, j, 1)
      Next
      If cpt = Len(Words) Then t = t & ".": Exit For
      f = True
      i = cpt + 1
      t = t & Mid(Words, i, 1)
      'Even words
      cpt = i + 1
      t = t & Mid(Words, cpt, 1)
      Do
         cpt = cpt + 1
         t = t & Mid(Words, cpt, 1)
      Loop While InStr(PUNCT, Mid(Words, cpt, 1)) = 0 And cpt < Len(Words)
      i = cpt
   Next
   OddWordSecond = t
End Function
