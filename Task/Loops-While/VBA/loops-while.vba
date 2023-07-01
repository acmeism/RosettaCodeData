Public Sub LoopsWhile()
    Dim value As Integer
    value = 1024
    Do While value > 0
        Debug.Print value
        value = value / 2
    Loop
End Sub
