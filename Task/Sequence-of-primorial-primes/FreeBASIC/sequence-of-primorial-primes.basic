' version 23-10-2016
' compile with: fbc -s console

#Define max 9999    ' max number for the sieve

#Include Once "gmp.bi"

Dim As mpz_ptr p, p1
p  = Allocate(Len(__mpz_struct)) : Mpz_init_set_ui(p, 1)
p1 = Allocate(Len(__mpz_struct)) : Mpz_init(p1)

Dim As UInteger i, n, x
Dim As Byte prime(max)

' Sieve of Eratosthenes
For i = 4 To max Step 2
  prime(i) = 1
Next
For i = 3 To Sqr(max) Step 2
  If prime(i) = 1 Then Continue For
  For n = i * i To max Step i * 2
    prime(n) = 1
  Next
Next

n = 0 : x = 0
For i = 2 To max
  If prime(i) = 1 Then Continue For
  x = x + 1
  mpz_mul_ui(p, p, i)
  mpz_sub_ui(p1, p, 1)
  If mpz_probab_prime_p(p1, 25) > 0 Then
    Print Using "####"; x; : Print ",";
    n += 1
    If n >= 20 Then Exit For
    Continue For
  End If
  mpz_add_ui(p1, p, 1)
  If mpz_probab_prime_p(p1, 25) > 0 Then
    Print Using "####"; x; : Print ",";
    n += 1
    If n >= 20 Then Exit For
  End If
Next

Print
mpz_clear(p)
mpz_clear(p1)

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
