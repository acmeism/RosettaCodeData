Imports Microsoft.VisualBasic.FileIO

Module Program
    Sub Main(args As String())
        Dim parser As TextFieldParser
        Try
            If args.Length > 1 Then
                parser = My.Computer.FileSystem.OpenTextFieldParser(args(1), ",")
            Else
                parser = New TextFieldParser(Console.In) With {.Delimiters = {","}}
            End If

            Dim getLines =
            Iterator Function() As IEnumerable(Of String())
                Do Until parser.EndOfData
                    Yield parser.ReadFields()
                Loop
            End Function

            Dim result = CSVTOHTML(getLines(), If(args.Length > 0, Boolean.Parse(args(0)), False))

            Console.WriteLine(result)
        Finally
            If parser IsNot Nothing Then parser.Dispose()
        End Try
    End Sub

    Function CSVTOHTML(lines As IEnumerable(Of IEnumerable(Of String)), useTHead As Boolean) As XElement
        Dim getRow = Function(row As IEnumerable(Of String)) From field In row Select <td><%= field %></td>

        CSVTOHTML =
<table>
    <%= From l In lines.Select(
            Function(line, i)
                If useTHead AndAlso i = 0 Then
                    Return <thead><%= getRow(line) %></thead>
                Else
                    Return <tr><%= getRow(line) %></tr>
                End If
            End Function) %>
</table>
    End Function
End Module
