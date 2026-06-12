Module Module1

    Function TwoSum(numbers As Integer(), sum As Integer) As Integer()
        Dim map As New Dictionary(Of Integer, Integer)
        For index = 1 To numbers.Length
            Dim i = index - 1
            ' see if the complement is stored
            Dim key = sum - numbers(i)
            If map.ContainsKey(key) Then
                Return {map(key), i}
            End If
            map.Add(numbers(i), i)
        Next
        Return Nothing
    End Function

    Sub Main()
        Dim arr = {0, 2, 1, 19, 90}
        Const sum = 21

        Dim ts = TwoSum(arr, sum)
        Console.WriteLine(If(IsNothing(ts), "no result", $"{ts(0)}, {ts(1)}"))
    End Sub

End Module
