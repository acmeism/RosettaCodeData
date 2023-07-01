Friend Class Tile
    Public Sub New()
        Me.Value = 0
        Me.IsBlocked = False
    End Sub
    Public Property Value As Integer
    Public Property IsBlocked As Boolean
End Class

Friend Enum MoveDirection
     Up
     Down
     Left
     Right
End Enum

    Friend Class G2048
        Public Sub New()
            _isDone = False
            _isWon = False
            _isMoved = True
            _score = 0
            InitializeBoard()
        End Sub

        Private Sub InitializeBoard()
            For y As Integer = 0 To 3
                For x As Integer = 0 To 3
                    _board(x, y) = New Tile()
                Next
            Next
        End Sub

        Private _isDone As Boolean
        Private _isWon As Boolean
        Private _isMoved As Boolean
        Private _score As Integer
        Private ReadOnly _board As Tile(,) = New Tile(3, 3) {}
        Private ReadOnly _rand As Random = New Random()
        Const empty As String = " "

        Public Sub [Loop]()
            AddTile()
            While True
                If _isMoved Then AddTile()
                DrawBoard()
                If _isDone Then Exit While
                WaitKey()
            End While
            Dim endMessage As String = If(_isWon, "You've made it!", "Game Over!")
            Console.WriteLine(endMessage)
        End Sub

        Public Sub DrawBoard()
            Console.Clear()
            Console.WriteLine("Score: " & _score & vbNewLine)
            For y As Integer = 0 To 3
                Console.WriteLine("+------+------+------+------+")
                Console.Write("| ")
                For x As Integer = 0 To 3
                    If _board(x, y).Value = 0 Then
                        Console.Write(empty.PadRight(4))
                    Else
                        Console.Write(_board(x, y).Value.ToString().PadRight(4))
                    End If
                    Console.Write(" | ")
                Next
                Console.WriteLine()
            Next
            Console.WriteLine("+------+------+------+------+" & vbNewLine & vbNewLine)
        End Sub

        Private Sub WaitKey()
            _isMoved = False
            Console.WriteLine("(W) Up (S) Down (A) Left (D) Right")
            Dim input As Char
            Char.TryParse(Console.ReadKey().Key.ToString(), input)
            Select Case input
                Case "W"c
                    Move(MoveDirection.Up)
                Case "A"c
                    Move(MoveDirection.Left)
                Case "S"c
                    Move(MoveDirection.Down)
                Case "D"c
                    Move(MoveDirection.Right)
            End Select
            For y As Integer = 0 To 3
                For x As Integer = 0 To 3
                    _board(x, y).IsBlocked = False
                Next
            Next
        End Sub

        Private Sub AddTile()
            For y As Integer = 0 To 3
                For x As Integer = 0 To 3
                    If _board(x, y).Value <> 0 Then Continue For
                    Dim a As Integer, b As Integer
                    Do
                        a = _rand.Next(0, 4)
                        b = _rand.Next(0, 4)
                    Loop While _board(a, b).Value <> 0
                    Dim r As Double = _rand.NextDouble()
                    _board(a, b).Value = If(r > 0.89F, 4, 2)
                    If CanMove() Then Return
                Next
            Next
            _isDone = True
        End Sub

        Private Function CanMove() As Boolean
            For y As Integer = 0 To 3
                For x As Integer = 0 To 3
                    If _board(x, y).Value = 0 Then Return True
                Next
            Next
            For y As Integer = 0 To 3
                For x As Integer = 0 To 3
                    If TestAdd(x + 1, y, _board(x, y).Value) OrElse TestAdd(x - 1, y, _board(x, y).Value) OrElse TestAdd(x, y + 1, _board(x, y).Value) OrElse TestAdd(x, y - 1, _board(x, y).Value) Then Return True
                Next
            Next
            Return False
        End Function

        Private Function TestAdd(ByVal x As Integer, ByVal y As Integer, ByVal value As Integer) As Boolean
            If x < 0 OrElse x > 3 OrElse y < 0 OrElse y > 3 Then Return False
            Return _board(x, y).Value = value
        End Function

        Private Sub MoveVertically(ByVal x As Integer, ByVal y As Integer, ByVal d As Integer)
            If _board(x, y + d).Value <> 0 AndAlso _board(x, y + d).Value = _board(x, y).Value AndAlso Not _board(x, y).IsBlocked AndAlso Not _board(x, y + d).IsBlocked Then
                _board(x, y).Value = 0
                _board(x, y + d).Value *= 2
                _score += _board(x, y + d).Value
                _board(x, y + d).IsBlocked = True
                _isMoved = True
            ElseIf _board(x, y + d).Value = 0 AndAlso _board(x, y).Value <> 0 Then
                _board(x, y + d).Value = _board(x, y).Value
                _board(x, y).Value = 0
                _isMoved = True
            End If
            If d > 0 Then
                If y + d < 3 Then MoveVertically(x, y + d, 1)
            Else
                If y + d > 0 Then MoveVertically(x, y + d, -1)
            End If
        End Sub

        Private Sub MoveHorizontally(ByVal x As Integer, ByVal y As Integer, ByVal d As Integer)
            If _board(x + d, y).Value <> 0 AndAlso _board(x + d, y).Value = _board(x, y).Value AndAlso Not _board(x + d, y).IsBlocked AndAlso Not _board(x, y).IsBlocked Then
                _board(x, y).Value = 0
                _board(x + d, y).Value *= 2
                _score += _board(x + d, y).Value
                _board(x + d, y).IsBlocked = True
                _isMoved = True
            ElseIf _board(x + d, y).Value = 0 AndAlso _board(x, y).Value <> 0 Then
                _board(x + d, y).Value = _board(x, y).Value
                _board(x, y).Value = 0
                _isMoved = True
            End If
            If d > 0 Then
                If x + d < 3 Then MoveHorizontally(x + d, y, 1)
            Else
                If x + d > 0 Then MoveHorizontally(x + d, y, -1)
            End If
        End Sub

        Private Sub Move(ByVal direction As MoveDirection)
            Select Case direction
                Case MoveDirection.Up
                    For x As Integer = 0 To 3
                        Dim y As Integer = 1
                        While y < 4
                            If _board(x, y).Value <> 0 Then MoveVertically(x, y, -1)
                            y += 1
                        End While
                    Next
                Case MoveDirection.Down
                    For x As Integer = 0 To 3
                        Dim y As Integer = 2
                        While y >= 0
                            If _board(x, y).Value <> 0 Then MoveVertically(x, y, 1)
                            y -= 1
                        End While
                    Next
                Case MoveDirection.Left
                    For y As Integer = 0 To 3
                        Dim x As Integer = 1
                        While x < 4
                            If _board(x, y).Value <> 0 Then MoveHorizontally(x, y, -1)
                            x += 1
                        End While
                    Next
                Case MoveDirection.Right
                    For y As Integer = 0 To 3
                        Dim x As Integer = 2
                        While x >= 0
                            If _board(x, y).Value <> 0 Then MoveHorizontally(x, y, 1)
                            x -= 1
                        End While
                    Next
            End Select
        End Sub
    End Class

    Module Module1
        Sub Main()
            RunGame()
        End Sub

        Private Sub RunGame()
            Dim game As G2048 = New G2048()
            game.Loop()
            CheckRestart()
        End Sub

        Private Sub CheckRestart()
            Console.WriteLine("(N) New game (P) Exit")
            While True
                Dim input As Char
                Char.TryParse(Console.ReadKey().Key.ToString(), input)
                Select Case input
                    Case "N"c
                        RunGame()
                    Case "P"c
                        Return
                    Case Else
                        ClearLastLine()
                End Select
            End While
        End Sub

        Private Sub ClearLastLine()
            Console.SetCursorPosition(0, Console.CursorTop)
            Console.Write(New String(" ", Console.BufferWidth))
            Console.SetCursorPosition(0, Console.CursorTop - 1)
        End Sub
    End Module
