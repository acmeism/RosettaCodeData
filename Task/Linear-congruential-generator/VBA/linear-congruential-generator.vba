Public stateBSD As Variant
Public stateMS As Variant
Private Function bsd() As Long
    Dim temp As Variant
    temp = CDec(1103515245 * stateBSD + 12345)
    temp2 = temp / 2 ^ 31
    temp3 = CDec(WorksheetFunction.Floor_Precise(temp2))
    stateBSD = temp - (2 ^ 31) * temp3
    bsd = stateBSD
End Function
Private Function ms() As Integer
    Dim temp As Variant
    temp = CDec(214013 * stateMS + 2531011)
    temp2 = temp / 2 ^ 31
    temp3 = CDec(WorksheetFunction.Floor_Precise(temp2))
    stateMS = temp - (2 ^ 31) * temp3
    ms = stateMS \ 2 ^ 16
End Function
Public Sub main()
    stateBSD = CDec(0)
    stateMS = CDec(0)
    Debug.Print "       BSD", "   MS"
    For i = 1 To 10
        Debug.Print Format(bsd, "@@@@@@@@@@"), Format(ms, "@@@@@")
    Next i
End Sub
