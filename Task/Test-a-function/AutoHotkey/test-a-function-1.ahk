; assert.ahk
;; assert(a, b, test=2)
assert(a, b="blank", test=0)
{
  if (b = "blank")
{
    if !a
      msgbox % "blank value"
      return 0
}
    if equal_list(a, b, "`n")
      return 0
    else
    msgbox % test . ":`n" . a . "`nexpected:`n" . b
}

!r::reload

;; equal_list(a, b, delimiter)
equal_list(a, b, delimiter)
{
  loop, parse, b, %delimiter%
  {
    if instr(a, A_LoopField)
      continue
    else
      return 0
  }
  loop, parse, a, %delimiter%
  {
    if instr(b, A_LoopField)
      continue
    else
      return 0
  }

  return 1
}
