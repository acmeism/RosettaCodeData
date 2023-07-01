Option Explicit

Sub Main_Dec2bin()
Dim Nb As Long
Nb = 5
    Debug.Print "The decimal value " & Nb & " should produce an output of : " & DecToBin(Nb)
    Debug.Print "The decimal value " & Nb & " should produce an output of : " & DecToBin2(Nb)
Nb = 50
    Debug.Print "The decimal value " & Nb & " should produce an output of : " & DecToBin(Nb)
    Debug.Print "The decimal value " & Nb & " should produce an output of : " & DecToBin2(Nb)
Nb = 9000
    Debug.Print "The decimal value " & Nb & " should produce an output of : " & DecToBin(Nb)
    Debug.Print "The decimal value " & Nb & " should produce an output of : " & DecToBin2(Nb)
End Sub

Function DecToBin(ByVal Number As Long) As String
Dim strTemp As String

    Do While Number > 1
        strTemp = Number - 2 * (Number \ 2) & strTemp
        Number = Number \ 2
    Loop
    DecToBin = Number & strTemp
End Function

Function DecToBin2(ByVal Number As Long, Optional Places As Long) As String
    If Number > 511 Then
        DecToBin2 = "Error : Number is too large ! (Number must be < 511)"
    ElseIf Number < -512 Then
        DecToBin2 = "Error : Number is too small ! (Number must be > -512)"
    Else
        If Places = 0 Then
            DecToBin2 = WorksheetFunction.Dec2Bin(Number)
        Else
            DecToBin2 = WorksheetFunction.Dec2Bin(Number, Places)
        End If
    End If
End Function
