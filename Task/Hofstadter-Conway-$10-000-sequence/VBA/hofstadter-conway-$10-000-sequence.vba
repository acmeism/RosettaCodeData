Public q() As Long
Sub make_q()
    ReDim q(2 ^ 20)
    q(1) = 1
    q(2) = 1
    Dim l As Long
    For l = 3 To 2 ^ 20
        q(l) = q(q(l - 1)) + q(l - q(l - 1))
    Next l
End Sub

Public Sub hcsequence()
    Dim mallows As Long: mallows = -1
    Dim max_n As Long, n As Long
    Dim l As Long, h As Long
    make_q
    For p = 0 To 19
        max_an = 0.5
        l = 2 ^ p: h = l * 2
        For n = l To h
            an = q(n) / n
            If an >= max_an Then
                max_an = an
                max_n = n
            End If
            If an > 0.55 Then
                mallows = n
            End If
        Next n
        Debug.Print "Maximum in range"; Format(l, "@@@@@@@"); " to"; h; String$(7 - Len(CStr(h)), " ");
        Debug.Print "occurs at"; Format(max_n, "@@@@@@@"); ": "; Format(max_an, "0.000000")
    Next p
    Debug.Print "Mallows number is"; mallows
End Sub
