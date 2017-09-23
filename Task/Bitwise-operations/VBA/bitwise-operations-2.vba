Function MaskL(k As Integer) As Long
    If k < 1 Then
        MaskL = 0
    ElseIf k > 31 Then
        MaskL = -1
    Else
        MaskL = (-1) Xor (2 ^ (32 - k) - 1)
    End If
End Function
Function MaskR(k As Integer) As Long
    If k < 1 Then
        MaskR = 0
    ElseIf k > 31 Then
        MaskR = -1
    Else
        MaskR = 2 ^ k - 1
    End If
End Function
Function Bit(k As Integer) As Long
    If k < 0 Or k > 31 Then
        Bit = 0
    ElseIf k = 31 Then
        Bit = MaskL(1)
    Else
        Bit = 2 ^ k
    End If
End Function
Function ShiftL(n As Long, k As Integer) As Long
    If k = 0 Then
        ShiftL = n
    ElseIf k > 31 Then
        ShiftL = 0
    ElseIf k < 0 Then
        ShiftL = ShiftR(n, -k)
    Else
        ShiftL = (n And MaskR(31 - k)) * 2 ^ k
        If (n And Bit(31 - k)) <> 0 Then ShiftL = ShiftL Or MaskL(1)
    End If
End Function
Function ShiftR(n As Long, k As Integer) As Long
    If k = 0 Then
        ShiftR = n
    ElseIf k > 31 Then
        ShiftR = 0
    ElseIf k < 0 Then
        ShiftR = ShiftL(n, -k)
    Else
        ShiftR = (n And MaskR(31)) \ 2 ^ k
        If (n And MaskL(1)) <> 0 Then ShiftR = ShiftR Or Bit(31 - k)
    End If
End Function
Function RotateL(n As Long, k As Integer) As Long
    k = (32768 + k) Mod 32
    If k = 0 Then
        RotateL = n
    Else
        RotateL = ShiftL(n, k) Or ShiftR(n, 32 - k)
    End If
End Function
Function RotateR(n As Long, k As Integer) As Long
    k = (32768 + k) Mod 32
    If k = 0 Then
        RotateR = n
    Else
        RotateR = ShiftR(n, k) Or ShiftL(n, 32 - k)
    End If
End Function
Function ClearBit(n As Long, k As Integer) As Long
    ClearBit = n And Not Bit(k)
End Function
Function SetBit(n As Long, k As Integer) As Long
    SetBit = n Or Bit(k)
End Function
Function SwitchBit(n As Long, k As Integer) As Long
    SwitchBit = n Xor Bit(k)
End Function
Function TestBit(n As Long, k As Integer) As Boolean
    TestBit = (n And Bit(k)) <> 0
End Function
