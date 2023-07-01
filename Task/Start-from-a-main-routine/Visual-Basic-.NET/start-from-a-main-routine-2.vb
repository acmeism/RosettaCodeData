Module Main
    Sub Main(args As String())
        Console.WriteLine("main; args:" & String.Join(", ", args))
        Application.Run(New Form1())
    End Sub
End Module
