Option Explicit

Sub Main()
Dim p As String
   p = length_encoding("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
   Debug.Print p
   Debug.Print length_decoding(p)
End Sub

Private Function length_encoding(S As String) As String
Dim F As String, r As String, a As String, n As Long, c As Long, k As Long
   r = Left(S, 1)
   c = 1
   For n = 2 To Len(S)
      If r <> Mid(S, n, 1) Then
         a = a & c & r
         r = Mid(S, n, 1)
         c = 1
      Else
         c = c + 1
      End If
   Next
   length_encoding = a & c & r
End Function

Private Function length_decoding(S As String) As String
Dim F As Long, r As String, a As String
   For F = 1 To Len(S)
      If IsNumeric(Mid(S, F, 1)) Then
         r = r & Mid(S, F, 1)
      Else
         a = a & String(CLng(r), Mid(S, F, 1))
         r = vbNullString
      End If
   Next
   length_decoding = a
End Function
