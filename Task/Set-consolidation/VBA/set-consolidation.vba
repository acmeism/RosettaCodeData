Private Function has_intersection(set1 As Collection, set2 As Collection) As Boolean
    For Each element In set1
        On Error Resume Next
        tmp = set2(element)
        If tmp = element Then
            has_intersection = True
            Exit Function
        End If
    Next element
End Function
Private Sub union(set1 As Collection, set2 As Collection)
    For Each element In set2
        On Error Resume Next
        tmp = set1(element)
        If tmp <> element Then
            set1.Add element, element
        End If
    Next element
End Sub
Private Function consolidate(sets As Collection) As Collection
    For i = sets.Count To 1 Step -1
        For j = sets.Count To i + 1 Step -1
            If has_intersection(sets(i), sets(j)) Then
                union sets(i), sets(j)
                sets.Remove j
            End If
        Next j
    Next i
    Set consolidate = sets
End Function
Private Function mc(s As Variant) As Collection
    Dim res As New Collection
    For i = 1 To Len(s)
        res.Add Mid(s, i, 1), Mid(s, i, 1)
    Next i
    Set mc = res
End Function
Private Function ms(t As Variant) As Collection
    Dim res As New Collection
    Dim element As Collection
    For i = LBound(t) To UBound(t)
        Set element = t(i)
        res.Add t(i)
    Next i
    Set ms = res
End Function
Private Sub show(x As Collection)
    Dim t() As String
    Dim u() As String
    ReDim t(1 To x.Count)
    For i = 1 To x.Count
        ReDim u(1 To x(i).Count)
        For j = 1 To x(i).Count
            u(j) = x(i)(j)
        Next j
        t(i) = "{" & Join(u, ", ") & "}"
    Next i
    Debug.Print "{" & Join(t, ", ") & "}"
End Sub
Public Sub main()
    show consolidate(ms(Array(mc("AB"), mc("CD"))))
    show consolidate(ms(Array(mc("AB"), mc("BD"))))
    show consolidate(ms(Array(mc("AB"), mc("CD"), mc("DB"))))
    show consolidate(ms(Array(mc("HIK"), mc("AB"), mc("CD"), mc("DB"), mc("FGH"))))
End Sub
