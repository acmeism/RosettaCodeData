Option Base 1
Private Function power_set(ByRef st As Collection) As Collection
    Dim subset As Collection, pwset As New Collection
    For i = 0 To 2 ^ st.Count - 1
        Set subset = New Collection
        For j = 1 To st.Count
            If i And 2 ^ (j - 1) Then subset.Add st(j)
        Next j
        pwset.Add subset
    Next i
    Set power_set = pwset
End Function
Private Function print_set(ByRef st As Collection) As String
    'assume st is a collection of collections, holding integer variables
    Dim s() As String, t() As String
    ReDim s(st.Count)
    'Debug.Print "{";
    For i = 1 To st.Count
        If st(i).Count > 0 Then
            ReDim t(st(i).Count)
            For j = 1 To st(i).Count
                Select Case TypeName(st(i)(j))
                    Case "Integer": t(j) = CStr(st(i)(j))
                    Case "Collection": t(j) = "{}" 'assumes empty
                End Select
            Next j
            s(i) = "{" & Join(t, ", ") & "}"
        Else
            s(i) = "{}"
        End If
    Next i
    print_set = "{" & Join(s, ", ") & "}"
End Function
Public Sub rc()
    Dim rcset As New Collection, result As Collection
    For i = 1 To 4
        rcset.Add i
    Next i
    Debug.Print print_set(power_set(rcset))
    Set rcset = New Collection
    Debug.Print print_set(power_set(rcset))
    Dim emptyset As New Collection
    rcset.Add emptyset
    Debug.Print print_set(power_set(rcset))
    Debug.Print
End Sub
