MsgBox % factorial(4)

factorial(n)
{
  return n > 1 ? n-- * factorial(n) : 1
}
