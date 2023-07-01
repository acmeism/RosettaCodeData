Imports System.Numerics

Module Module1
    Iterator Function GetRow(rowNumber As BigInteger) As IEnumerable(Of BigInteger)
        Dim denominator As BigInteger = 1
        Dim numerator = rowNumber

        Dim currentValue As BigInteger = 1
        For counter = 0 To rowNumber
            Yield currentValue
            currentValue = currentValue * numerator
            numerator = numerator - 1
            currentValue = currentValue / denominator
            denominator = denominator + 1
        Next
    End Function

    Function GetTriangle(quantityOfRows As Integer) As IEnumerable(Of BigInteger())
        Dim range = Enumerable.Range(0, quantityOfRows).Select(Function(num) New BigInteger(num))
        Return range.Select(Function(num) GetRow(num).ToArray())
    End Function

    Function CenterString(text As String, width As Integer)
        Dim spaces = width - text.Length
        Dim padLeft = (spaces / 2) + text.Length
        Return text.PadLeft(padLeft).PadRight(width)
    End Function

    Function FormatTriangleString(triangle As IEnumerable(Of BigInteger())) As String
        Dim maxDigitWidth = triangle.Last().Max().ToString().Length
        Dim rows = triangle.Select(Function(arr) String.Join(" ", arr.Select(Function(array) CenterString(array.ToString(), maxDigitWidth))))
        Dim maxRowWidth = rows.Last().Length
        Return String.Join(Environment.NewLine, rows.Select(Function(row) CenterString(row, maxRowWidth)))
    End Function

    Sub Main()
        Dim triangle = GetTriangle(20)
        Dim output = FormatTriangleString(triangle)
        Console.WriteLine(output)
    End Sub

End Module
