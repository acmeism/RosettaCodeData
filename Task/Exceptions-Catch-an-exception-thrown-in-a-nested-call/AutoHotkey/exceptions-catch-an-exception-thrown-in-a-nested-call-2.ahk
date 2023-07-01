foo()
Return

foo()
{
  bar(0)
  If InStr(ErrorLevel, "U0")
    MsgBox caught error: U0
  bar(1)
  If InStr(ErrorLevel, "U0")
    MsgBox caught error: U0
}

bar(i)
{
  StringReplace, ErrorLevel, ErrorLevel, baz_error, , All   ; clear baz_error(s)
  If !baz(i)
    ErrorLevel .= "baz_error"  ; add baz_error to errorstack
}

baz(i)
{
  StringReplace, ErrorLevel, ErrorLevel, U1, , All   ; clear U1 errors
  StringReplace, ErrorLevel, ErrorLevel, U0, , All   ; clear U0 errors
  If i
    ErrorLevel .= "U1"  ; add U1 errors to errorstack
  Else
    ErrorLevel .= "U0"
  Return 1
}
