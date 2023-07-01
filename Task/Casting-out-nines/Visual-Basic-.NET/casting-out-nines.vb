Module Module1
    Sub Print(ls As List(Of Integer))
        Dim iter = ls.GetEnumerator
        Console.Write("[")
        If iter.MoveNext Then
            Console.Write(iter.Current)
        End If
        While iter.MoveNext
            Console.Write(", ")
            Console.Write(iter.Current)
        End While
        Console.WriteLine("]")
    End Sub

    Function CastOut(base As Integer, start As Integer, last As Integer) As List(Of Integer)
        Dim ran = Enumerable.Range(0, base - 1).Where(Function(y) y Mod (base - 1) = (y * y) Mod (base - 1)).ToArray()
        Dim x = start \ (base - 1)

        Dim result As New List(Of Integer)
        While True
            For Each n In ran
                Dim k = (base - 1) * x + n
                If k < start Then
                    Continue For
                End If
                If k > last Then
                    Return result
                End If
                result.Add(k)
            Next
            x += 1
        End While
        Return result
    End Function

    Sub Main()
        Print(CastOut(16, 1, 255))
        Print(CastOut(10, 1, 99))
        Print(CastOut(17, 1, 288))
    End Sub

End Module
