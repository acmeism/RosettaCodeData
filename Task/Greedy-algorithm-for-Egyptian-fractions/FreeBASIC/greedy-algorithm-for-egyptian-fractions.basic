' version 16-01-2017
' compile with: fbc -s console

#Define max 30

#Include Once "gmp.bi"

Dim Shared As Mpz_ptr num(max), den(max)

Function Egyptian_fraction(fraction As String, ByRef whole As Integer, range As Integer = 0) As Integer

    If InStr(fraction,"/") = 0 Then
        Print "Not a fraction, program will end"
        Sleep 5000, 1
        End
    End If

    Dim As Integer i, count

    Dim As Mpz_ptr tmp_num, tmp_den, x, y, q
    tmp_num = Allocate(Len(__Mpz_struct)) : Mpz_init(tmp_num)
    tmp_den = Allocate(Len(__Mpz_struct)) : Mpz_init(tmp_den)
    x = Allocate(Len(__Mpz_struct)) : Mpz_init(x)
    y = Allocate(Len(__Mpz_struct)) : Mpz_init(y)
    q = Allocate(Len(__Mpz_struct)) : Mpz_init(q)

    For i = 1 To max ' clear the list
        Mpz_set_ui(num(i), 0)
        Mpz_set_ui(den(i), 0)
    Next

    i = InStr(fraction,"/")
    Mpz_set_str(x, Left(fraction, i -1), 10)
    Mpz_set_str(y, Right(fraction, Len(fraction) - i), 10)

    ' if it's a improper fraction make it proper fraction
    If Mpz_cmp(x , y) > 0  Then
        Mpz_fdiv_q(q, x, y)
        whole = Mpz_get_ui(q)
        Mpz_fdiv_r(x, x, q)
    Else
        whole = 0
    End If

    Mpz_gcd(q, x, y) ' check if reduction is possible
    If Mpz_cmp_ui(q, 1) > 0 Then
        If range <> 0 Then ' return if we do a range test
            Return -1
        Else
            Mpz_fdiv_q(x, x, q)
            Mpz_fdiv_q(y, y, q)
        End If
    End If

    Mpz_set(num(count), x)
    Mpz_set(den(count), y)
    ' Fibonacci's Greedy algorithm for Egyptian fractions
    Do
        If Mpz_cmp_ui(num(count), 1) = 0 Then Exit Do
        Mpz_set(x, num(count))
        Mpz_set(y, den(count))
        Mpz_cdiv_q(q, y, x)
        Mpz_set_ui(num(count), 1)
        Mpz_set(den(count), q)
        Mpz_mul(tmp_den, y, q)
        Mpz_neg(y, y)
        Mpz_mod(tmp_num, y, x)
        count += 1
        Mpz_gcd(q, tmp_num, tmp_den) ' check if reduction is possible
        If Mpz_cmp_ui(q, 1) > 0 Then
            Mpz_fdiv_q(tmp_num, tmp_num, q)
            Mpz_fdiv_q(tmp_den, tmp_den, q)
        End If
        Mpz_set(num(count), tmp_num)
        Mpz_set(den(count), tmp_den)
    Loop

    Mpz_clear(tmp_num) : Mpz_clear(tmp_den)
    Mpz_clear(x) : Mpz_clear(y) :Mpz_clear(q)

    Return count

End Function

Sub prt_solution(fraction As String, whole As Integer, count As Integer)

    Print fraction; " = ";

    If whole <> 0 Then
        Print "["; Str(whole); "] + ";
    End If

    For i As Integer = 0 To count
        Gmp_printf("%Zd/%Zd ", num(i), den(i))
        If i <> count Then Print "+ ";
    Next
    Print

End Sub

' ------=< MAIN >=------

Dim As Integer n, d, number, improper, max_term,  max_size
Dim As String str_in, max_term_str, max_size_str, m_str
Dim As ZString Ptr gmp_str : gmp_str = Allocate(1000000)

For n = 0 To max
    num(n) = Allocate(Len(__Mpz_struct)) : Mpz_init(num(n))
    den(n) = Allocate(Len(__Mpz_struct)) : Mpz_init(den(n))
Next

Data "43/48", "5/121", "2014/59"
' 4/121 = 12/363 = 11/363 + 1/363 = 1/33 + 1/363
' 5/121 = 4/121 + 1/121 = 1/33 + 1/121 + 1/363
' 2014/59 = 34 + 8/59
' 8/59 = 1/8 + 5/472 = 1/8 + 4/472 + 1/472 = 1/8 + 1/118 + 1/472

For n = 1 To 3
    Read str_in
    number = Egyptian_fraction(str_in, improper)
    prt_solution(str_in, improper, number)
    Print
Next

Dim As Integer a = 1 , b = 99

Do
    For d = a To b
        For n = 1 To d -1
            str_in = Str(n) + "/" + Str(d)
            number = Egyptian_fraction(str_in, improper,1)
            If number = -1 Then Continue For ' skip
            If number > max_term Then
                max_term = number
                max_term_str = str_in
            ElseIf number = max_term Then
                max_term_str += ", " & str_in
            End If
            Mpz_get_str(gmp_str, 10, den(number))
            If Len(*gmp_str) > max_size Then
                max_size = Len(*gmp_str)
                max_size_str = str_in
                m_str = *gmp_str
            ElseIf max_size = Len(*gmp_str) Then
                max_size_str += ", " & str_in
            End If
        Next
    Next
    Print
    Print "for 1 to"; Len(Str(b)); " digits"
    Print "Largest number of terms is"; max_term +1; " for "; max_term_str
    Print "Largest size for denominator is"; max_size; " for "; max_size_str

    If b = 999 Then Exit Do
    a = b +1 : b = b * 10 +9
Loop

For n = 0 To max
    Mpz_clear(num(n))
    Mpz_clear(den(n))
Next

DeAllocate(gmp_str)

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
