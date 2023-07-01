' Roman numerals Encode - Visual Basic - 18/04/2019

Function toRoman(ByVal value)
    Dim arabic
    Dim roman
    Dim i, result
    arabic = Array(1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
    roman = Array("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")
    For i = 0 To 12
        Do While value >= arabic(i)
            result = result + roman(i)
            value = value - arabic(i)
        Loop
    Next 'i
    toRoman = result
End Function 'toRoman

    n=InputBox("Number, please","Roman numerals/Encode")
    code=MsgBox(n & vbCrlf & toRoman(n),vbOKOnly+vbExclamation,"Roman numerals/Encode")
	If code=vbOK Then ok=1
