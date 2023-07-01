Imports System.Text

Module Module1

    Function GetTaxicabNumbers(length As Integer) As IDictionary(Of Long, IList(Of Tuple(Of Integer, Integer)))
        Dim sumsOfTwoCubes As New SortedList(Of Long, IList(Of Tuple(Of Integer, Integer)))

        For i = 1 To Integer.MaxValue - 1
            For j = 1 To Integer.MaxValue - 1
                Dim sum = CLng(Math.Pow(i, 3) + Math.Pow(j, 3))

                If Not sumsOfTwoCubes.ContainsKey(sum) Then
                    sumsOfTwoCubes.Add(sum, New List(Of Tuple(Of Integer, Integer)))
                End If

                sumsOfTwoCubes(sum).Add(Tuple.Create(i, j))

                If j >= i Then
                    Exit For
                End If
            Next

            REM Found that you need to keep going for a while after the length, because higher i values fill in gaps
            If sumsOfTwoCubes.AsEnumerable.Count(Function(t) t.Value.Count >= 2) >= length * 1.1 Then
                Exit For
            End If
        Next

        Dim values = (From t In sumsOfTwoCubes Where t.Value.Count >= 2 Select t) _
            .Take(2006) _
            .ToDictionary(Function(u) u.Key, Function(u) u.Value)
        Return values
    End Function

    Sub PrintTaxicabNumbers(values As IDictionary(Of Long, IList(Of Tuple(Of Integer, Integer))))
        Dim i = 1
        For Each taxicabNumber In values.Keys
            Dim output As New StringBuilder
            output.AppendFormat("{0,10}" + vbTab + "{1,4}", i, taxicabNumber)

            For Each numbers In values(taxicabNumber)
                output.AppendFormat(vbTab + "= {0}^3 + {1}^3", numbers.Item1, numbers.Item2)
            Next

            If i <= 25 OrElse (i >= 2000 AndAlso i <= 2006) Then
                Console.WriteLine(output.ToString)
            End If

            i += 1
        Next
    End Sub

    Sub Main()
        Dim taxicabNumbers = GetTaxicabNumbers(2006)
        PrintTaxicabNumbers(taxicabNumbers)
    End Sub

End Module
