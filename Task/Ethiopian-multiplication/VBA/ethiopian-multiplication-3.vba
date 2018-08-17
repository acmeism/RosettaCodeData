Private Function Ethiopian_Multiplication(First As Long, Second As Long) As Long
    Do
        If Not IsEven(First) Then Mult_Eth = Mult_Eth + Second
        First = lngHalve(First)
        Second = lngDouble(Second)
    Loop While First >= 1
    Ethiopian_Multiplication = Mult_Eth
End Function
