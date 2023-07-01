Loop, 5
  MsgBox % fib(A_Index)
Return

fib(n)
{
  If (n < 2)
    Return n
  i := last := this := 1
  While (i <= n)
  {
    new := last + this
    last := this
    this := new
    i++
  }
  Return this
}
