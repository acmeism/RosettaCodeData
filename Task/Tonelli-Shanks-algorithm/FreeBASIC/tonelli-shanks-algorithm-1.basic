' version 11-04-2017
' compile with: fbc -s console
' maximum for p is 17 digits to be on the save side

' TRUE/FALSE are built-in constants since FreeBASIC 1.04
' But we have to define them for older versions.
#Ifndef TRUE
    #Define FALSE 0
    #Define TRUE Not FALSE
#EndIf

Function mul_mod(a As ULongInt, b As ULongInt, modulus As ULongInt) As ULongInt
    ' returns a * b mod modulus
    Dim As ULongInt x, y = a Mod modulus

    While b > 0
        If (b And 1) = 1 Then
            x = (x + y) Mod modulus
        End If
        y = (y Shl 1) Mod modulus
        b = b Shr 1
    Wend

    Return x

End Function

Function pow_mod(b As ULongInt, power As ULongInt, modulus As ULongInt) As ULongInt
    ' returns b ^ power mod modulus
    Dim As ULongInt x = 1

    While power > 0
        If (power And 1) = 1 Then
            ' x = (x * b) Mod modulus
            x = mul_mod(x, b, modulus)
        End If
        ' b = (b * b) Mod modulus
        b = mul_mod(b, b, modulus)
        power = power Shr 1
    Wend

    Return x

End Function

Function Isprime(n As ULongInt, k As Long) As Long
    ' miller-rabin prime test
    If n > 9223372036854775808ull Then ' limit 2^63, pow_mod/mul_mod can't handle bigger numbers
        Print "number is to big, program will end"
        Sleep
        End
    End If

    ' 2 is a prime, if n is smaller then 2 or n is even then n = composite
    If n = 2 Then Return TRUE
    If (n < 2) OrElse ((n And 1) = 0) Then Return FALSE

    Dim As ULongInt a, x, n_one = n - 1, d = n_one
    Dim As UInteger s

    While (d And 1) = 0
        d = d Shr 1
        s = s + 1
    Wend

    While k > 0
        k = k - 1
        a = Int(Rnd * (n -2)) +2          ' 2 <= a < n
        x = pow_mod(a, d, n)
        If (x = 1) Or (x = n_one) Then Continue While
        For r As Integer = 1 To s -1
            x = pow_mod(x, 2, n)
            If x = 1 Then Return FALSE
            If x = n_one Then Continue While
        Next
        If x <> n_one Then Return FALSE
    Wend
    Return TRUE

End Function

Function legendre_symbol (a As LongInt, p As LongInt) As LongInt

    Dim As LongInt x = pow_mod(a, ((p -1) \ 2), p)
    If p -1 = x Then
        Return x - p
    Else
        Return x
    End If

End Function

' ------=< MAIN >=------

Dim As LongInt b, c, i, k, m, n, p, q, r, s, t, z

For k = 1 To 7
    Read n, p
    Print "Find solution for n ="; n; " and p =";p

    If legendre_symbol(n, p) <> 1 Then
        Print n;" is not a quadratic residue"
        Print
        Continue For
    End If

    If p = 2 OrElse Isprime(p, 15) = FALSE Then
        Print p;" is not a odd prime"
        Print
        Continue For
    End If

    s = 0 : q = p -1
    Do
        s += 1
        q \= 2
    Loop Until (q And 1) = 1

    If s = 1 And (p Mod 4) = 3 Then
        r = pow_mod(n, ((p +1) \ 4), p)
        Print "Solution found:"; r; " and"; p - r
        Print
        Continue For
    End If

    z = 1
    Do
        z += 1
    Loop Until legendre_symbol(z, p) = -1
    c = pow_mod(z, q, p)
    r = pow_mod(n, (q +1) \ 2, p)
    t = pow_mod(n, q, p)
    m = s

    Do
        i = 0
        If (t Mod p) = 1 Then
            Print "Solution found:"; r; " and"; p - r
            Print
            Continue For
        End If

        Do
            i += 1
            If i >= m Then Continue For
        Loop Until pow_mod(t, 2 ^ i, p) = 1
        b = pow_mod(c, (2 ^ (m - i -1)), p)
        r = mul_mod(r, b, p)
        c = mul_mod(b, b, p)
        t = mul_mod(t, c, p)' t = t * b ^ 2
        m = i
    Loop

Next

Data 10, 13, 56, 101, 1030, 10009, 1032, 10009, 44402, 100049
Data 665820697, 1000000009, 881398088036, 1000000000039

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
