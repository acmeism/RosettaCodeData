Public Sub trig()
    Pi = WorksheetFunction.Pi()
    Debug.Print Sin(Pi / 2)
    Debug.Print Sin(90 * Pi / 180)
    Debug.Print Cos(0)
    Debug.Print Cos(0 * Pi / 180)
    Debug.Print Tan(Pi / 4)
    Debug.Print Tan(45 * Pi / 180)
    Debug.Print WorksheetFunction.Asin(1) * 2
    Debug.Print WorksheetFunction.Asin(1) * 180 / Pi
    Debug.Print WorksheetFunction.Acos(0) * 2
    Debug.Print WorksheetFunction.Acos(0) * 180 / Pi
    Debug.Print Atn(1) * 4
    Debug.Print Atn(1) * 180 / Pi
End Sub
