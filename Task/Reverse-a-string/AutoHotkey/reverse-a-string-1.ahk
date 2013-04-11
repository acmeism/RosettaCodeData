MsgBox % reverse("asdf")

reverse(string)
{
  Loop, Parse, string
    reversed := A_LoopField . reversed
  Return reversed
}
