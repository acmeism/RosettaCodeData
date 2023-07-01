Private Function tx(a As Variant) As String
    Dim s As String
    s = CStr(Format(a, "0.######"))
    If Right(s, 1) = "," Then
        s = Mid(s, 1, Len(s) - 1) & "       "
    Else
        i = InStr(1, s, ",")
        s = s & String$(6 - Len(s) + i, " ")
    End If
    tx = s
End Function
Private Sub test(b1 As Variant, b2 As Variant)
    Dim diff As Variant
    diff = (b2 - b1) - ((b2 - b1) \ 360) * 360
    diff = diff - IIf(diff > 180, 360, 0)
    diff = diff + IIf(diff < -180, 360, 0)
    Debug.Print Format(tx(b1), "@@@@@@@@@@@@@@@@"); Format(tx(b2), "@@@@@@@@@@@@@@@@@"); Format(tx(diff), "@@@@@@@@@@@@@@@@@")
End Sub
Public Sub angle_difference()
    Debug.Print "       b1               b2             diff"
    Debug.Print "---------------- ---------------- ----------------"
    test 20, 45
    test -45, 45
    test -85, 90
    test -95, 90
    test -45, 125
    test -45, 145
    test 29.4803, -88.6381
    test -78.3251, -159.036
    test -70099.7423381094, 29840.6743787672
    test -165313.666629736, 33693.9894517456
    test 1174.83805105985, -154146.664901248
    test 60175.7730679555, 42213.0719235437
End Sub
