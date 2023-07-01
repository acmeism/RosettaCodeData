Option Explicit

Sub Main()
   'See Output #1
   RemoveLines "C:\Users\" & Environ("username") & "\Desktop\foobar.txt", 11, 5
   'See Output #2
   RemoveLines "C:\Users\" & Environ("username") & "\Desktop\foobar.txt", 8, 5
   'See Output #3
   RemoveLines "C:\Users\" & Environ("username") & "\Desktop\foobar.txt", 3, 5
End Sub

Private Sub RemoveLines(StrFile As String, StartLine As Long, NumberOfLines As Long)
Dim Nb As Integer, s As String, count As Long, out As String
   Nb = FreeFile
   Open StrFile For Input As #Nb
      While Not EOF(Nb)
         count = count + 1
         Line Input #Nb, s
         If count < StartLine Or count >= StartLine + NumberOfLines Then
            out = out & s & vbCrLf
         End If
      Wend
   Close #Nb
   If StartLine >= count Then
      MsgBox "The file contains only " & count & " lines"
   ElseIf StartLine + NumberOfLines > count Then
      MsgBox "You only can remove " & count - StartLine & " lines"
   Else
      Nb = FreeFile
      Open StrFile For Output As #Nb
         Print #Nb, out
      Close #Nb
   End If
End Sub
