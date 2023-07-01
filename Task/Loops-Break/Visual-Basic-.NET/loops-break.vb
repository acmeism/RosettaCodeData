Module Program
    Sub Main()
        ' Initialize with seed 0 to get deterministic output (may vary across .NET versions, though).
        Dim rand As New Random(0)

        Do
            Dim first = rand.Next(20) ' Upper bound is exclusive.
            Console.Write(first & " ")

            If first = 10 Then Exit Do

            Dim second = rand.Next(20)
            Console.Write(second & " ")
        Loop
    End Sub
End Module
