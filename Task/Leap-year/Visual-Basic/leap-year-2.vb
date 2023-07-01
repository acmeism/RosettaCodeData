Sub Main()
'testing the above functions
Dim i As Integer
  For i = 1750 To 2150
    Debug.Assert IsLeapYear1(i) Eqv IsLeapYear2(i)
  Next i
End Sub
