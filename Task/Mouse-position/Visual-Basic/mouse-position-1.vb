Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    'X and Y are in "twips" -- 15 twips per pixel
    Me.Print "X:" & X
    Me.Print "Y:" & Y
End Sub
