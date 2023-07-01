Imports System.Threading
Module Module1
    Dim rnd As New Random()
    Sub Main()
        Parallel.ForEach("Enjoy Rosetta Code".Split(" "), Sub(s)
            Thread.Sleep(rnd.Next(25)) : Console.WriteLine(s)
        End Sub)
    End Sub
End Module
