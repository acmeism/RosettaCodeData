main()
Return

F(n)
{
  If (n == 0)
    Return 1
  Else
    Return n - M(F(n-1))
}

M(n)
{
  If (n == 0)
    Return 0
  Else
    Return n - F(M(n-1)) ;
}

main()
{
  i = 0
  While, i < 20
  {
    male .= M(i) . "`n"
    female .= F(i) . "`n"
    i++
  }
  MsgBox % "male:`n" . male
  MsgBox % "female:`n" . female
}
