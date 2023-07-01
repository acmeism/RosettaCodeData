Public x As TinyInt

Private Sub Form_Click()
    '0-11, to give chance of errors; also not integers, because VB massages data to fit, if possible.
    x = Rnd * 12
    Me.Print x
End Sub

Private Sub Form_Load()
    Randomize Timer
    Set x = New TinyInt '"Set = New" REQUIRED
End Sub
