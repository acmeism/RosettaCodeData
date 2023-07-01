Sub Main_Abbr_Auto()
Dim Nb As Integer, s As String, Result() As String, c As Integer
   Nb = FreeFile
   Open "C:\Users\" & Environ("Username") & "\Desktop\Abbreviations_Auto.txt" For Input As #Nb
      While Not EOF(Nb)
         Line Input #Nb, s
         If InStr(s, "þ") > 0 Then s = Right(s, Len(s) - 2)
         If s <> vbNullString Then
            ReDim Preserve Result(c)
            Result(c) = Left$(MinimalLenght(s) & "    ", 4) & s
            Debug.Print Result(c)
            c = c + 1
         End If
      Wend
   Close #Nb
End Sub
