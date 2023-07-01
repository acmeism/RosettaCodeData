Private Function compound_duration(ByVal seconds As Long) As String
    minutes = 60
    hours = 60 * minutes
    days_ = 24 * hours
    weeks = 7 * days_
    Dim out As String
    w = seconds \ weeks
    seconds = seconds - w * weeks
    d = seconds \ days_
    seconds = seconds - d * days_
    h = seconds \ hours
    seconds = seconds - h * hours
    m = seconds \ minutes
    s = seconds Mod minutes
    out = IIf(w > 0, w & " wk, ", "") & _
        IIf(d > 0, d & " d, ", "") & _
        IIf(h > 0, h & " hr, ", "") & _
        IIf(m > 0, m & " min, ", "") & _
        IIf(s > 0, s & " sec", "")
    If Right(out, 2) = ", " Then
        compound_duration = Left(out, Len(out) - 2)
    Else
        compound_duration = out
    End If
End Function

Public Sub cstcd()
    Debug.Print compound_duration(7259)
    Debug.Print compound_duration(86400)
    Debug.Print compound_duration(6000000)
End Sub
