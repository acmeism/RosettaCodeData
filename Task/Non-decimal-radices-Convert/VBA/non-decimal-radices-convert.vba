Private Function to_base(ByVal number As Long, base As Integer) As String
    Dim digits As String, result As String
    Dim i As Integer, digit As Integer
    digits = "0123456789abcdefghijklmnopqrstuvwxyz"
    Do While number > 0
        digit = number Mod base
        result = Mid(digits, digit + 1, 1) & result
        number = number \ base
    Loop
    to_base = result
End Function
Private Function from_base(number As String, base As Integer) As Long
    Dim digits As String, result As Long
    Dim i As Integer
    digits = "0123456789abcdefghijklmnopqrstuvwxyz"
    result = Val(InStr(1, digits, Mid(number, 1, 1), vbTextCompare) - 1)
    For i = 2 To Len(number)
        result = result * base + Val(InStr(1, digits, Mid(number, i, 1), vbTextCompare) - 1)
    Next i
    from_base = result
End Function
Public Sub Non_decimal_radices_Convert()
    Debug.Print "26 decimal in base 16 is: "; to_base(26, 16); ". Conversely, hexadecimal 1a in decimal is: "; from_base("1a", 16)
End Sub
