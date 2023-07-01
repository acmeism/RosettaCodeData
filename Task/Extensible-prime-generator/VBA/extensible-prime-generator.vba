Option Explicit

Sub Main()
Dim Primes() As Long, n As Long, temp$
Dim t As Single
    t = Timer

    n = 133218295 'limit for an Array of Longs with VBA on my computer
    Primes = ListPrimes(n)
    Debug.Print "For N = " & Format(n, "#,##0") & ", execution time : " & _
        Format(Timer - t, "0.000 s") & ", " & _
        Format(UBound(Primes) + 1, "#,##0") & " primes numbers."

    'First twenty primes
    For n = 0 To 19
        temp = temp & ", " & Primes(n)
    Next
    Debug.Print "First twenty primes : "; Mid(temp, 3)
    'Primes between 100 and 150
    n = 0: temp = vbNullString
    Do While Primes(n) < 100
        n = n + 1
    Loop
    Do While Primes(n) < 150
        temp = temp & ", " & Primes(n)
        n = n + 1
    Loop
    Debug.Print "Primes between 100 and 150 : " & Mid(temp, 3)
    'Number of primes between 7,700 and 8,000
    Dim ccount As Long
    n = 0
    Do While Primes(n) < 7700
        n = n + 1
    Loop
    Do While Primes(n) < 8000
        ccount = ccount + 1
        n = n + 1
    Loop
    Debug.Print "Number of primes between 7,700 and 8,000 : " & ccount
    'The 10 x Xth prime
    n = 1
    Do While n <= 100000
        n = n * 10
        Debug.Print "The " & n & "th prime: "; Format(Primes(n - 1), "#,##0")
    Loop
    Debug.Print "VBA has a limit in array's dim"
    Debug.Print "With my computer, the limit for an array of Long is : 133 218 295"
    Debug.Print "The last prime I could find is the : " & _
        Format(UBound(Primes), "#,##0") & "th, Value : " & _
        Format(Primes(UBound(Primes)), "#,##0")
End Sub

Function ListPrimes(MAX As Long) As Long()
Dim t() As Boolean, L() As Long, c As Long, s As Long, i As Long, j As Long
    ReDim t(2 To MAX)
    ReDim L(MAX \ 2)
    s = Sqr(MAX)
    For i = 3 To s Step 2
        If t(i) = False Then
            For j = i * i To MAX Step i
                t(j) = True
            Next
        End If
    Next i
    L(0) = 2
    For i = 3 To MAX Step 2
        If t(i) = False Then
            c = c + 1
            L(c) = i
        End If
    Next i
    ReDim Preserve L(c)
    ListPrimes = L
End Function
