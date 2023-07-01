Option Explicit

Sub Main_Bulls_and_cows()
Dim strNumber As String, strInput As String, strMsg As String, strTemp As String
Dim boolEnd As Boolean
Dim lngCpt As Long
Dim i As Byte, bytCow As Byte, bytBull As Byte
Const NUMBER_OF_DIGITS As Byte = 4
Const MAX_LOOPS As Byte = 25 'the max of lines supported by MsgBox

    strNumber = Create_Number(NUMBER_OF_DIGITS)
    Do
        bytBull = 0: bytCow = 0: lngCpt = lngCpt + 1
        If lngCpt > MAX_LOOPS Then strMsg = "Max of loops... Sorry you loose!": Exit Do
        strInput = AskToUser(NUMBER_OF_DIGITS)
        If strInput = "Exit Game" Then strMsg = "User abort": Exit Do
        For i = 1 To Len(strNumber)
            If Mid(strNumber, i, 1) = Mid(strInput, i, 1) Then
                bytBull = bytBull + 1
            ElseIf InStr(strNumber, Mid(strInput, i, 1)) > 0 Then
                bytCow = bytCow + 1
            End If
        Next i
        If bytBull = Len(strNumber) Then
            boolEnd = True: strMsg = "You win in " & lngCpt & " loops!"
        Else
            strTemp = strTemp & vbCrLf & "With : " & strInput & " ,you have : " & bytBull & " bulls," & bytCow & " cows."
            MsgBox strTemp
        End If
    Loop While Not boolEnd
    MsgBox strMsg
End Sub

Function Create_Number(NbDigits As Byte) As String
Dim myColl As New Collection
Dim strTemp As String
Dim bytAlea As Byte

    Randomize
    Do
        bytAlea = Int((Rnd * 9) + 1)
        On Error Resume Next
        myColl.Add CStr(bytAlea), CStr(bytAlea)
        If Err <> 0 Then
            On Error GoTo 0
        Else
            strTemp = strTemp & CStr(bytAlea)
        End If
    Loop While Len(strTemp) < NbDigits
    Create_Number = strTemp
End Function

Function AskToUser(NbDigits As Byte) As String
Dim boolGood As Boolean, strIn As String, i As Byte, NbDiff As Byte

    Do While Not boolGood
        strIn = InputBox("Enter your number (" & NbDigits & " digits)", "Number")
        If StrPtr(strIn) = 0 Then strIn = "Exit Game": Exit Do
        If strIn <> "" Then
            If Len(strIn) = NbDigits Then
                NbDiff = 0
                For i = 1 To Len(strIn)
                    If Len(Replace(strIn, Mid(strIn, i, 1), "")) < NbDigits - 1 Then
                        NbDiff = 1
                        Exit For
                    End If
                Next i
                If NbDiff = 0 Then boolGood = True
            End If
        End If
    Loop
    AskToUser = strIn
End Function
