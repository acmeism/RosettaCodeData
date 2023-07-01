Public Sub mean_time()
    Dim angles() As Double
    s = [{"23:00:17","23:40:20","00:12:45","00:17:19"}]
    For i = 1 To UBound(s)
        s(i) = 360 * TimeValue(s(i))
    Next i
    Debug.Print Format(mean_angle(s) / 360 + 1, "hh:mm:ss")
End Sub
