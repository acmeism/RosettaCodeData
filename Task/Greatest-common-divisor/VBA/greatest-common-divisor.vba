Public Function GCD(a As Long, b As Long) As Long
While a <> b
  If a > b Then a = a - b Else b = b - a
Wend
GCD = a
End Function
