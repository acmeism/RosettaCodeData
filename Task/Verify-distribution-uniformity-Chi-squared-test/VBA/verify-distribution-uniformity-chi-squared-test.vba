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
    Debug.Print "   Chi-squared test for given frequencies"
    Debug.Print "X-squared ="; ChiSquared; ", ";
    Debug.Print "df ="; DegreesOfFreedom; ", ";
    Debug.Print "p-value = "; Format(p_value, "0.0000")
    Test4DiscreteUniformDistribution = p_value > Significance
End Function
Public Sub test()
    Dim O() As Variant
    O = [{199809,200665,199607,200270,199649}]
    Debug.Print "[1] ""Uniform? "; Test4DiscreteUniformDistribution(O, 0.05); """"
    O = [{522573,244456,139979,71531,21461}]
    Debug.Print "[1] ""Uniform? "; Test4DiscreteUniformDistribution(O, 0.05); """"
End Sub
