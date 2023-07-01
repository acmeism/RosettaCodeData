Module Program
    Sub Main()
        Const ROWS = 10
        Const COLS = 10

        ' Initialize with seed 0 to get deterministic output (may vary across .NET versions, though).
        Dim rand As New Random(0)

        ' VB uses max index array declarations
        Dim nums(ROWS - 1, COLS - 1) As Integer

        For r = 0 To ROWS - 1
            For c = 0 To COLS - 1
                nums(r, c) = rand.Next(0, 21) ' Upper bound is exclusive.
            Next
        Next

        ' MISSING IMPLEMENTATION
    End Sub
End Module
