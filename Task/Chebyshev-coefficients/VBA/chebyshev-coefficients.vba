' Chebyshev coefficients

Sub Main()
  Const N As Byte = 10
  Dim A, B, W, BPlADiv2, BMiADiv2 As Double
  Dim I As Byte
  A = 0
  B = 1
  Dim Cheby(N - 1) As Double, Coef(N - 1) As Double
  PiDivN = WorksheetFunction.Pi() / N
  BPlADiv2 = (B + A) / 2
  BMiADiv2 = (B - A) / 2
  For I = 0 To N - 1
    Coef(I) = Cos(Cos(PiDivN * (I + 0.5)) * BMiADiv2 + BPlADiv2)
  Next I
  For I = 0 To N - 1
    W = 0
    For J = 0 To N - 1
      W = W + Coef(J) * Cos(PiDivN * I * (J + 0.5))
    Next J
    Cheby(I) = W * 2 / N
    Debug.Print I; ": "; FormatNumber(Cheby(I), 12)
  Next I
End Sub
