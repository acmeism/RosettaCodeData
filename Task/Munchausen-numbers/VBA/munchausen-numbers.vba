Option Explicit

Sub Main_Munchausen_numbers()
Dim i&

    For i = 1 To 5000
        If IsMunchausen(i) Then Debug.Print i & " is a munchausen number."
    Next i
End Sub

Function IsMunchausen(Number As Long) As Boolean
Dim Digits, i As Byte, Tot As Long

    Digits = Split(StrConv(Number, vbUnicode), Chr(0))
    For i = 0 To UBound(Digits) - 1
        Tot = (Digits(i) ^ Digits(i)) + Tot
    Next i
    IsMunchausen = (Tot = Number)
End Function
