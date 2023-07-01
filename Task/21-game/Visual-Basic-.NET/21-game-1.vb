' Game 21 in VB.NET - an example for Rosetta Code

Class MainWindow
    Private Const GOAL As Integer = 21
    Private total As Integer = 0
    Private random As New Random

    Private Sub Update(box As TextBox, player As String, move As Integer)
        total = total + move
        box.Text = move
        boxTotal.Text = total
        If total + 1 > GOAL Then button1.IsEnabled = False
        If total + 2 > GOAL Then button2.IsEnabled = False
        If total + 3 > GOAL Then button3.IsEnabled = False
        If total = GOAL Then
            winner.Content = $"The winner is {player}."
        End If
    End Sub

    Private Sub Ai()
        Dim move As Integer = 1
        For i = 1 To 3
            If (total + i - 1) Mod 4 = 0 Then move = i
        Next i
        For i = 1 To 3
            If total + i = GOAL Then move = i
        Next i
        Update(boxAI, "AI", move)
    End Sub

    Private Sub Choice(sender As Object, e As RoutedEventArgs) _
            Handles button1.Click, button2.Click, button3.Click
        Update(boxHuman, "human", sender.Content)
        If total < GOAL Then Ai()
    End Sub

    ' StartGame method handles both OnLoad (WM_INIT?) event
    ' as well as the restart of the game after user press the 'restart' button.
    '
    Private Sub StartGame(sender As Object, e As RoutedEventArgs) Handles restart.Click

        total = 0

        boxAI.Text = ""
        boxHuman.Text = ""
        boxTotal.Text = ""
        'first.Content = "" ' It is not necessary, see below.
        winner.Content = ""

        button1.IsEnabled = True
        button2.IsEnabled = True
        button3.IsEnabled = True

        ' The random.Next(2) return pseudorandomly either 0 or 1. Generally
        ' random.Next(n) Return a value from 0 (inclusive) To n - 1 (inclusive).
        '
        If random.Next(2) = 0 Then
            first.Content = "First player is AI player."
            Ai()
        Else
            first.Content = "First player is human player."
        End If
    End Sub
End Class
