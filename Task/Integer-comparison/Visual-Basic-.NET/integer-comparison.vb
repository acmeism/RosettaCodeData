Sub Main()

    Dim a = CInt(Console.ReadLine)
    Dim b = CInt(Console.ReadLine)

    'Using if statements
    If a < b Then Console.WriteLine("a is less than b")
    If a = b Then Console.WriteLine("a equals b")
    If a > b Then Console.WriteLine("a is greater than b")

    'Using Case
    Select Case a
        Case Is < b
            Console.WriteLine("a is less than b")
        Case b
            Console.WriteLine("a equals b")
        Case Is > b
            Console.WriteLine("a is greater than b")
    End Select

End Sub
