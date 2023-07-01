Public Class Board
    Inherits System.Windows.Forms.Form

    Const XbyX = 4
    Const XSize = 60

    Private Empty As New Panel
    Private Tiles As New List(Of Tile)
    Private Moves As Integer

    Public Sub New()
        Me.Text = XbyX ^ 2 - 1 & " Puzzle Game"
        Me.ClientSize = New Size(XbyX * XSize, XbyX * XSize)
        Me.FormBorderStyle = FormBorderStyle.FixedToolWindow
        Restart()
    End Sub

    Public Sub Restart()
        Dim Start As List(Of Integer) = MakeCompleteable(GetRandamStartOrder())

        Empty.SetBounds(((XbyX ^ 2 - 1) Mod XbyX) * XSize, ((XbyX ^ 2 - 1) \ XbyX) * XSize, XSize, XSize)

        Me.Moves = 0
        Me.Tiles.Clear()
        Me.Controls.Clear()
        For No = 0 To XbyX ^ 2 - 2
            Dim Tile As New Tile
            Tile.Text = Start(No)
            Tile.Board = Me
            Tile.SetBounds((No Mod XbyX) * XSize, (No \ XbyX) * XSize, XSize, XSize)
            Me.Tiles.Add(Tile)
            Me.Controls.Add(Tile)
        Next

    End Sub

    Public Sub IsComplete()
        Me.Moves += 1
        If Empty.Left = ((XbyX ^ 2 - 1) Mod XbyX) * XSize AndAlso Empty.Top = ((XbyX ^ 2 - 1) \ XbyX) * XSize Then
            Me.Tiles.Sort()
            For x = 1 To XbyX ^ 2 - 1
                If Not Tiles(x - 1).Text = x Then
                    Exit Sub
                End If
            Next
            MsgBox($"Completed in {Me.Moves} Moves!", MsgBoxStyle.Information, "Winner")
            Restart()
        End If
    End Sub

    Public Class Tile
        Inherits Button
        Implements IComparable(Of Tile)
        Public Board As Board
        Private Sub Tile_Click(sender As Object, e As EventArgs) Handles Me.Click
            With Board.Empty
                If Me.Left = .Left AndAlso (Me.Top + Me.Height = .Top OrElse .Top + .Height = Me.Top) Then
                    Swap()
                ElseIf Me.Top = .Top AndAlso (Me.Left + Me.Width = .Left OrElse .Left + .Width = Me.Left) Then
                    Swap()
                End If
            End With
        End Sub
        Private Sub Swap()
            Dim p = Board.Empty.Location
            Board.Empty.Location = Me.Location
            Me.Location = p
            Board.IsComplete()
        End Sub
        Public Function CompareTo(other As Tile) As Integer Implements IComparable(Of Tile).CompareTo
            Dim Result = Me.Top.CompareTo(other.Top)
            If Result = 0 Then
                Return Me.Left.CompareTo(other.Left)
            End If
            Return Result
        End Function
    End Class

    Public Function GetRandamStartOrder() As List(Of Integer)
        Dim List As New List(Of Integer)
        Dim Random As New Random()
        Do While List.Count < XbyX ^ 2 - 1
            Dim Value As Integer = Random.Next(1, XbyX ^ 2)
            If Not List.Contains(Value) Then
                List.Add(Value)
            End If
        Loop
        Return List
    End Function

    Public Function MakeCompleteable(List As List(Of Integer)) As List(Of Integer)
        'ToDo
        Return List
    End Function

End Class
