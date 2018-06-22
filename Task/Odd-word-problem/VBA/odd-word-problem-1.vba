Private Function OddWordFirst(W As String) As String
Dim i As Integer, count As Integer, l As Integer, flag As Boolean, temp As String
   count = 1
   Do
      flag = Not flag
      l = FindNextPunct(i, W) - count + 1
      If flag Then
         temp = temp & ExtractWord(W, count, l)
      Else
         temp = temp & ReverseWord(W, count, l)
      End If
   Loop While count < Len(W)
   OddWordFirst = temp
End Function

Private Function FindNextPunct(d As Integer, W As String) As Integer
Const PUNCT As String = ",;:."
   Do
      d = d + 1
   Loop While InStr(PUNCT, Mid(W, d, 1)) = 0
   FindNextPunct = d
End Function

Private Function ExtractWord(W As String, c As Integer, i As Integer) As String
   ExtractWord = Mid(W, c, i)
   c = c + Len(ExtractWord)
End Function

Private Function ReverseWord(W As String, c As Integer, i As Integer) As String
Dim temp As String, sep As String
   temp = Left(Mid(W, c, i), Len(Mid(W, c, i)) - 1)
   sep = Right(Mid(W, c, i), 1)
   ReverseWord = StrReverse(temp) & sep
   c = c + Len(ReverseWord)
End Function
