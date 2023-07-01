Public Sub Proper_Divisor()
Dim t() As Long, i As Long, l As Long, j As Long, c As Long
    For i = 1 To 10
        Debug.Print "Proper divisor of " & i & " : " & Join(S(i), ", ")
    Next
    For i = 2 To 20000
        l = UBound(S(i)) + 1
        If l > c Then c = l: j = i
    Next
    Debug.Print "Number in the range 1 to 20,000 with the most proper divisors is : " & j
    Debug.Print j & " count " & c & " proper divisors"
End Sub

Private Function S(n As Long) As String()
'returns the proper divisors of n
Dim j As Long, t() As String, c As Long
    't = list of proper divisor of n
    If n > 1 Then
        For j = 1 To n \ 2
            If n Mod j = 0 Then
                ReDim Preserve t(c)
                t(c) = j
                c = c + 1
            End If
        Next
    End If
    S = t
End Function
