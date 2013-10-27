ROT13(string) ; by Raccoon July-2009
{
  Static a := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
  Static b := "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM "
  s=
  Loop, Parse, string
  {
    c := substr(b,instr(a,A_LoopField,True),1)
    if (c != " ")
      s .= c
    else
      s .= A_LoopField
  }
  Return s
}
