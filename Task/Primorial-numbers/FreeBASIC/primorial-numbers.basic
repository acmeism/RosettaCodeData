' version 22-09-2015
' compile with: fbc -s console

Const As UInteger Base_ = 1000000000
ReDim Shared As UInteger primes()

Sub sieve(need As UInteger)

    ' estimate is to high, but ensures that we have enough primes
    Dim As UInteger max = need * (Log(need) + Log(Log(need)))
    Dim As UInteger t = 1 ,x , x2
    Dim As Byte p(max)

    ReDim primes (need + need \ 3) ' we trim the array later
    primes(0) = 1                  ' by definition
    primes(1) = 2                  ' first prime, the only even prime

    ' only consider the odd number
    For x = 3 To Sqr(max) Step 2
        If p(x) = 0 Then
            For x2 = x * x To max Step x * 2
                p(x2) = 1
            Next
        End If
    Next

    ' move found primes to array
    For x = 3 To max Step 2
        If p(x) = 0 Then
            t += 1
            primes(t) = x
        EndIf
    Next
    'ReDim Preserve primes(t)
    ReDim Preserve primes(need)

End Sub

' ------=< MAIN >=------

Dim As UInteger n, i, pow, primorial
Dim As String str_out, buffer = Space(10)

Dim As UInteger max = 100000 ' maximum number of primes we need

sieve(max)

primorial = 1
Print

For n = 0 To 9
    primorial = primorial * primes(n)
    Print Using " primorial(#) ="; n;
    RSet buffer, Str(primorial)
    str_out = buffer
    Print str_out
Next

' could use GMP, but why not make are own big integer routine
Dim As UInteger bigint(max), first = max, last = max
Dim As UInteger l, p, carry, low = 9, high = 10
Dim As ULongInt result
Dim As UInteger Ptr big_i

' start at the back, number grows to the left like normal number
bigint(last) = primorial
Print

For pow = 0 To Len(Str(max)) -2
    If pow > 0 Then
        low = high
        high = high * 10
    End If
    For n = low + 1 To high
        carry = 0
        big_i = @bigint(last)
        For i = last To first Step -1
            result = CULngInt(primes(n)) * *big_i + carry
            carry = result \ Base_
            *big_i = result - carry * Base_
            big_i = big_i -1
        Next i
        If carry <> 0 Then
            first = first -1
            *big_i = carry
        End If
    Next n
    l = Len(Str(bigint(first))) + (last - first) * 9
    Print " primorial("; high; ") has "; l ;" digits"
Next pow


' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
