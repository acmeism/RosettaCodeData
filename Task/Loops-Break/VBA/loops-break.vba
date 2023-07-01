Public Sub LoopsBreak()
    Dim value As Integer
    Randomize
    Do While True
        value = Int(20 * Rnd)
        Debug.Print value
        If value = 10 Then Exit Do
        Debug.Print Int(20 * Rnd)
    Loop
End Sub
