Private Function kprime(ByVal n As Integer, k As Integer) As Boolean
    Dim p As Integer, factors As Integer
    p = 2
    factors = 0
    Do While factors < k And p * p <= n
        Do While n Mod p = 0
            n = n / p
            factors = factors + 1
        Loop
        p = p + 1
    Loop
    factors = factors - (n > 1) 'true=-1
    kprime = factors = k
End Function

Private Sub almost_primeC()
    Dim nextkprime As Integer, count As Integer
    Dim k As Integer
    For k = 1 To 5
        Debug.Print "k ="; k; ":";
        nextkprime = 2
        count = 0
        Do While count < 10
            If kprime(nextkprime, k) Then
                Debug.Print " "; Format(CStr(nextkprime), "@@@@@");
                count = count + 1
            End If
            nextkprime = nextkprime + 1
        Loop
        Debug.Print
    Next k
End Sub
