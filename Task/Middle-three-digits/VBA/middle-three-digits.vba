Option Explicit

Sub Main_Middle_three_digits()
Dim Numbers, i&
    Numbers = Array(123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, _
    100, -12345, 1, 2, -1, -10, 2002, -2002, 0)
    For i = 0 To 16
        Debug.Print Numbers(i) & " Return : " & Middle3digits(CStr(Numbers(i)))
    Next
End Sub

Function Middle3digits(strNb As String) As String
    If Left(strNb, 1) = "-" Then strNb = Right(strNb, Len(strNb) - 1)
    If Len(strNb) < 3 Then
        Middle3digits = "Error ! Number of digits must be >= 3"
    ElseIf Len(strNb) Mod 2 = 0 Then
        Middle3digits = "Error ! Number of digits must be odd"
    Else
        Middle3digits = Mid(strNb, 1 + (Len(strNb) - 3) / 2, 3)
    End If
End Function
