Module Module1

    Sub Fork()
        Console.WriteLine("Spawned Thread")
    End Sub

    Sub Main()
        Dim t As New System.Threading.Thread(New Threading.ThreadStart(AddressOf Fork))
        t.Start()

        Console.WriteLine("Main Thread")
        t.Join()
    End Sub

End Module
