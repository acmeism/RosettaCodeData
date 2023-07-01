foo()
If ErrorLevel
  Msgbox calling foo failed with:  %ErrorLevel%

foo()
{
  If success
    Return
  Else
    ErrorLevel = foo_error
  Return
}
