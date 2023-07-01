Module Module1
    Private Delegate Function Justification(s As String, width As Integer) As String

    Private Function AlignColumns(lines As String(), justification As Justification) As String()
        Const Separator As Char = "$"c
        ' build input container table and calculate columns count
        Dim containerTbl As String()() = New String(lines.Length - 1)() {}
        Dim columns As Integer = 0
        For i As Integer = 0 To lines.Length - 1
            Dim row As String() = lines(i).TrimEnd(Separator).Split(Separator)
            If columns < row.Length Then
                columns = row.Length
            End If
            containerTbl(i) = row
        Next
        ' create formatted container table
        Dim formattedTable As String()() = New String(containerTbl.Length - 1)() {}
        For i As Integer = 0 To formattedTable.Length - 1
            formattedTable(i) = New String(columns - 1) {}
        Next
        For j As Integer = 0 To columns - 1
            ' get max column width
            Dim columnWidth As Integer = 0
            For i As Integer = 0 To containerTbl.Length - 1
                If j < containerTbl(i).Length AndAlso columnWidth < containerTbl(i)(j).Length Then
                    columnWidth = containerTbl(i)(j).Length
                End If
            Next
            ' justify column cells
            For i As Integer = 0 To formattedTable.Length - 1
                If j < containerTbl(i).Length Then
                    formattedTable(i)(j) = justification(containerTbl(i)(j), columnWidth)
                Else
                    formattedTable(i)(j) = New [String](" "c, columnWidth)
                End If
            Next
        Next
        ' create result
        Dim result As String() = New String(formattedTable.Length - 1) {}
        For i As Integer = 0 To result.Length - 1
            result(i) = [String].Join(" ", formattedTable(i))
        Next
        Return result
    End Function

    Private Function JustifyLeft(s As String, width As Integer) As String
        Return s.PadRight(width)
    End Function
    Private Function JustifyRight(s As String, width As Integer) As String
        Return s.PadLeft(width)
    End Function
    Private Function JustifyCenter(s As String, width As Integer) As String
        Return s.PadLeft((width + s.Length) / 2).PadRight(width)
    End Function

    Sub Main()
        Dim input As String() = {"Given$a$text$file$of$many$lines,$where$fields$within$a$line$", "are$delineated$by$a$single$'dollar'$character,$write$a$program", "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$", "column$are$separated$by$at$least$one$space.", "Further,$allow$for$each$word$in$a$column$to$be$either$left$", "justified,$right$justified,$or$center$justified$within$its$column."}

        For Each line As String In AlignColumns(input, AddressOf JustifyLeft)
            Console.WriteLine(line)
        Next
        Console.ReadLine()
    End Sub

End Module
