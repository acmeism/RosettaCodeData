Function toRoman(value) As String
    Dim arabic As Variant
    Dim roman As Variant

    arabic = Array(1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
    roman = Array("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")

    Dim i As Integer, result As String

    For i = 0 To 12
        Do While value >= arabic(i)
            result = result + roman(i)
            value = value - arabic(i)
        Loop
    Next i

    toRoman = result
End Function

Sub Main()
    MsgBox toRoman(Val(InputBox("Number, please")))
End Sub
