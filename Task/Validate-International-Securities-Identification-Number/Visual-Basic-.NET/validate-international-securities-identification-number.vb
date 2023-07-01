Option Strict On
Imports System.Text.RegularExpressions

Module Module1
    ReadOnly IsinRegex As New Regex("^[A-Z]{2}[A-Z0-9]{9}\d$", RegexOptions.Compiled)

    Function DigitValue(c As Char) As Integer
        Dim temp As Integer
        If Asc(c) >= Asc("0"c) AndAlso Asc(c) <= Asc("9"c) Then
            temp = Asc(c) - Asc("0"c)
        Else
            temp = Asc(c) - Asc("A"c) + 10
        End If
        Return temp
    End Function

    Function LuhnTest(number As String) As Boolean
        Return number.Select(Function(c, i) (AscW(c) - 48) << ((number.Length - i - 1) And 1)).Sum(Function(n) If(n > 9, n - 9, n)) Mod 10 = 0
    End Function

    Function Digitize(isin As String) As String
        Return String.Join("", isin.Select(Function(c) $"{DigitValue(c)}"))
    End Function

    Function IsValidIsin(isin As String) As Boolean
        Return IsinRegex.IsMatch(isin) AndAlso LuhnTest(Digitize(isin))
    End Function

    Sub Main()
        Dim isins() = {
            "US0378331005",
            "US0373831005",
            "U50378331005",
            "US03378331005",
            "AU0000XVGZA3",
            "AU0000VXGZA3",
            "FR0000988040"
        }

        For Each isin In isins
            If IsValidIsin(isin) Then
                Console.WriteLine("{0} is valid", isin)
            Else
                Console.WriteLine("{0} is not valid", isin)
            End If
        Next
    End Sub

End Module
