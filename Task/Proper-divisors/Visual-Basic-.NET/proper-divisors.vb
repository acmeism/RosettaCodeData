Module Module1

    Function ProperDivisors(number As Integer) As IEnumerable(Of Integer)
        Return Enumerable.Range(1, number / 2).Where(Function(divisor As Integer) number Mod divisor = 0)
    End Function

    Sub Main()
        For Each number In Enumerable.Range(1, 10)
            Console.WriteLine("{0}: {{{1}}}", number, String.Join(", ", ProperDivisors(number)))
        Next

        Dim record = Enumerable.Range(1, 20000).Select(Function(number) New With {.Number = number, .Count = ProperDivisors(number).Count()}).OrderByDescending(Function(currentRecord) currentRecord.Count).First()
        Console.WriteLine("{0}: {1}", record.Number, record.Count)
    End Sub

End Module
