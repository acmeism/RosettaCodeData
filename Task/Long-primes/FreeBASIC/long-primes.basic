' version 01-02-2019
' compile with: fbc -s console

Dim Shared As UByte prime()

Sub find_primes(n As UInteger)

    ReDim prime(n)
    Dim As UInteger i, k

    ' need only to consider odd primes, 2 has no repetion
    For i = 3 To n Step 2
        If prime(i) = 0 Then
            For k = i * i To n Step i + i
                prime(k) = 1
            Next
        End If
    Next

End Sub

Function find_period(p As UInteger) As UInteger
    ' finds period for every positive number
    Dim As UInteger period, r = 1

    Do
        r = (r * 10) Mod p
        period += 1
        If r <= 1 Then Return period
    Loop

End Function

' ------=< MAIN >=------

#Define max 64000
Dim As UInteger p = 3, n1 = 3, n2 = 500, i, n50, count

find_primes(max)
Print "Long primes upto 500 are ";

For i = n1 To n2 Step 2
    If prime(i) = 0 Then
        If i -1 = find_period(i) Then
            If n50 <= 50 Then
                Print Str(i); " ";
            End If
            count += 1
        End If
    End If
Next

Print : Print

Do
    Print "There are "; Str(count); " long primes upto "; Str(n2)

    n1 = n2 +1
    n2 += n2
    If n1 > max Then Exit Do

    For i = n1 To n2 Step 2
        If prime(i) = 0 Then
            If i -1 = find_period(i) Then
                count += 1
            End If
        End If
    Next
Loop

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
