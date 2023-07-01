Public Sub test()
    Dim t(2) As Variant
    t(0) = [{1,2}]
    t(1) = [{3,4,1}]
    t(2) = 5
    p = [{"Payload#0","Payload#1","Payload#2","Payload#3","Payload#4","Payload#5","Payload#6"}]
    Dim q(6) As Boolean
    For i = LBound(t) To UBound(t)
        If IsArray(t(i)) Then
            For j = LBound(t(i)) To UBound(t(i))
                q(t(i)(j)) = True
                t(i)(j) = p(t(i)(j) + 1)
            Next j
        Else
            q(t(i)) = True
            t(i) = p(t(i) + 1)
        End If
    Next i
    For i = LBound(t) To UBound(t)
        If IsArray(t(i)) Then
            Debug.Print Join(t(i), ", ")
        Else
            Debug.Print t(i)
        End If
    Next i
    For i = LBound(q) To UBound(q)
        If Not q(i) Then Debug.Print p(i + 1); " is not used"
    Next i
End Sub
