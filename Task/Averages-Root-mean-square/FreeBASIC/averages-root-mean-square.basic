' FB 1.05.0 Win64

Function QuadraticMean(array() As Double) As Double
  Dim length As Integer = Ubound(array) - Lbound(array) + 1
  Dim As Double sum = 0.0
  For i As Integer = LBound(array) To UBound(array)
    sum += array(i) * array(i)
  Next
  Return Sqr(sum/length)
End Function

Dim vector(1 To 10) As Double
For i As Integer = 1 To 10
  vector(i) = i
Next

Print "Quadratic mean (or RMS) is :"; QuadraticMean(vector())
Print
Print "Press any key to quit the program"
Sleep
