' version 12-04-2017
' compile with: fbc -s console

#Include Once "gmp.bi"

Data "10", "13", "56", "101", "1030", "10009", "1032", "10009"
Data "44402", "100049", "665820697", "1000000009"
Data "881398088036", "1000000000039"
Data "41660815127637347468140745042827704103445750172002"   ' p = 10^50 + 577

' ------=< MAIN >=------

Dim As uLong k
Dim As ZString Ptr zstr
Dim As String n_str, p_str

Dim As Mpz_ptr b, c, i, m, n, p, q, r, s, t, z, tmp
b = Allocate(Len(__Mpz_struct)) : Mpz_init(b)
c = Allocate(Len(__Mpz_struct)) : Mpz_init(c)
i = Allocate(Len(__Mpz_struct)) : Mpz_init(i)
m = Allocate(Len(__Mpz_struct)) : Mpz_init(m)
n = Allocate(Len(__Mpz_struct)) : Mpz_init(n)
p = Allocate(Len(__Mpz_struct)) : Mpz_init(p)
q = Allocate(Len(__Mpz_struct)) : Mpz_init(q)
r = Allocate(Len(__Mpz_struct)) : Mpz_init(r)
s = Allocate(Len(__Mpz_struct)) : Mpz_init(s)
t = Allocate(Len(__Mpz_struct)) : Mpz_init(t)
z = Allocate(Len(__Mpz_struct)) : Mpz_init(z)
tmp = Allocate(Len(__Mpz_struct)) : Mpz_init(tmp)

For k = 1 To 8
    Read n_str
    Mpz_set_str(n, n_str, 10)
    If k < 8 Then
        Read p_str
        Mpz_set_str(p, p_str, 10)
    Else
        p_str = "10^50 + 577"
        Mpz_set_str(p, "1" + String(50, "0"), 10)
        Mpz_add_ui(p, p, 577)
    End If

    Print "Find solution for n = "; n_str; " and p = "; p_str

    If Mpz_legendre(n, p) <> 1 Then
        Print n_str; " is not a quadratic residue"
        Print
        Continue For
    End If

    If Mpz_tstbit(p, 0) = 0 OrElse Mpz_probab_prime_p(p, 20) = 0 Then
        Print p_str; "is not a odd prime"
        Print
        Continue For
    End If

    Mpz_set_ui(s, 0) : Mpz_set(q, p) : Mpz_sub_ui(q, q, 1) ' q = p -1
    Do
        Mpz_add_ui(s, s, 1)
        Mpz_fdiv_q_2exp(q, q, 1)
    Loop Until Mpz_tstbit(q, 0) = 1

    If Mpz_cmp_ui(s, 1) = 0 Then
        If Mpz_tstbit(p, 1) = 1 Then
            Mpz_add_ui(tmp, p, 1)
            Mpz_fdiv_q_2exp(tmp, tmp, 2)         ' tmp = p +1 \ 4
            Mpz_powm(r, n, tmp, p)
            zstr = Mpz_get_str(0, 10, r)
            Print "Solution found: "; *zstr;
            Mpz_sub(r, p, r)
            zstr = Mpz_get_str(0, 10, r)
            Print " and "; *zstr
            Print
            Continue For
        End If
    End If

    Mpz_set_ui(z, 1)
    Do
        Mpz_add_ui(z, z, 1)
    Loop Until Mpz_legendre(z, p) = -1
    Mpz_powm(c, z, q, p)
    Mpz_add_ui(tmp, q, 1)
    Mpz_fdiv_q_2exp(tmp, tmp, 1)
    Mpz_powm(r, n, tmp, p)
    Mpz_powm(t, n, q, p)
    Mpz_set(m, s)

    Do
        Mpz_set_ui(i, 0)
        Mpz_mod(tmp, t, p)
        If Mpz_cmp_ui(tmp, 1) = 0 Then
            zstr = Mpz_get_str(0, 10, r)
            Print "Solution found: "; *zstr;
            Mpz_sub(r, p, r)
            zstr = Mpz_get_str(0, 10, r)
            Print " and "; *zstr
            Print
            Continue For
        End If

        Mpz_set_ui(q, 1)
        Do
            Mpz_add_ui(i, i, 1)
            If Mpz_cmp(i, m) >= 0 Then
                Continue For
            end if
            Mpz_mul_ui(q, q, 2)                  ' q = 2^i
            Mpz_powm(tmp, t, q, p)
        Loop Until Mpz_cmp_ui(tmp, 1) = 0

        Mpz_set_ui(q, 2)
        Mpz_sub(tmp, m, i) : Mpz_sub_ui(tmp, tmp, 1) : Mpz_powm(tmp, q, tmp, p)
        Mpz_powm(b, c, tmp, p)
        Mpz_mul(r, r, b) : Mpz_mod(r, r, p)
        Mpz_mul(tmp, b, b) : Mpz_mod(c, tmp, p)
        Mpz_mul(tmp, t, c) : Mpz_mod(t, tmp, p)
        Mpz_set(m, i)
    Loop

Next

Mpz_clear(b) : Mpz_clear(c) : Mpz_clear(i) : Mpz_clear(m)
Mpz_clear(n) : Mpz_clear(p) : Mpz_clear(q) : Mpz_clear(r)
Mpz_clear(s) : Mpz_clear(t) : Mpz_clear(z) : Mpz_clear(tmp)

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
