Option Explicit

Sub Main_Conv_Temp()
Dim K As Single, Result As Single
    K = 21
    Debug.Print "Input in Kelvin      : " & Format(K, "0.00")
    Debug.Print "Output in Celsius    : " & IIf(ConvTemp(Result, K, "C"), Format(Result, "0.00"), False)
    Debug.Print "Output in Fahrenheit : " & IIf(ConvTemp(Result, K, "F"), Format(Result, "0.00"), False)
    Debug.Print "Output in Rankine    : " & IIf(ConvTemp(Result, K, "R"), Format(Result, "0.00"), False)
    Debug.Print "Output error         : " & IIf(ConvTemp(Result, K, "T"), Format(Result, "0.00"), False)
End Sub

Function ConvTemp(sngReturn As Single, Kelv As Single, InWhat As String) As Boolean
Dim ratio As Single

    ConvTemp = True
    ratio = 9 / 5
    Select Case UCase(InWhat)
        Case "C": sngReturn = Kelv - 273.15
        Case "F": sngReturn = (Kelv * ratio) - 459.67
        Case "R": sngReturn = Kelv * ratio
        Case Else: ConvTemp = False
    End Select
End Function
