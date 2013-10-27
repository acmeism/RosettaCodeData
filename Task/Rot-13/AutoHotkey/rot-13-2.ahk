ROT13(string) ; by Raccoon July-2009
{
  s=
  Loop, Parse, string
  {
    c := asc(A_LoopField)
    if (c >= 97) && (c <= 109) || (c >= 65) && (c <= 77)
      c += 13
    else if (c >= 110) && (c <= 122) || (c >= 78) && (c <= 90)
      c -= 13
    s .= chr(c)
  }
  Return s
}
