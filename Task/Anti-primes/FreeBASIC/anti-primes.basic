' convertido desde Ada
Declare Function count_divisors(n As Integer) As Integer

Dim As Integer max_divisors, divisors, results(1 To 20), candidate, j
candidate = 1

Function count_divisors(n As Integer) As Integer
    Dim As Integer i, count = 1
    For i = 1 To n/2
        If (n Mod i) = 0 Then count += 1
    Next i
    count_divisors = count
End Function

Print "Los primeros 20 anti-primos son:"
For j = 1 To 20
    Do
        divisors = count_divisors(Candidate)
        If max_divisors < divisors Then
            Results(j) = Candidate
            max_divisors = divisors
            Exit Do
        End If
        Candidate += 1
    Loop
Next j
For j = 1 To 20
    Print Results(j);
Next j
Print
Sleep
