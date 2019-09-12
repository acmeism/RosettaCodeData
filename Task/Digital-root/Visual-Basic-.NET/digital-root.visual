Module Module1

    Function DigitalRoot(num As Long) As Tuple(Of Integer, Integer)
        Dim additivepersistence = 0
        While num > 9
            num = num.ToString().ToCharArray().Sum(Function(x) Integer.Parse(x))
            additivepersistence = additivepersistence + 1
        End While
        Return Tuple.Create(additivepersistence, CType(num, Integer))
    End Function

    Sub Main()
        Dim nums = {627615, 39390, 588225, 393900588225}
        For Each num In nums
            Dim t = DigitalRoot(num)
            Console.WriteLine("{0} has additive persistence {1} and digital root {2}", num, t.Item1, t.Item2)
        Next
    End Sub

End Module
