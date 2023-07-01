Rot13(string) {
  Output := ""
  Loop, Parse, string
  {
    a := ~Asc(A_LoopField)
    Output .= Chr(~a-1//(~(a|32)//13*2-11)*13)
  }
  return Output
}
