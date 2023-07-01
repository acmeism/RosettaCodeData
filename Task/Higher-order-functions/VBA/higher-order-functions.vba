Sub HigherOrder()
    Dim result As Single
    result = first("second")
    MsgBox result
End Sub
Function first(f As String) As Single
    first = Application.Run(f, 1) + 2
End Function
Function second(x As Single) As Single
    second = x / 2
End Function
