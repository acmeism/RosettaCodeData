Public Function Horner(x, ParamArray coeff())
Dim result As Double
Dim ncoeff As Integer

result = 0
ncoeff = UBound(coeff())

For i = ncoeff To 0 Step -1
  result = (result * x) + coeff(i)
Next i
Horner = result
End Function
