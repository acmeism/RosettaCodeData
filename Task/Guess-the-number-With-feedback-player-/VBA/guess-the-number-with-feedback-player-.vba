Sub GuessNumberPlayer()
Dim iGuess As Integer, iLow As Integer, iHigh As Integer, iCount As Integer
Dim vSolved As Variant
On Error GoTo ErrHandler
MsgBox "Pick a number between 1 and 100. I will guess it!", vbInformation + vbOKOnly, "Rosetta Code | Guess the Number Player"
iCount = 0
iLow = 1
iHigh = 100
Do While Not vSolved = "Y"
    iGuess = Application.WorksheetFunction.RandBetween(iLow, iHigh)
    iCount = iCount + 1
CheckGuess:
    vSolved = InputBox("My guess: " & iGuess & vbCr & vbCr & "Y = Yes, correct guess" & vbCr & _
        "H = your number is higher" & vbCr & "L = your number is lower" & vbCr & "X = exit game", "Rosetta Code | Guess the Number Player | Guess " & iCount)
    Select Case vSolved
        Case "Y", "y":              GoTo CorrectGuess
        Case "X", "x":              Exit Sub
        Case "H", "h":              iLow = iGuess + 1
        Case "L", "l":              iHigh = iGuess - 1
        Case Else:                  GoTo CheckGuess
    End Select
Loop
CorrectGuess:
    MsgBox "I guessed number " & iGuess & " in just " & iCount & " attempts!", vbExclamation + vbOKOnly, "Rosetta Code | Guess the Number Player"
    Exit Sub
ErrHandler:
    MsgBox "Not possible. Were you cheating?!", vbCritical + vbOKOnly, "Rosetta Code | Guess the Number Player | ERROR!"
End Sub
