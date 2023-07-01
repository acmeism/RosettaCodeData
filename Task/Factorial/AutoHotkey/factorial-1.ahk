MsgBox % factorial(4)

factorial(n)
{
  result := 1
  Loop, % n
    result *= A_Index
  Return result
}
