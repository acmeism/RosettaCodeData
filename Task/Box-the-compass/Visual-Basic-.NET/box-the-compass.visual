Module BoxingTheCompass
    Dim _points(32) As String

    Sub Main()
        BuildPoints()

        Dim heading As Double = 0D

        For i As Integer = 0 To 32
            heading = i * 11.25
            Select Case i Mod 3
                Case 1
                    heading += 5.62
                Case 2
                    heading -= 5.62
            End Select

            Console.WriteLine("{0,2}: {1,-18} {2,6:F2}°", (i Mod 32) + 1, InitialUpper(GetPoint(heading)), heading)
        Next
    End Sub

    Private Sub BuildPoints()
        Dim cardinal As String() = New String() {"north", "east", "south", "west"}
        Dim pointDesc As String() = New String() {"1", "1 by 2", "1-C", "C by 1", "C", "C by 2", "2-C", "2 by 1"}

        Dim str1, str2, strC As String

        For i As Integer = 0 To 3
            str1 = cardinal(i)
            str2 = cardinal((i + 1) Mod 4)
            strC = IIf(str1 = "north" Or str1 = "south", str1 & str2, str2 & str1)
            For j As Integer = 0 To 7
                _points(i * 8 + j) = pointDesc(j).Replace("1", str1).Replace("2", str2).Replace("C", strC)
            Next
        Next
    End Sub

    Private Function InitialUpper(ByVal s As String) As String
        Return s.Substring(0, 1).ToUpper() & s.Substring(1)
    End Function

    Private Function GetPoint(ByVal Degrees As Double) As String
        Dim testD As Double = (Degrees / 11.25) + 0.5
        Return _points(CInt(Math.Floor(testD Mod 32)))
    End Function
End Module
