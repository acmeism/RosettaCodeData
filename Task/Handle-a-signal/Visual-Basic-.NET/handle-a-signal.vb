Module Module1
    Dim startTime As Date

    Sub Main()
        startTime = Date.Now
        ' Add event handler for Cntrl+C command
        AddHandler Console.CancelKeyPress, AddressOf Console_CancelKeyPress

        Dim counter = 0
        While True
            counter += 1
            Console.WriteLine(counter)
            Threading.Thread.Sleep(500)
        End While
    End Sub

    Sub Console_CancelKeyPress(sender As Object, e As ConsoleCancelEventArgs)
        Dim stopTime = Date.Now
        Console.WriteLine("This program ran for {0:000.000} seconds", (stopTime - startTime).TotalMilliseconds / 1000)
        Environment.Exit(0)
    End Sub

End Module
