' version 07-04-2018
' compile with: fbc -s console

#Include "gmp.bi"

#Define _a(Q) (@(Q)->_mp_num)  'a
#Define _b(Q) (@(Q)->_mp_den)  'b

Data "[1, 1, 2] [1, 1, 3]"
Data "[2, 1, 3] [1, 1, 7]"
Data "[4, 1, 5] [-1, 1, 239]"
Data "[5, 1, 7] [2, 3, 79]"
Data "[1, 1, 2] [1, 1, 5] [1, 1, 8]"
Data "[4, 1, 5] [-1, 1, 70] [1, 1, 99]"
Data "[5, 1, 7] [4, 1, 53] [2, 1, 4443]"
Data "[6, 1, 8] [2, 1, 57] [1, 1, 239]"
Data "[8, 1, 10] [-1, 1, 239] [-4, 1, 515]"
Data "[12, 1, 18] [8, 1, 57] [-5, 1, 239]"
Data "[16, 1, 21] [3, 1, 239] [4, 3, 1042]"
Data "[22, 1, 28] [2, 1, 443] [-5, 1, 1393] [-10, 1, 11018]"
Data "[22, 1, 38] [17, 7, 601] [10, 7, 8149]"
Data "[44, 1, 57] [7, 1, 239] [-12, 1, 682] [24, 1, 12943]"
Data "[88, 1, 172] [51, 1, 239] [32, 1, 682] [44, 1, 5357] [68, 1, 12943]"
Data "[88, 1, 172] [51, 1, 239] [32, 1, 682] [44, 1, 5357] [68, 1, 12944]"
Data ""

Sub work2do (ByRef a As LongInt, f1 As mpq_ptr)

    Dim As LongInt flag = -1

    Dim As Mpq_ptr x, y, z
    x = Allocate(Len(__mpq_struct)) : Mpq_init(x)
    y = Allocate(Len(__mpq_struct)) : Mpq_init(y)
    z = Allocate(Len(__mpq_struct)) : Mpq_init(z)

    Dim As Mpz_ptr temp1, temp2
    temp1 = Allocate(Len(__Mpz_struct)) : Mpz_init(temp1)
    temp2 = Allocate(Len(__Mpz_struct)) : Mpz_init(temp2)

    mpq_set(y, f1)

    While a > 0
        If (a And 1) = 1 Then
            If flag = -1 Then
                mpq_set(x, y)
                flag = 0
            Else
                Mpz_mul(temp1, _a(x), _b(y))
                Mpz_mul(temp2, _b(x), _a(y))
                Mpz_add(_a(z), temp1, temp2)
                Mpz_mul(temp1, _b(x), _b(y))
                Mpz_mul(temp2, _a(x), _a(y))
                Mpz_sub(_b(z), temp1, temp2)
                mpq_canonicalize(z)
                mpq_set(x, z)
            End If
        End If

        Mpz_mul(temp1, _a(y), _b(y))
        Mpz_mul(temp2, _b(y), _a(y))
        Mpz_add(_a(z), temp1, temp2)
        Mpz_mul(temp1, _b(y), _b(y))
        Mpz_mul(temp2, _a(y), _a(y))
        Mpz_sub(_b(z), temp1, temp2)
        mpq_canonicalize(z)
        mpq_set(y, z)

        a = a Shr 1
    Wend

    mpq_set(f1, x)

End Sub

' ------=< MAIN >=------

Dim As Mpq_ptr f1, f2, f3
f1 = Allocate(Len(__mpq_struct)) : Mpq_init(f1)
f2 = Allocate(Len(__mpq_struct)) : Mpq_init(f2)
f3 = Allocate(Len(__mpq_struct)) : Mpq_init(f3)

Dim As Mpz_ptr temp1, temp2
temp1 = Allocate(Len(__Mpz_struct)) : Mpz_init(temp1)
temp2 = Allocate(Len(__Mpz_struct)) : Mpz_init(temp2)

Dim As mpf_ptr float
float = Allocate(Len(__mpf_struct)) : Mpf_init(float)

Dim As LongInt m1, a1, b1, flag, t1, t2, t3, t4
Dim As String s, s1, s2, s3, sign
Dim As ZString Ptr zstr

Do

    Read s
    If s = "" Then Exit Do
    flag = -1

    While s <> ""
        t1 = InStr(s, "[") +1
        t2 = InStr(t1, s, ",") +1
        t3 = InStr(t2, s, ",") +1
        t4 = InStr(t3, s, "]")
        s1 = Trim(Mid(s, t1, t2 - t1 -1))
        s2 = Trim(Mid(s, t2, t3 - t2 -1))
        s3 = Trim(Mid(s, t3, t4 - t3))
        m1 = Val(s1)
        a1 = Val(s2)
        b1 = Val(s3)

        sign = IIf(m1 < 0, " - ", " + ")
        If m1 < 0 Then a1 = -a1 : m1 = Abs(m1)
        s = Mid(s, t4 +1)
        Print IIf(flag = 0, sign, ""); IIf(m1 = 1, "", Str(m1));
        Print "Atn("; s2; "/" ;s3; ")";

        If flag = -1 Then
            flag = 0
            Mpz_set_si(_a(f1), a1)
            Mpz_set_si(_b(f1), b1)
            If m1 > 1 Then work2do(m1, f1)
            Continue While
        End If

        Mpz_set_si(_a(f2), a1)
        Mpz_set_si(_b(f2), b1)
        If m1 > 1 Then work2do(m1, f2)

        Mpz_mul(temp1, _a(f1), _b(f2))
        Mpz_mul(temp2, _b(f1), _a(f2))
        Mpz_add(_a(f3), temp1, temp2)
        Mpz_mul(temp1, _b(f1), _b(f2))
        Mpz_mul(temp2, _a(f1), _a(f2))
        Mpz_sub(_b(f3), temp1, temp2)
        mpq_canonicalize(f3)
        mpq_set(f1, f3)

    Wend

    If Mpz_cmp_ui(_b(f1), 1) = 0 AndAlso Mpz_cmp(_a(f1), _b(f1)) = 0 Then
        Print " = 1"
    Else
        Mpf_set_q(float, f1)
        gmp_printf(!" = %.*Ff\n", 15, float)
    End If

Loop

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
