Module Module1

    Sub Main()
        Dim input() = {"", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"}
        For Each s In input
            Console.WriteLine($"'{s}' (Length {s.Length}) " + String.Join(", ", s.Select(Function(c, i) (c, i)).GroupBy(Function(t) t.c).Where(Function(g) g.Count() > 1).Select(Function(g) $"'{g.Key}' (0X{AscW(g.Key):X})[{String.Join(", ", g.Select(Function(t) t.i))}]").DefaultIfEmpty("All characters are unique.")))
        Next
    End Sub

End Module
