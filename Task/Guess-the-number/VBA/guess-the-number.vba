Sub GuessTheNumber()
Dim NbComputer As Integer, NbPlayer As Integer
    Randomize Timer
    NbComputer = Int((Rnd * 10) + 1)
    Do
        NbPlayer = Application.InputBox("Choose a number between 1 and 10 : ", "Enter your guess", Type:=1)
    Loop While NbComputer <> NbPlayer
    MsgBox "Well guessed!"
End Sub
