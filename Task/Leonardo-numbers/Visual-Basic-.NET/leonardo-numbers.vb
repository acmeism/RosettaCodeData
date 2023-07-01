Module Module1

    Iterator Function Leonardo(Optional L0 = 1, Optional L1 = 1, Optional add = 1) As IEnumerable(Of Integer)
        While True
            Yield L0
            Dim t = L0 + L1 + add
            L0 = L1
            L1 = t
        End While
    End Function

    Sub Main()
        Console.WriteLine(String.Join(" ", Leonardo().Take(25)))
        Console.WriteLine(String.Join(" ", Leonardo(0, 1, 0).Take(25)))
    End Sub

End Module
