' version 12-04-2017
' compile with: fbc -s console

#Include Once "gmp.bi"

Type fp2
    x As Mpz_ptr
    y As Mpz_ptr
End Type

Data "10", "13"
Data "56", "101"
Data "8218", "10007"
Data "8219", "10007"
Data "331575", "1000003"
Data "665165880", "1000000007"
Data "881398088036", "1000000000039"
Data "34035243914635549601583369544560650254325084643201"  ', 10^50 + 151

Function fp2mul(a As fp2, b As fp2, p As Mpz_ptr, w2 As Mpz_ptr) As fp2

    Dim As fp2 r
    r.x = Allocate(Len(__Mpz_struct)) : Mpz_init(r.x)
    r.y = Allocate(Len(__Mpz_struct)) : Mpz_init(r.y)

    Mpz_mul (r.x, a.y, b.y)
    Mpz_mul (r.x, r.x, w2)
    Mpz_addmul(r.x, a.x, b.x)
    Mpz_mod (r.x, r.x, p)
    Mpz_mul (r.y, a.x, b.y)
    Mpz_addmul(r.y, a.y, b.x)
    Mpz_mod (r.y, r.y, p)

    Return r

End Function

Function fp2square(a As fp2, p As Mpz_ptr, w2 As Mpz_ptr) As fp2

    Return fp2mul(a, a, p, w2)

End Function

Function fp2pow(a As fp2, n As Mpz_ptr, p As Mpz_ptr, w2 As Mpz_ptr) As fp2

    If Mpz_cmp_ui(n, 0) = 0 Then
        Mpz_set_ui(a.x, 1)
        Mpz_set_ui(a.y, 0)
        Return a
    End If
    If Mpz_cmp_ui(n, 1) = 0 Then Return a
    If Mpz_cmp_ui(n, 2) = 0 Then Return fp2square(a, p, w2)
    If Mpz_tstbit(n, 0) = 0 Then
        Mpz_fdiv_q_2exp(n, n, 1) ' even
        Return fp2square(fp2pow(a, n, p, w2), p, w2)
    Else
        Mpz_sub_ui(n, n, 1)      ' odd
        Return fp2mul(a, fp2pow(a, n, p, w2), p, w2)
    End If

End Function

' ------=< MAIN >=------

Dim As Long i
Dim As ZString Ptr zstr
Dim As String n_str, p_str

Dim As Mpz_ptr a, n, p, p2, w2, x1, x2
a  = Allocate(Len(__Mpz_struct)) : Mpz_init(a)
n  = Allocate(Len(__Mpz_struct)) : Mpz_init(n)
p  = Allocate(Len(__Mpz_struct)) : Mpz_init(p)
p2 = Allocate(Len(__Mpz_struct)) : Mpz_init(p2)
w2 = Allocate(Len(__Mpz_struct)) : Mpz_init(w2)
x1 = Allocate(Len(__Mpz_struct)) : Mpz_init(x1)
x2 = Allocate(Len(__Mpz_struct)) : Mpz_init(x2)

Dim As fp2 answer
answer.x = Allocate(Len(__Mpz_struct)) : Mpz_init(answer.x)
answer.y = Allocate(Len(__Mpz_struct)) : Mpz_init(answer.y)

For i = 1 To 8
    Read n_str
    Mpz_set_str(n, n_str, 10)
    If i < 8 Then
        Read p_str
        Mpz_set_str(p, p_str, 10)
    Else
        p_str = "10^50 + 151" ' set up last n
        Mpz_set_str(p, "1" + String(50, "0"), 10)
        Mpz_add_ui(p, p, 151)
    End If

    Print "Find solution for n = "; n_str; " and p = "; p_str

    If Mpz_tstbit(p, 0) = 0 OrElse Mpz_probab_prime_p(p, 20) = 0 Then
        Print p_str; "is not a odd prime"
        Print
        Continue For
    End If

    ' p is checked and is a odd prime
    ' legendre symbol needs to be 1
    If Mpz_legendre(n, p) <> 1 Then
        Print n_str; " is not a square in F"; p_str
        Print
        Continue For
    End If

    Mpz_set_ui(a, 1)
    Do
        Do
            Do
                Mpz_add_ui(a, a, 1)
                Mpz_mul(w2, a, a)
                Mpz_sub(w2, w2, n)
            Loop Until Mpz_legendre(w2, p) = -1

            Mpz_set(answer.x, a)
            Mpz_set_ui(answer.y, 1)
            Mpz_add_ui(p2, p, 1)       ' p2 = p + 1
            Mpz_fdiv_q_2exp(p2, p2, 1) ' p2 = p2 \ 2 (p2 shr 1)

            answer = fp2pow(answer, p2, p, w2)

        Loop Until Mpz_cmp_ui(answer.y, 0) = 0
        Mpz_set(x1, answer.x)
        Mpz_sub(x2, p, x1)
        Mpz_powm_ui(a, x1, 2, p)
        Mpz_powm_ui(p2, x2, 2, p)
        If Mpz_cmp(a, n) = 0 AndAlso Mpz_cmp(p2, n) = 0 Then Exit Do
    Loop

    zstr = Mpz_get_str(0, 10, x1)
    Print "Solution found: x1 = "; *zstr;
    zstr = Mpz_get_str(0, 10, x2)
    Print ", x2 = "; *zstr
    Print
Next

Mpz_clear(x1) : Mpz_clear(p2) : Mpz_clear(p) : Mpz_clear(a) : Mpz_clear(n)
Mpz_clear(x2) : Mpz_clear(w2) : Mpz_clear(answer.x) : Mpz_clear(answer.y)

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
