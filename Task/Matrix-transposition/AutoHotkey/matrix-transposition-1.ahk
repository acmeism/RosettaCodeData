a = a
m = 10
n = 10
Loop, 10
{
  i := A_Index - 1
  Loop, 10
  {
    j := A_Index - 1
    %a%%i%%j% := i - j
  }
}
before := matrix_print("a", m, n)
transpose("a", m, n)
after := matrix_print("a", m, n)
MsgBox % before . "`ntransposed:`n" . after
Return

transpose(a, m, n)
{
  Local i, j, row, matrix
  Loop, % m
  {
    i := A_Index - 1
    Loop, % n
    {
      j := A_Index - 1
      temp%i%%j% := %a%%j%%i%
    }
  }
  Loop, % m
  {
    i := A_Index - 1
    Loop, % n
    {
      j := A_Index - 1
      %a%%i%%j% := temp%i%%j%
    }
  }
}

matrix_print(a, m, n)
{
  Local i, j, row, matrix
  Loop, % m
  {
    i := A_Index - 1
    row := ""
    Loop, % n
    {
      j := A_Index - 1
      row .= %a%%i%%j% . ","
    }
    StringTrimRight, row, row, 1
    matrix .= row . "`n"
  }
  Return matrix
}
