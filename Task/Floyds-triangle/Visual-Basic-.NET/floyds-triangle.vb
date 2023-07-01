Imports System.Text

Module Module1

    Function MakeTriangle(rows As Integer) As String
        Dim maxValue As Integer = (rows * (rows + 1)) / 2
        Dim digit = 0
        Dim output As New StringBuilder

        For row = 1 To rows
            For column = 0 To row - 1
                Dim colMaxDigit = (maxValue - rows) + column + 1
                If column > 0 Then
                    output.Append(" ")
                End If

                digit = digit + 1
                output.Append(digit.ToString().PadLeft(colMaxDigit.ToString().Length))
            Next

            output.AppendLine()
        Next

        Return output.ToString()
    End Function

    Sub Main()
        Dim args = Environment.GetCommandLineArgs()
        Dim count As Integer

        If args.Length > 1 AndAlso Integer.TryParse(args(1), count) AndAlso count > 0 Then
            Console.WriteLine(MakeTriangle(count))
        Else
            Console.WriteLine(MakeTriangle(5))
            Console.WriteLine()
            Console.WriteLine(MakeTriangle(14))
        End If
    End Sub

End Module
