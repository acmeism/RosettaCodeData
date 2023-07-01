Module Module1

    ReadOnly Dirs As Integer(,) = {
        {1, 0}, {0, 1}, {1, 1},
        {1, -1}, {-1, 0},
        {0, -1}, {-1, -1}, {-1, 1}
    }

    Const RowCount = 10
    Const ColCount = 10
    Const GridSize = RowCount * ColCount
    Const MinWords = 25

    Class Grid
        Public cells(RowCount - 1, ColCount - 1) As Char
        Public solutions As New List(Of String)
        Public numAttempts As Integer

        Sub New()
            For i = 0 To RowCount - 1
                For j = 0 To ColCount - 1
                    cells(i, j) = ControlChars.NullChar
                Next
            Next
        End Sub
    End Class

    Dim Rand As New Random()

    Sub Main()
        PrintResult(CreateWordSearch(ReadWords("unixdict.txt")))
    End Sub

    Function ReadWords(filename As String) As List(Of String)
        Dim maxlen = Math.Max(RowCount, ColCount)
        Dim words As New List(Of String)

        Dim objReader As New IO.StreamReader(filename)
        Dim line As String
        Do While objReader.Peek() <> -1
            line = objReader.ReadLine()
            If line.Length > 3 And line.Length < maxlen Then
                If line.All(Function(c) Char.IsLetter(c)) Then
                    words.Add(line)
                End If
            End If
        Loop

        Return words
    End Function

    Function CreateWordSearch(words As List(Of String)) As Grid
        For numAttempts = 1 To 1000
            Shuffle(words)

            Dim grid As New Grid()
            Dim messageLen = PlaceMessage(grid, "Rosetta Code")
            Dim target = GridSize - messageLen

            Dim cellsFilled = 0
            For Each word In words
                cellsFilled = cellsFilled + TryPlaceWord(grid, word)
                If cellsFilled = target Then
                    If grid.solutions.Count >= MinWords Then
                        grid.numAttempts = numAttempts
                        Return grid
                    Else
                        'grid is full but we didn't pack enough words, start over
                        Exit For
                    End If
                End If
            Next
        Next

        Return Nothing
    End Function

    Function PlaceMessage(grid As Grid, msg As String) As Integer
        msg = msg.ToUpper()
        msg = msg.Replace(" ", "")

        If msg.Length > 0 And msg.Length < GridSize Then
            Dim gapSize As Integer = GridSize / msg.Length

            Dim pos = 0
            Dim lastPos = -1
            For i = 0 To msg.Length - 1
                If i = 0 Then
                    pos = pos + Rand.Next(gapSize - 1)
                Else
                    pos = pos + Rand.Next(2, gapSize - 1)
                End If
                Dim r As Integer = Math.Floor(pos / ColCount)
                Dim c = pos Mod ColCount

                grid.cells(r, c) = msg(i)

                lastPos = pos
            Next
            Return msg.Length
        End If

        Return 0
    End Function

    Function TryPlaceWord(grid As Grid, word As String) As Integer
        Dim randDir = Rand.Next(Dirs.GetLength(0))
        Dim randPos = Rand.Next(GridSize)

        For d = 0 To Dirs.GetLength(0) - 1
            Dim dd = (d + randDir) Mod Dirs.GetLength(0)

            For p = 0 To GridSize - 1
                Dim pp = (p + randPos) Mod GridSize

                Dim lettersPLaced = TryLocation(grid, word, dd, pp)
                If lettersPLaced > 0 Then
                    Return lettersPLaced
                End If
            Next
        Next

        Return 0
    End Function

    Function TryLocation(grid As Grid, word As String, dir As Integer, pos As Integer) As Integer
        Dim r As Integer = pos / ColCount
        Dim c = pos Mod ColCount
        Dim len = word.Length

        'check bounds
        If (Dirs(dir, 0) = 1 And len + c >= ColCount) Or (Dirs(dir, 0) = -1 And len - 1 > c) Or (Dirs(dir, 1) = 1 And len + r >= RowCount) Or (Dirs(dir, 1) = -1 And len - 1 > r) Then
            Return 0
        End If
        If r = RowCount OrElse c = ColCount Then
            Return 0
        End If

        Dim rr = r
        Dim cc = c

        'check cells
        For i = 0 To len - 1
            If grid.cells(rr, cc) <> ControlChars.NullChar AndAlso grid.cells(rr, cc) <> word(i) Then
                Return 0
            End If

            cc = cc + Dirs(dir, 0)
            rr = rr + Dirs(dir, 1)
        Next

        'place
        Dim overlaps = 0
        rr = r
        cc = c
        For i = 0 To len - 1
            If grid.cells(rr, cc) = word(i) Then
                overlaps = overlaps + 1
            Else
                grid.cells(rr, cc) = word(i)
            End If

            If i < len - 1 Then
                cc = cc + Dirs(dir, 0)
                rr = rr + Dirs(dir, 1)
            End If
        Next

        Dim lettersPlaced = len - overlaps
        If lettersPlaced > 0 Then
            grid.solutions.Add(String.Format("{0,-10} ({1},{2})({3},{4})", word, c, r, cc, rr))
        End If

        Return lettersPlaced
    End Function

    Sub PrintResult(grid As Grid)
        If IsNothing(grid) OrElse grid.numAttempts = 0 Then
            Console.WriteLine("No grid to display")
            Return
        End If

        Console.WriteLine("Attempts: {0}", grid.numAttempts)
        Console.WriteLine("Number of words: {0}", GridSize)
        Console.WriteLine()

        Console.WriteLine("     0  1  2  3  4  5  6  7  8  9")
        For r = 0 To RowCount - 1
            Console.WriteLine()
            Console.Write("{0}   ", r)
            For c = 0 To ColCount - 1
                Console.Write(" {0} ", grid.cells(r, c))
            Next
        Next

        Console.WriteLine()
        Console.WriteLine()

        For i = 0 To grid.solutions.Count - 1
            If i Mod 2 = 0 Then
                Console.Write("{0}", grid.solutions(i))
            Else
                Console.WriteLine("   {0}", grid.solutions(i))
            End If
        Next

        Console.WriteLine()
    End Sub

    'taken from https://stackoverflow.com/a/20449161
    Sub Shuffle(Of T)(list As IList(Of T))
        Dim r As Random = New Random()
        For i = 0 To list.Count - 1
            Dim index As Integer = r.Next(i, list.Count)
            If i <> index Then
                ' swap list(i) and list(index)
                Dim temp As T = list(i)
                list(i) = list(index)
                list(index) = temp
            End If
        Next
    End Sub

End Module
