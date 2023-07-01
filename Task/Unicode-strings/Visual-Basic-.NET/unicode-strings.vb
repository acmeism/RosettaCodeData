Module Module1

    Sub Main()
        Console.OutputEncoding = Text.Encoding.Unicode

        ' normal identifiers allowed
        Dim a = 0
        ' unicode characters allowed
        Dim δ = 1

        ' ascii strings
        Console.WriteLine("some text")
        ' unicode strings strings
        Console.WriteLine("こんにちは")
        Console.WriteLine("Здравствуйте")
        Console.WriteLine("שלום")
        ' escape sequences
        Console.WriteLine(vbTab + "text" + vbTab + ChrW(&H2708) + """blue")
        Console.ReadLine()
    End Sub

End Module
