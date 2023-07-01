Public Sub LoopDoWhile()
    Dim value As Integer
    value = 0
    Do
        value = value + 1
        Debug.Print value;
    Loop While value Mod 6 <> 0
End Sub
