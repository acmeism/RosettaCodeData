Module Module1

  Sub Main()
    Dim s() As String = Nothing

    s = Console.ReadLine().Split(" "c)
    Console.WriteLine(CInt(s(0)) + CInt(s(1)))
  End Sub

End Module
