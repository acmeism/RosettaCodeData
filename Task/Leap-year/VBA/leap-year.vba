Public Function Leap_year(year As Integer) As Boolean
    Leap_year = (Month(DateSerial(year, 2, 29)) = 2)
End Function
