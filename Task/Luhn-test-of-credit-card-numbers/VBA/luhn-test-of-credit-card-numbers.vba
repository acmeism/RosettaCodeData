Option Explicit

Sub Main()
  Debug.Print "Number 49927398716 is "; Luhn("49927398716")
  Debug.Print "Number 49927398717 is "; Luhn("49927398717")
  Debug.Print "Number 1234567812345678 is "; Luhn("1234567812345678")
  Debug.Print "Number 1234567812345670 is "; Luhn("1234567812345670")
End Sub
Private Function Luhn(Nb As String) As String
Dim t$, i&, Summ&, s&
    t = StrReverse(Nb)
    For i = 1 To Len(t) Step 2
        Summ = Summ + CInt(Mid(t, i, 1))
    Next i
    For i = 2 To Len(t) Step 2
        s = 2 * (CInt(Mid(t, i, 1)))
        If s >= 10 Then
            Summ = Summ - 9
        End If
        Summ = Summ + s
    Next i
    If Summ Mod 10 = 0 Then
        Luhn = "valid"
    Else
        Luhn = "invalid"
    End If
End Function
