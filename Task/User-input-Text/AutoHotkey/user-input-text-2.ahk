TrayTip, Input:, Type a string:
Input(String)
TrayTip, Input:, Type an int:
Input(Int)
TrayTip, Done!, Input was recieved.
Msgbox, You entered "%String%" and "%Int%"
ExitApp
Return

Input(ByRef Output)
{
  Loop
  {
    Input, Char, L1, {Enter}{Space}
    If ErrorLevel contains Enter
      Break
    Else If ErrorLevel contains Space
      Output .= " "
    Else
      Output .= Char
    TrayTip, Input:, %Output%
  }
}
