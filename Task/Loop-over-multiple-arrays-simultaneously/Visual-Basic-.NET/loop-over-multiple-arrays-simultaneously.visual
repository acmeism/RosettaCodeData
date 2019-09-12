Module Program
    Sub Main()
        Dim a As Char() = {"a"c, "b"c, "c"c}
        Dim b As Char() = {"A"c, "B"c, "C"c}
        Dim c As Integer() = {1, 2, 3}

        Dim minLength = {a.Length, b.Length, c.Length}.Min()
        For i = 0 To minLength - 1
            Console.WriteLine(a(i) & b(i) & c(i))
        Next

        Console.WriteLine()

        For Each el As (a As Char, b As Char, c As Integer) In a.Zip(b, Function(l, r) (l, r)).Zip(c, Function(x, r) (x.l, x.r, r))
            Console.WriteLine(el.a & el.b & el.c)
        Next
    End Sub
End Module
