Function Factors(x As Integer) As String
 Application.Volatile
 Dim i As Integer
 Dim cooresponding_factors As String
 Factors = 1
 corresponding_factors = x
 For i = 2 To Sqr(x)
  If x Mod i = 0 Then
   Factors = Factors & ", " & i
   If i <> x / i Then corresponding_factors = x / i & ", " & corresponding_factors
  End If
 Next i
 If x <> 1 Then Factors = Factors & ", " & corresponding_factors
End Function
