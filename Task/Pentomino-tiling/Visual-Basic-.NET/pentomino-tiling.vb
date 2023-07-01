Module Module1

    Dim symbols As Char() = "XYPFTVNLUZWI█".ToCharArray(),
        nRows As Integer = 8, nCols As Integer = 8,
        target As Integer = 12, blank As Integer = 12,
        grid As Integer()() = New Integer(nRows - 1)() {},
        placed As Boolean() = New Boolean(target - 1) {},
        pens As List(Of List(Of Integer())), rand As Random,
        seeds As Integer() = {291, 292, 293, 295, 297, 329, 330, 332, 333, 335, 378, 586}

    Sub Main()
        Unpack(seeds) : rand = New Random() : ShuffleShapes(2)
        For r As Integer = 0 To nRows - 1
            grid(r) = Enumerable.Repeat(-1, nCols).ToArray() : Next
        For i As Integer = 0 To 3
            Dim rRow, rCol As Integer : Do : rRow = rand.Next(nRows) : rCol = rand.Next(nCols)
            Loop While grid(rRow)(rCol) = blank : grid(rRow)(rCol) = blank
        Next
        If Solve(0, 0) Then
            PrintResult()
        Else
            Console.WriteLine("no solution for this configuration:") : PrintResult()
        End If
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub

    Sub ShuffleShapes(count As Integer) ' changes order of the pieces for a more random solution
        For i As Integer = 0 To count : For j = 0 To pens.Count - 1
                Dim r As Integer : Do : r = rand.Next(pens.Count) : Loop Until r <> j
                Dim tmp As List(Of Integer()) = pens(r) : pens(r) = pens(j) : pens(j) = tmp
                Dim ch As Char = symbols(r) : symbols(r) = symbols(j) : symbols(j) = ch
            Next : Next
    End Sub

    Sub PrintResult() ' display results
        For Each r As Integer() In grid : For Each i As Integer In r
                Console.Write("{0} ", If(i < 0, ".", symbols(i)))
            Next : Console.WriteLine() : Next
    End Sub

    ' returns first found solution only
    Function Solve(ByVal pos As Integer, ByVal numPlaced As Integer) As Boolean
        If numPlaced = target Then Return True
        Dim row As Integer = pos \ nCols, col As Integer = pos Mod nCols
        If grid(row)(col) <> -1 Then Return Solve(pos + 1, numPlaced)
        For i As Integer = 0 To pens.Count - 1 : If Not placed(i) Then
                For Each orientation As Integer() In pens(i)
                    If Not TPO(orientation, row, col, i) Then Continue For
                    placed(i) = True : If Solve(pos + 1, numPlaced + 1) Then Return True
                    RmvO(orientation, row, col) : placed(i) = False
                Next : End If : Next : Return False
    End Function

    ' removes a placed orientation
    Sub RmvO(ByVal ori As Integer(), ByVal row As Integer, ByVal col As Integer)
        grid(row)(col) = -1 : For i As Integer = 0 To ori.Length - 1 Step 2
            grid(row + ori(i))(col + ori(i + 1)) = -1 : Next
    End Sub

    ' checks an orientation, if possible it is placed, else returns false
    Function TPO(ByVal ori As Integer(), ByVal row As Integer, ByVal col As Integer,
                 ByVal sIdx As Integer) As Boolean
        For i As Integer = 0 To ori.Length - 1 Step 2
            Dim x As Integer = col + ori(i + 1), y As Integer = row + ori(i)
            If x < 0 OrElse x >= nCols OrElse y < 0 OrElse y >= nRows OrElse
                grid(y)(x) <> -1 Then Return False
        Next : grid(row)(col) = sIdx
        For i As Integer = 0 To ori.Length - 1 Step 2
            grid(row + ori(i))(col + ori(i + 1)) = sIdx
        Next : Return True
    End Function

    '!' the following routines expand the seed values into the 63 orientation arrays.
    '   source code space savings comparison:
    '      around 2000 chars for the expansion code, verses about 3000 chars for the integer array defs.
    '   perhaps not worth the savings?

    Sub Unpack(sv As Integer()) ' unpacks a list of seed values into a set of 63 rotated pentominoes
        pens = New List(Of List(Of Integer())) : For Each item In sv
            Dim Gen As New List(Of Integer()), exi As List(Of Integer) = Expand(item),
                fx As Integer() = ToP(exi) : Gen.Add(fx) : For i As Integer = 1 To 7
                If i = 4 Then Mir(exi) Else Rot(exi)
                fx = ToP(exi) : If Not Gen.Exists(Function(Red) TheSame(Red, fx)) Then Gen.Add(ToP(exi))
            Next : pens.Add(Gen) : Next
    End Sub

    ' expands an integer into a set of directions
    Function Expand(i As Integer) As List(Of Integer)
        Expand = {0}.ToList() : For j As Integer = 0 To 3 : Expand.Insert(1, i And 15) : i >>= 4 : Next
    End Function

    ' converts a set of directions to an array of y, x pairs
    Function ToP(p As List(Of Integer)) As Integer()
        Dim tmp As List(Of Integer) = {0}.ToList() : For Each item As Integer In p.Skip(1)
            tmp.Add(tmp.Item(item >> 2) + {1, 8, -1, -8}(item And 3)) : Next
        tmp.Sort() : For i As Integer = tmp.Count - 1 To 0 Step -1 : tmp.Item(i) -= tmp.Item(0) : Next
        Dim res As New List(Of Integer) : For Each item In tmp.Skip(1)
            Dim adj = If((item And 7) > 4, 8, 0)
            res.Add((adj + item) \ 8) : res.Add((item And 7) - adj)
        Next : Return res.ToArray()
    End Function

    ' compares integer arrays for equivalency
    Function TheSame(a As Integer(), b As Integer()) As Boolean
        For i As Integer = 0 To a.Count - 1 : If a(i) <> b(i) Then Return False
        Next : Return True
    End Function

    Sub Rot(ByRef p As List(Of Integer)) ' rotates a set of directions by 90 degrees
        For i As Integer = 0 To p.Count - 1 : p(i) = (p(i) And -4) Or ((p(i) + 1) And 3) : Next
    End Sub

    Sub Mir(ByRef p As List(Of Integer)) ' mirrors a set of directions
        For i As Integer = 0 To p.Count - 1 : p(i) = (p(i) And -4) Or (((p(i) Xor 1) + 1) And 3) : Next
    End Sub

End Module
