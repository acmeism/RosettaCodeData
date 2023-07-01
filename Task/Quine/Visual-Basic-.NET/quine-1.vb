Module Program
    Sub Main()
        Dim s = "
Module Program
    Sub Main()
        Dim s = {0}{1}{0}
        Console.WriteLine(s, ChrW(34), s)
    End Sub
End Module"
        Console.WriteLine(s, ChrW(34), s)
    End Sub
End Module
