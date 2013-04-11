MsgBox % factor(8388607)  ; 47 * 178481

factor(n)
{
  If (n = 1)
    Return
  f = 2
  While (f <= n)
  {
    If (Mod(n, f) = 0)
    {
      next := factor(n / f)
      factors = %f%`n%next%
      Return factors
    }
    f++
  }
}
