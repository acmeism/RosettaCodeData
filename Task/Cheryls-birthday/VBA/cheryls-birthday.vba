Private Sub exclude_unique_days(w As Collection)
    Dim number_of_dates(31) As Integer
    Dim months_to_exclude As New Collection
    For Each v In w
        number_of_dates(v(1)) = number_of_dates(v(1)) + 1
    Next v
    For i = w.Count To 1 Step -1
        If number_of_dates(w(i)(1)) = 1 Then
            months_to_exclude.Add w(i)(0)
            w.Remove i
        End If
    Next i
    For Each m In months_to_exclude
        exclude_month w, m
    Next m
End Sub
Private Sub exclude_month(x As Collection, v As Variant)
    For i = x.Count To 1 Step -1
        If x(i)(0) = v Then x.Remove i
    Next i
End Sub
Private Sub exclude_non_unique_days(w As Collection)
    Dim number_of_dates(31) As Integer
    For Each v In w
        number_of_dates(v(1)) = number_of_dates(v(1)) + 1
    Next v
    For i = w.Count To 1 Step -1
        If number_of_dates(w(i)(1)) > 1 Then
            w.Remove i
        End If
    Next i
End Sub
Private Sub exclude_non_unique_months(w As Collection)
    Dim months As New Collection
    For Each v In w
        On Error GoTo 1
        months.Add v(0), v(0)
    Next v
1:
    For i = w.Count To 1 Step -1
        If w(i)(0) = v(0) Then
            w.Remove i
        End If
    Next i
End Sub
Public Sub cherylsbirthday()
    Dim v As New Collection
    s = "May 15, May 16, May 19, June 17, June 18, July 14, July 16, August 14, August 15, August 17"
    t = Split(s, ",")
    For Each u In t
        v.Add Split(Trim(u), " ")
    Next u
    '1) Albert: I don't know when Cheryl's birthday is, but I know that Bernard does not know too.
    exclude_unique_days v
    '2) Bernard: At first I don't know when Cheryl's birthday is, but I know now.
    exclude_non_unique_days v
    '3) Albert: Then I also know when Cheryl's birthday is.
    exclude_non_unique_months v
    Debug.Print v(1)(0); " "; v(1)(1)
End Sub
