Option Explicit

Sub Multiplication_Tables()
Dim strTemp As String, strBuff As String
Dim i&, j&, NbDigits As Byte

'You can adapt the following const :
Const NB_END As Byte = 12

    Select Case NB_END
        Case Is < 10: NbDigits = 3
        Case 10 To 31: NbDigits = 4
        Case 31 To 100: NbDigits = 5
        Case Else: MsgBox "Number too large": Exit Sub
    End Select
    strBuff = String(NbDigits, " ")

    For i = 1 To NB_END
        strTemp = Right(strBuff & i, NbDigits)
        For j = 2 To NB_END
            If j < i Then
                strTemp = strTemp & strBuff
            Else
                strTemp = strTemp & Right(strBuff & j * i, NbDigits)
            End If
        Next j
        Debug.Print strTemp
    Next i
End Sub
