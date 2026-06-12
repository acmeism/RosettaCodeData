Imports System.Globalization

Module Module1

    Function DateDiff(d1 As String, d2 As String) As Integer
        Dim a = DateTime.ParseExact(d1, "yyyy-MM-dd", CultureInfo.InvariantCulture)
        Dim b = DateTime.ParseExact(d2, "yyyy-MM-dd", CultureInfo.InvariantCulture)
        Return (b - a).TotalDays
    End Function

    Sub Main()
        Console.WriteLine(DateDiff("1970-01-01", "2019-10-18"))
    End Sub

End Module
