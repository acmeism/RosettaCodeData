Const MER = 6371         '-- mean earth radius(km)
Public DEG_TO_RAD As Double

Function haversine(lat1 As Double, long1 As Double, lat2 As Double, long2 As Double) As Double
    lat1 = lat1 * DEG_TO_RAD
    lat2 = lat2 * DEG_TO_RAD
    long1 = long1 * DEG_TO_RAD
    long2 = long2 * DEG_TO_RAD
    haversine = MER * WorksheetFunction.Acos(Sin(lat1) * Sin(lat2) + Cos(lat1) * Cos(lat2) * Cos(long2 - long1))
End Function

Public Sub main()
    DEG_TO_RAD = WorksheetFunction.Pi / 180
    d = haversine(36.12, -86.67, 33.94, -118.4)
    Debug.Print "Distance is "; Format(d, "#.######"); " km ("; Format(d / 1.609344, "#.######"); " miles)."
End Sub
