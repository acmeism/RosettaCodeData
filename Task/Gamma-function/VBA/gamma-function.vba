' Gamma function

Sub MainGamma()
  Dim X As Double
  For X = 0.1 To 2.05 Step 0.1
    Debug.Print X, FNGamma(X)
  Next X
End Sub

Function FNGamma(Z As Double) As Double
  FNGamma = Exp(FNLnGamma(Z))
End Function

Function FNLnGamma(ByVal Z As Double) As Double
  Dim LZ(6) As Double
  LZ(0) = 1.00000000019001
  LZ(1) = 76.1800917294715
  LZ(2) = -86.5053203294168
  LZ(3) = 24.0140982408309
  LZ(4) = -1.23173957245015
  LZ(5) = 1.2086509738662E-03
  LZ(6) = -0.000005395239385
  Pi = WorksheetFunction.Pi()
  If Z < 0.5 Then
    FNLnGamma = Log(Pi / Sin(Pi * Z)) - FNLnGamma(1# - Z)
  Else
    Z = Z - 1#
    B = Z + 5.5
    A = LZ(0)
    For I = 1 To 6
      A = A + LZ(I) / (Z + I)
    Next I
    FNLnGamma = (Log(Sqr(2 * Pi)) + Log(A) - B) + Log(B) * (Z + 0.5)
  End If
End Function
