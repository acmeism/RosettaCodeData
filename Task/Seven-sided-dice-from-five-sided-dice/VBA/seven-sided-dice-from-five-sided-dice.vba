Private Function Test4DiscreteUniformDistribution(ObservationFrequencies() As Variant, Significance As Single) As Boolean
    'Returns true if the observed frequencies pass the Pearson Chi-squared test at the required significance level.
    Dim Total As Long, Ei As Long, i As Integer
    Dim ChiSquared As Double, DegreesOfFreedom As Integer, p_value As Double
    Debug.Print "[1] ""Data set:"" ";
    For i = LBound(ObservationFrequencies) To UBound(ObservationFrequencies)
        Total = Total + ObservationFrequencies(i)
        Debug.Print ObservationFrequencies(i); " ";
    Next i
    DegreesOfFreedom = UBound(ObservationFrequencies) - LBound(ObservationFrequencies)
    'This is exactly the number of different categories minus 1
    Ei = Total / (DegreesOfFreedom + 1)
    For i = LBound(ObservationFrequencies) To UBound(ObservationFrequencies)
        ChiSquared = ChiSquared + (ObservationFrequencies(i) - Ei) ^ 2 / Ei
    Next i
    p_value = 1 - WorksheetFunction.ChiSq_Dist(ChiSquared, DegreesOfFreedom, True)
    Debug.Print
    Debug.Print "Chi-squared test for given frequencies"
    Debug.Print "X-squared ="; Format(ChiSquared, "0.0000"); ", ";
    Debug.Print "df ="; DegreesOfFreedom; ", ";
    Debug.Print "p-value = "; Format(p_value, "0.0000")
    Test4DiscreteUniformDistribution = p_value > Significance
End Function
Private Function Dice5() As Integer
    Dice5 = Int(5 * Rnd + 1)
End Function
Private Function Dice7() As Integer
    Dim i As Integer
    Do
        i = 5 * (Dice5 - 1) + Dice5
    Loop While i > 21
    Dice7 = i Mod 7 + 1
End Function
Sub TestDice7()
    Dim i As Long, roll As Integer
    Dim Bins(1 To 7) As Variant
    For i = 1 To 1000000
        roll = Dice7
        Bins(roll) = Bins(roll) + 1
    Next i
    Debug.Print "[1] ""Uniform? "; Test4DiscreteUniformDistribution(Bins, 0.05); """"
End Sub
