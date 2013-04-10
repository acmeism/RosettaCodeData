While StrLen(Code) < 4 {
  Random, num, 1, 9
  If !InStr(Code, num)
    Code .= num
}
Gui, Add, Edit, vGuess, Enter a guess...
Gui, Add, Button, wp Default, Submit
Gui, Add, ListBox, ym r8 vHistory
Gui, Show
Return

ButtonSubmit:
  Gui, Submit, NoHide
  If StrLen(Guess) != 4
    Return
  If Guess is not digit
    Return
  bulls:=0, cows:=0
  Loop, 4
    If (SubStr(Guess, A_Index, 1) = SubStr(Code, A_Index, 1))
      bulls++
    Else If InStr(Code, SubStr(Guess, A_Index, 1))
      cows++
  GuiControl,, History, % Guess ": " bulls " Bulls " cows " Cows"
Return

GuiClose:
  ExitApp
