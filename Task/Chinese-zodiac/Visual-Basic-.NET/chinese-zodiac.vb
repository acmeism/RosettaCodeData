Module Module1

    ReadOnly ANIMALS As String() = {"Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"}
    ReadOnly ELEMENTS As String() = {"Wood", "Fire", "Earth", "Metal", "Water"}
    ReadOnly ANIMAL_CHARS As String() = {"子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"}
    ReadOnly ELEMENT_CHARS As String(,) = {{"甲", "丙", "戊", "庚", "壬"}, {"乙", "丁", "己", "辛", "癸"}}

    Function GetYY(year As Integer) As String
        If year Mod 2 = 0 Then
            Return "yang"
        End If
        Return "yin"
    End Function

    Sub Main()
        Console.OutputEncoding = System.Text.Encoding.UTF8
        Dim years = {1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017}
        For i = 0 To years.Length - 1
            Dim t0 = years(i)
            Dim t1 = t0 - 4.0
            Dim t2 = t1 Mod 10
            Dim t3 = t2 / 2
            Dim t4 = Math.Floor(t3)

            Dim ei As Integer = Math.Floor(((years(i) - 4.0) Mod 10) / 2)
            Dim ai = (years(i) - 4) Mod 12
            Console.WriteLine("{0} is the year of the {1} {2} ({3}). {4}{5}", years(i), ELEMENTS(ei), ANIMALS(ai), GetYY(years(i)), ELEMENT_CHARS(years(i) Mod 2, ei), ANIMAL_CHARS((years(i) - 4) Mod 12))
        Next
    End Sub

End Module
