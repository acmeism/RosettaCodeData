' version 04-10-2024
' compile with: fbc -s console

#Include Once "gmp.bi"

#Define max 2700

Dim As UInteger j, i, m, n, tmp, ub
ReDim As UInteger sieve(max), primes(max)

Dim As Mpz_ptr rp
rp = Allocate(Len(__Mpz_struct)) : Mpz_init(rp)

For j = 4 To max Step 2
    sieve(j) = 1
Next
For j = 3 To max Step 2
    If sieve(j) = 0 Then
        For i = j * j To max Step j + j
            sieve(i) = 1
        Next
    End If
Next

i = 0
For j = 2 To max
    If sieve(j) = 0 Then
        i += 1
        primes(i) = j
    End If
Next

ub = i
For j = 2 To 36
    Print Using "### : "; j;
    For i = 1 To ub
        mpz_ui_pow_ui(rp, j , primes(i))
        mpz_sub_ui(rp, rp , 1)
        mpz_divexact_ui(rp, rp, j -1)
        If mpz_tstbit(rp ,0) = 1 Then
            If mpz_probab_prime_p(rp, 40) > 0 Then
                Print primes(i); " ";
            End If
        End If
    Next
    Print
Next

mpz_clear(rp)


' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
