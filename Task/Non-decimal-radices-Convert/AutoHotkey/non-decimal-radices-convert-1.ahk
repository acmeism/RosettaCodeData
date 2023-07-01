MsgBox % number2base(200, 16) ; 12
MsgBox % parse(200, 16)  ; 512

number2base(number, base)
{
  While, base < digit := floor(number / base)
  {
    result := mod(number, base) . result
    number := digit
  }
  result := digit . result
  Return result
}

parse(number, base)
{
  result = 0
  pos := StrLen(number) - 1
  Loop, Parse, number
  {
    result := ((base ** pos) * A_LoopField) + result
    base -= 1
  }
  Return result
}
