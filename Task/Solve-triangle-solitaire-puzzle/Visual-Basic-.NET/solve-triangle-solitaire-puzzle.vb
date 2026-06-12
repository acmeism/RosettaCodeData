Imports System, Microsoft.VisualBasic.DateAndTime

Public Module Module1
    Const n As Integer = 5 ' extent of board
    Dim Board As String ' the peg board
    Dim Starting As Integer = 1 ' position on board where first peg has been removed
    Dim Target As Integer = 13 ' final peg position, use 0 to solve for any postion
    Dim Moves As Integer() ' possible offset moves on grid
    Dim bi() As Integer ' string position to peg location index
    Dim ib() As Integer ' string position to peg location reverse index
    Dim nl As Char = Convert.ToChar(10) ' newline character

    ' expands each line of the board properly
    Public Function Dou(s As String) As String
        Dou = "" : Dim b As Boolean = True
        For Each ch As Char In s
            If b Then b = ch <> " "
            If b Then Dou &= ch & " " Else Dou = " " & Dou
        Next : Dou = Dou.TrimEnd()
    End Function

    ' formats the string representaion of a board into a viewable item
    Public Function Fmt(s As String) As String
        If s.Length < Board.Length Then Return s
        Fmt = "" : For i As Integer = 1 To n : Fmt &= Dou(s.Substring(i * n - n, n)) &
                If(i = n, s.Substring(Board.Length), "") & nl
        Next
    End Function

    ' returns triangular number of n
    Public Function Triangle(n As Integer) As Integer
        Return (n * (n + 1)) / 2
    End Function

    ' returns an initialized board with one peg missing
    Public Function Init(s As String, pos As Integer) As String
        Init = s : Mid(Init, pos, 1) = "0"
    End Function

    ' initializes string-to-board position indices			
    Public Sub InitIndex()
        ReDim bi(Triangle(n)), ib(n * n) : Dim j As Integer = 0
        For i As Integer = 0 To ib.Length - 1
            If i = 0 Then
                ib(i) = 0 : bi(j) = 0 : j += 1
            Else
                If Board(i - 1) = "1" Then ib(i) = j : bi(j) = i : j += 1
            End If
        Next
    End Sub

    ' brute-force solver, returns either the steps of a solution, or the string "fail"
    Public Function solve(brd As String, pegsLeft As Integer) As String
        If pegsLeft = 1 Then ' down to the last one, see if it's the correct one
            If Target = 0 Then Return "Completed" ' don't care where the last one is
            If brd(bi(Target) - 1) = "1" Then Return "Completed" Else Return "fail"
        End If
        For i = 1 To Board.Length ' for each possible position...
            If brd(i - 1) = "1" Then ' that still has a peg...
                For Each mj In Moves ' for each possible move
                    Dim over As Integer = i + mj ' the position to jump over
                    Dim land As Integer = i + 2 * mj ' the landing spot
                    ' ensure landing spot is on the board, then check for a valid pattern
                    If land >= 1 AndAlso land <= brd.Length _
                                AndAlso brd(land - 1) = "0" _
                                AndAlso brd(over - 1) = "1" Then
                        setPegs(brd, "001", i, over, land) ' make a move
                        ' recursively send it out to test
                        Dim Res As String = solve(brd.Substring(0, Board.Length), pegsLeft - 1)
                        ' check result, returing if OK
                        If Res.Length <> 4 Then _
                            Return brd & info(i, over, land) & nl & Res
                        setPegs(brd, "110", i, over, land) ' not OK, so undo the move
                    End If
                Next
            End If
        Next
        Return "fail"
    End Function

    ' returns a text representation of peg movement for each turn
    Function info(frm As Integer, over As Integer, dest As Integer) As String
        Return "  Peg from " & ib(frm).ToString() & " goes to " & ib(dest).ToString() &
            ", removing peg at " & ib(over).ToString()
    End Function

    ' sets three pegs as once, used for making and un-doing moves
    Sub setPegs(ByRef board As String, pat As String, a As Integer, b As Integer, c As Integer)
        Mid(board, a, 1) = pat(0) : Mid(board, b, 1) = pat(1) : Mid(board, c, 1) = pat(2)
    End Sub

    ' limit an integer to a range
    Sub LimitIt(ByRef x As Integer, lo As Integer, hi As Integer)
        x = Math.Max(Math.Min(x, hi), lo)
    End Sub

    Public Sub Main()
        Dim t As Integer = Triangle(n) ' use the nth triangular number for bounds
        LimitIt(Starting, 1, t) ' ensure valid parameters for staring and ending positions
        LimitIt(Target, 0, t)
        Dim stime As Date = Now() ' keep track of start time for performance result
        Moves = {-n - 1, -n, -1, 1, n, n + 1} ' possible offset moves on a nxn grid
        Board = New String("1", n * n) ' init string representation of board
        For i As Integer = 0 To n - 2 ' and declare non-existent spots
            Mid(Board, i * (n + 1) + 2, n - 1 - i) = New String(" ", n - 1 - i)
        Next
        InitIndex() ' create indicies from board's pattern
        Dim B As String = Init(Board, bi(Starting)) ' remove first peg
        Console.WriteLine(Fmt(B & "  Starting with peg removed from " & Starting.ToString()))
        Dim res As String() = solve(B.Substring(0, B.Length), t - 1).Split(nl)
        Dim ts As String = (Now() - stime).TotalMilliseconds.ToString() & " ms."
        If res(0).Length = 4 Then
            If Target = 0 Then
                Console.WriteLine("Unable to find a solution with last peg left anywhere.")
            Else
                Console.WriteLine("Unable to find a solution with last peg left at " &
                                  Target.ToString() & ".")
            End If
            Console.WriteLine("Computation time: " & ts)
        Else
            For Each Sol As String In res : Console.WriteLine(Fmt(Sol)) : Next
            Console.WriteLine("Computation time to first found solution: " & ts)
        End If
        If Diagnostics.Debugger.IsAttached Then Console.ReadLine()
    End Sub
End Module
