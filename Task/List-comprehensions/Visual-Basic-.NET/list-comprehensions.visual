Module ListComp
    Sub Main()
        Dim ts = From a In Enumerable.Range(1, 20) _
                 From b In Enumerable.Range(a, 21 - a) _
                 From c In Enumerable.Range(b, 21 - b) _
                 Where a * a + b * b = c * c _
                 Select New With { a, b, c }

        For Each t In ts
            System.Console.WriteLine("{0}, {1}, {2}", t.a, t.b, t.c)
        Next
    End Sub
End Module
