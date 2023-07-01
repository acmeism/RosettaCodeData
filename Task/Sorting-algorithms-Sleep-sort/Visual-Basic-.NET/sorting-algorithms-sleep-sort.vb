Imports System.Threading

Module Module1

    Sub SleepSort(items As IEnumerable(Of Integer))
        For Each item In items
            Task.Factory.StartNew(Sub()
                                      Thread.Sleep(1000 * item)
                                      Console.WriteLine(item)
                                  End Sub)
        Next
    End Sub

    Sub Main()
        SleepSort({1, 5, 2, 1, 8, 10, 3})
        Console.ReadKey()
    End Sub

End Module
