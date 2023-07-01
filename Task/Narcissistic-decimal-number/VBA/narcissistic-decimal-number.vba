Private Function narcissistic(n As Long) As Boolean
    Dim d As String: d = CStr(n)
    Dim l As Integer: l = Len(d)
    Dim sumn As Long: sumn = 0
    For i = 1 To l
        sumn = sumn + (Mid(d, i, 1) - "0") ^ l
    Next i
    narcissistic = sumn = n
End Function

Public Sub main()
    Dim s(24) As String
    Dim n As Long: n = 0
    Dim found As Integer: found = 0
    Do While found < 25
        If narcissistic(n) Then
            s(found) = CStr(n)
            found = found + 1
        End If
        n = n + 1
    Loop
    Debug.Print Join(s, ", ")
End Sub
