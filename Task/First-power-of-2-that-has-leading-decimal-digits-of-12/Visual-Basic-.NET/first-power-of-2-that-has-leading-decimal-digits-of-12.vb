Module Module1

    Function Func(ByVal l As Integer, ByVal n As Integer) As Long
        Dim res As Long = 0, f As Long = 1
        Dim lf As Double = Math.Log10(2)
        Dim i As Integer = l

        While i > 10
            f *= 10
            i /= 10
        End While

        While n > 0
            res += 1

            If CInt((f * Math.Pow(10, res * lf Mod 1))) = l Then
                n -= 1
            End If
        End While

        Return res
    End Function

    Sub Main()
        Dim values = {Tuple.Create(12, 1), Tuple.Create(12, 2), Tuple.Create(123, 45), Tuple.Create(123, 12345), Tuple.Create(123, 678910), Tuple.Create(99, 1)}
        For Each pair In values
            Console.WriteLine("p({0,3}, {1,6}) = {2,11:n0}", pair.Item1, pair.Item2, Func(pair.Item1, pair.Item2))
        Next
    End Sub

End Module
