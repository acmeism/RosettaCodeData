Sub Baggage_Problem()
Dim i As Long

    'We can start at the square root of 269696
    i = 520
    '269696 is a multiple of 4, 520 too
    'so we can increment i by 4
    Do While ((i * i) Mod 1000000) <> 269696
        i = i + 4 'Increment by 4
    Loop
    Debug.Print "The smallest positive integer whose square ends in the digits 269 696 is : " & i & vbCrLf & _
    "Its square is : " & i * i
End Sub
