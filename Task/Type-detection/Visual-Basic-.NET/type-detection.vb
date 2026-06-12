Module TypeDetection

    Sub Main()
        printTypeOf(5)
        printTypeOf("VB.Net")
        printTypeOf(7.2)
        printTypeOf(True)
    End Sub

    Private Sub printTypeOf(obj As Object)
        Console.WriteLine(obj.GetType.ToString)
    End Sub

End Module
