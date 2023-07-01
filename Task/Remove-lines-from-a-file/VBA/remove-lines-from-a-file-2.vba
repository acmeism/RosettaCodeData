Option Explicit

Sub Main()
   'See Output First call
   OtherWay "C:\Users\" & Environ("username") & "\Desktop\foobar.txt", 11, 5
   'See Output Second call
   OtherWay "C:\Users\" & Environ("username") & "\Desktop\foobar.txt", 8, 5
   'See Output Third call
   OtherWay "C:\Users\" & Environ("username") & "\Desktop\foobar.txt", 3, 5
End Sub

Private Sub OtherWay(StrFile As String, StartLine As Long, NumberOfLines As Long)
Dim Nb As Integer, s As String, arr, i As Long, out() As String, j As Long
   Nb = FreeFile
   Open StrFile For Input As #Nb
      s = Input(LOF(1), #Nb)
   Close #Nb
   arr = Split(s, Chr(13))
   If StartLine >= UBound(arr) + 1 Then
      MsgBox "First call : " & vbCrLf & "    The file contains only " & UBound(arr) + 1 & " lines"
   ElseIf StartLine + NumberOfLines > UBound(arr) + 1 Then
      MsgBox "Second call : " & vbCrLf & "    You only can remove " & UBound(arr) + 1 - StartLine & " lines"
   Else
      For i = LBound(arr) To UBound(arr)
         If i < StartLine - 1 Or i >= StartLine + NumberOfLines - 1 Then
            ReDim Preserve out(j)
            out(j) = arr(i)
            j = j + 1
         End If
      Next i
      Nb = FreeFile
      Open StrFile For Output As #Nb
         Print #Nb, Join(out, Chr(13))
      Close #Nb
   End If
End Sub
