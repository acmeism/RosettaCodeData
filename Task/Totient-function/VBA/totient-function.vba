Private Function totient(ByVal n As Long) As Long
    Dim tot As Long: tot = n
    Dim i As Long: i = 2
    Do While i * i <= n
        If n Mod i = 0 Then
            Do While True
                n = n \ i
                If n Mod i <> 0 Then Exit Do
            Loop
            tot = tot - tot \ i
        End If
        i = i + IIf(i = 2, 1, 2)
    Loop
    If n > 1 Then
        tot = tot - tot \ n
    End If
    totient = tot
End Function

Public Sub main()
    Debug.Print " n  phi   prime"
    Debug.Print " --------------"
    Dim count As Long
    Dim tot As Integer, n As Long
    For n = 1 To 25
        tot = totient(n)
        prime = (n - 1 = tot)
        count = count - prime
        Debug.Print Format(n, "@@"); Format(tot, "@@@@@"); Format(prime, "@@@@@@@@")
    Next n
    Debug.Print
    Debug.Print "Number of primes up to 25     = "; Format(count, "@@@@")
    For n = 26 To 100000
        count = count - (totient(n) = n - 1)
        Select Case n
            Case 100, 1000, 10000, 100000
                Debug.Print "Number of primes up to"; n; String$(6 - Len(CStr(n)), " "); "="; Format(count, "@@@@@")
            Case Else
        End Select
    Next n
End Sub
