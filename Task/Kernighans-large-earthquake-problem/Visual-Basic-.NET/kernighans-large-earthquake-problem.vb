Imports System.IO

Module Module1

    Function LargeEarthquakes(filename As String, limit As Double) As IEnumerable(Of String())
        Return From line In File.ReadLines(filename)
               Let parts = line.Split(CType(Nothing, Char()), StringSplitOptions.RemoveEmptyEntries)
               Where Double.Parse(parts(2)) > limit
               Select parts
    End Function

    Sub Main()
        For Each earthquake In LargeEarthquakes("data.txt", 6)
            Console.WriteLine(String.Join(" ", earthquake))
        Next
    End Sub

End Module
