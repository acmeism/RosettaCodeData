Function PrimeFactors(n)
    arrP = Split(ListPrimes(n)," ")
    divnum = n
    Do Until divnum = 1
        'The -1 is to account for the null element of arrP
        For i = 0 To UBound(arrP)-1
            If divnum = 1 Then
                Exit For
            ElseIf divnum Mod arrP(i) = 0 Then
                divnum = divnum/arrP(i)
                PrimeFactors = PrimeFactors & arrP(i) & " "
            End If
        Next
    Loop
End Function

Function IsPrime(n)
    If n = 2 Then
        IsPrime = True
    ElseIf n <= 1 Or n Mod 2 = 0 Then
        IsPrime = False
    Else
        IsPrime = True
        For i = 3 To Int(Sqr(n)) Step 2
            If n Mod i = 0 Then
                IsPrime = False
                Exit For
            End If
        Next
    End If
End Function

Function ListPrimes(n)
    ListPrimes = ""
    For i = 1 To n
        If IsPrime(i) Then
            ListPrimes = ListPrimes & i & " "
        End If
    Next
End Function

WScript.StdOut.Write PrimeFactors(CInt(WScript.Arguments(0)))
WScript.StdOut.WriteLine
