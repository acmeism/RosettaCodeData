Public Sub box_the_compass()
    Dim compass_point As Integer
    Dim compass_points_all As New Collection
    Dim test_points_all As New Collection
    Dim compass_points(8) As Variant
    Dim test_points(3) As Variant
    compass_points(1) = [{ "North",        "North by east",        "North-northeast",      "Northeast by north"}]
    compass_points(2) = [{ "Northeast",    "Northeast by east",    "East-northeast",       "East by north"}]
    compass_points(3) = [{ "East",         "East by south",        "East-southeast",       "Southeast by east"}]
    compass_points(4) = [{ "Southeast",    "Southeast by south",   "South-southeast",      "South by east"}]
    compass_points(5) = [{ "South",        "South by west",        "South-southwest",      "Southwest by south"}]
    compass_points(6) = [{ "Southwest",    "Southwest by west",    "West-southwest",       "West by south"}]
    compass_points(7) = [{ "West",         "West by north",        "West-northwest",       "Northwest by west"}]
    compass_points(8) = [{ "Northwest",    "Northwest by north",   "North-northwest",      "North by west"}]
    test_points(1) = [{ 0.0,  16.87,  16.88,  33.75,  50.62,  50.63,  67.5,   84.37,  84.38, 101.25, 118.12}]
    test_points(2) = [{ 118.13, 135.0,  151.87, 151.88, 168.75, 185.62, 185.63, 202.5,  219.37, 219.38, 236.25}]
    test_points(3) = [{ 253.12, 253.13, 270.0,  286.87, 286.88, 303.75, 320.62, 320.63, 337.5,  354.37, 354.38}]
    For i = 1 To 3
        For Each t In test_points(i)
            test_points_all.Add t
        Next t
    Next i
    For i = 1 To 8
        For Each c In compass_points(i)
            compass_points_all.Add c
        Next c
    Next i
    For i = 1 To test_points_all.Count
        compass_point = (WorksheetFunction.Floor(test_points_all(i) * 32 / 360 + 0.5, 1) Mod 32) + 1
        Debug.Print Format(compass_point, "@@"); "  "; compass_points_all(compass_point);
        Debug.Print String$(20 - Len(compass_points_all(compass_point)), " ");
        Debug.Print test_points_all(i)
    Next i
End Sub
