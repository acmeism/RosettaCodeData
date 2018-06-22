Public Function Bin(ByVal l As Long) As String
Dim i As Long
  If l Then
    If l And &H80000000 Then 'negative number
      Bin = "1" & String$(31, "0")
      l = l And (Not &H80000000)

      For i = 0 To 30
      If l And (2& ^ i) Then
        Mid$(Bin, Len(Bin) - i) = "1"
      End If
      Next i

    Else                     'positive number
      Do While l
      If l Mod 2 Then
        Bin = "1" & Bin
      Else
        Bin = "0" & Bin
      End If
      l = l \ 2
      Loop
    End If
  Else
    Bin = "0"                'zero
  End If
End Function

'testing:
Public Sub Main()
  Debug.Print "5: " & Bin(5)
  Debug.Print "50: " & Bin(50)
  Debug.Print "9000: " & Bin(9000)
End Sub
