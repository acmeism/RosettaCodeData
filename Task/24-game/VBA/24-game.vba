Sub Rosetta_24game()

Dim Digit(4) As Integer, i As Integer, iDigitCount As Integer
Dim stUserExpression As String
Dim stFailMessage As String, stFailDigits As String
Dim bValidExpression As Boolean, bValidDigits As Boolean, bValidChars As Boolean
Dim vResult As Variant, vTryAgain As Variant, vSameDigits As Variant

' Generate 4 random digits
GenerateNewDigits:
    For i = 1 To 4
        Digit(i) = [randbetween(1,9)]
    Next i

' Get user expression
GetUserExpression:
    bValidExpression = True
    stFailMessage = ""
    stFailDigits = ""
    stUserExpression = InputBox("Enter a mathematical expression which results in 24, using the following digits: " & _
        Digit(1) & ", " & Digit(2) & ", " & Digit(3) & " and " & Digit(4), "Rosetta Code | 24 Game")

' Check each digit is included in user expression
    bValidDigits = True
    stFailDigits = ""
    For i = 1 To 4
        If InStr(stUserExpression, Digit(i)) = 0 Then
            bValidDigits = False
            stFailDigits = stFailDigits & " " & Digit(i)
        End If
    Next i
    If bValidDigits = False Then
        bValidExpression = False
        stFailMessage = "Your expression excluded the following required digits: " & stFailDigits & vbCr & vbCr
    End If

' Check each character of user expression is a valid character type
    bValidDigits = True
    stFailDigits = ""
    For i = 1 To Len(stUserExpression)
        If InStr("0123456789+-*/()", Mid(stUserExpression, i, 1)) = 0 Then
            bValidDigits = False
            stFailDigits = stFailDigits & " " & Mid(stUserExpression, i, 1)
        End If
    Next i
    If bValidDigits = False Then
        bValidExpression = False
        stFailMessage = stFailMessage & "Your expression contained invalid characters:" & stFailDigits & vbCr & vbCr
    End If

' Check no disallowed integers entered
    bValidDigits = True
    stFailDigits = ""
    iDigitCount = 0
    For i = 1 To Len(stUserExpression)
        If Not InStr("0123456789", Mid(stUserExpression, i, 1)) = 0 Then
            iDigitCount = iDigitCount + 1
            If IsError(Application.Match(--(Mid(stUserExpression, i, 1)), Digit, False)) Then
                bValidDigits = False
                stFailDigits = stFailDigits & " " & Mid(stUserExpression, i, 1)
            End If
        End If
    Next i
    If iDigitCount > 4 Then
        bValidExpression = False
        stFailMessage = stFailMessage & "Your expression contained more than 4 digits" & vbCr & vbCr
    End If
        If iDigitCount < 4 Then
        bValidExpression = False
        stFailMessage = stFailMessage & "Your expression contained less than 4 digits" & vbCr & vbCr
    End If
    If bValidDigits = False Then
        bValidExpression = False
        stFailMessage = stFailMessage & "Your expression contained invalid digits:" & stFailDigits & vbCr & vbCr
    End If

' Check no double digit numbers entered
    bValidDigits = True
    stFailDigits = ""
    For i = 11 To 99
        If Not InStr(stUserExpression, i) = 0 Then
            bValidDigits = False
            stFailDigits = stFailDigits & " " & i
        End If
    Next i
    If bValidDigits = False Then
        bValidExpression = False
        stFailMessage = stFailMessage & "Your expression contained invalid numbers:" & stFailDigits & vbCr & vbCr
    End If

' Check result of user expression
    On Error GoTo EvalFail
    vResult = Evaluate(stUserExpression)
    If Not vResult = 24 Then
        bValidExpression = False
        stFailMessage = stFailMessage & "Your expression did not result in 24. It returned: " & vResult
    End If

' Return results
    If bValidExpression = False Then
        vTryAgain = MsgBox(stFailMessage & vbCr & vbCr & "Would you like to try again?", vbCritical + vbRetryCancel, "Rosetta Code | 24 Game | FAILED")
            If vTryAgain = vbRetry Then
                vSameDigits = MsgBox("Do you want to use the same numbers?", vbQuestion + vbYesNo, "Rosetta Code | 24 Game | RETRY")
                If vSameDigits = vbYes Then
                    GoTo GetUserExpression
                Else
                    GoTo GenerateNewDigits
                End If
            End If
    Else
        vTryAgain = MsgBox("You entered: " & stUserExpression & vbCr & vbCr & "which resulted in: " & vResult, _
            vbInformation + vbRetryCancel, "Rosetta Code | 24 Game | SUCCESS")
        If vTryAgain = vbRetry Then
            GoTo GenerateNewDigits
        End If
    End If
    Exit Sub
EvalFail:
    bValidExpression = False
    vResult = Err.Description
    Resume
End Sub
