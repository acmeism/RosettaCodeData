Dim max,min,secretnum,numtries,usernum
max=100
min=1
numtries=0
Randomize
secretnum = Int((max-min+1)*Rnd+min)

Do While usernum <> secretnum
  usernum = Inputbox("Guess the secret number beween 1-100","Guessing Game")
  If IsEmpty(usernum) Then
    WScript.Quit
  End If
  If IsNumeric(usernum) Then
    numtries = numtries + 1
    usernum = Cint(usernum)
    If usernum < secretnum Then
      Msgbox("The secret number is higher than " + CStr(usernum))
    ElseIf usernum > secretnum Then
      Msgbox("The secret number is lower than " + CStr(usernum))
    Else
      Msgbox("Congratulations, you found the secret number in " + CStr(numtries) + " guesses!")
    End If
  Else
    Msgbox("Please enter a valid number.")
  End If
Loop
