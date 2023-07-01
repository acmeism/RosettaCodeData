Option Base 1
Private Function mean_angle(angles As Variant) As Double
    Dim sins() As Double, coss() As Double
    ReDim sins(UBound(angles))
    ReDim coss(UBound(angles))
    For i = LBound(angles) To UBound(angles)
        sins(i) = Sin(WorksheetFunction.Radians(angles(i)))
        coss(i) = Cos(WorksheetFunction.Radians(angles(i)))
    Next i
    mean_angle = WorksheetFunction.Degrees( _
        WorksheetFunction.Atan2( _
        WorksheetFunction.sum(coss), _
        WorksheetFunction.sum(sins)))
End Function
Public Sub main()
    Debug.Print Format(mean_angle([{350,10}]), "##0")
    Debug.Print Format(mean_angle([{90, 180, 270, 360}]), "##0")
    Debug.Print Format(mean_angle([{10, 20, 30}]), "##0")
End Sub
