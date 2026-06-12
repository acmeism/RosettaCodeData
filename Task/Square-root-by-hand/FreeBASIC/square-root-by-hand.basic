' version 20-12-2020
' compile with: fbc -s console

#Include Once "gmp.bi"

Dim As Integer dec_p, i, x, n1, n2, r , guess
Dim As String number = "2", square_root, p1, p2
Dim As ZString Ptr zstr
' remove space(s) and leading 0's
number = LTrim(Trim(number), "0")
dec_p = InStr(number, ".")
Print "Square Root of "; number; " = ";
square_root = "Square Root of " + number + " = "

' remove the decimal point and make number an even length string
If dec_p = 0 Then
    If (Len(number) And 1) = 1 Then number = "0" + number
    dec_p = Len(number) + 1
Else
    number = RTrim(number, "0")
    If dec_p <> 1 Then
        p1 = Left(number, dec_p -1)
        If (Len(p1) And 1) = 1 Then p1 = "0" + p1
    End If
    p2 = Mid(number, dec_p +1)
    If (Len(p2) And 1) = 1 Then p2 = p2 + "0"
    number = p1 + p2
End If

dec_p = dec_p Shr 1
i = 1

' handle zero's and find first non zero digit(s) of the root
' can be done with integers
Do
    n1 = Val(Mid(number, i, 2))

    If n1 = 0 Then
        n2 = 0
    Else
        For x = 0 To 9
            If x * x > n1 Then Exit For
        Next
        n2 = x - 1
        r = n1 - (n2 * n2)
    End If

    If dec_p = 0 Then
        Print ".";
        square_root += "."
    End If

    Print Str(n2); : square_root += Str(n2)
    dec_p -= 1
    n2 += n2
    i += 2

Loop Until n1 <> 0

' handle the rest of the number string
' starting with GMP integers
Dim As Mpz_ptr t1_, t2_, t3_, t4_, n2_, r_ , guess_
t1_    = Allocate(Len(__Mpz_struct)) : Mpz_init(t1_)
t2_    = Allocate(Len(__Mpz_struct)) : Mpz_init(t2_)
t3_    = Allocate(Len(__Mpz_struct)) : Mpz_init(t3_)
t4_    = Allocate(Len(__Mpz_struct)) : Mpz_init(t4_)
n2_    = Allocate(Len(__Mpz_struct)) : Mpz_init(n2_)
r_     = Allocate(Len(__Mpz_struct)) : Mpz_init(r_)
guess_ = Allocate(Len(__Mpz_struct)) : Mpz_init(guess_)

mpz_set_ui(n2_, n2)
mpz_set_ui(r_, r)

For x = i  To Len(number)-1 Step 2
    mpz_mul_ui(t1_, r_, 10)
    i = Val(Mid(number, x, 1))
    mpz_add_ui(t1_, t1_, i)

    If mpz_cmp_ui(t1_, 0) = 0 Or mpz_cmp_ui(n2_, 0) = 0 Then
        mpz_set_ui(guess_, 0)
    Else
        mpz_fdiv_q(guess_, t1_, n2_)
        If mpz_cmp_ui(guess_, 9) > 0 Then mpz_set_ui(guess_, 9)
    End If

    mpz_mul_ui(t1_, r_, 100)
    i = Val(Mid(number, x, 2))
    mpz_add_ui(t1_, t1_, i)
    mpz_mul_ui(t3_, n2_, 10)

    If  mpz_cmp_ui(n2_, 0) = 0 Then
        mpz_set_ui(guess_, 0)
    Else
        While mpz_cmp_ui(guess_, 0) <> 0
            mpz_add(t4_, t3_, guess_)
            mpz_mul(t4_, t4_, guess_)
            If mpz_cmp(t4_, t1_) <= 0 Then Exit While
            mpz_sub_ui(guess_, guess_, 1)
            Beep
        Wend
    End If

    mpz_sub(r_, t1_, t4_)
    mpz_add(t3_, t3_, guess_)
    mpz_add(n2_, t3_, guess_)

    If dec_p = 0 Then
        Print ".";
        square_root += "."
    End If

    zstr = mpz_get_str(0, 10, guess_)
    Print *zstr; : square_root += *zstr
    dec_p -= 1
Next

' last posible position of decimal point
If dec_p = 0 And r <> 0 Then
    Print ".";
    square_root += "."
End If
' if r = then stop
If mpz_cmp_ui(r_, 0) <> 0 Then

    ' stop if any key is pressed
    While Inkey <> "" : Wend
    While Inkey = ""
        mpz_mul_ui(t1_, r_, 10)
        mpz_fdiv_q(guess_, t1_, n2_)
        If mpz_cmp_ui(guess_, 9) > 0 Then mpz_set_ui(guess_, 9)
        mpz_mul_ui(t1_, r_, 100)
        mpz_mul_ui(t3_, n2_, 10)

        Do
            mpz_add(t4_, t3_, guess_)
            mpz_mul(t4_, t4_, guess_)
            If mpz_cmp(t4_, t1_) <= 0 Then Exit Do
            mpz_sub_ui(guess_, guess_, 1)
        Loop

        mpz_sub(r_, t1_, t4_)
        mpz_add(t3_, t3_, guess_)
        mpz_add(n2_, t3_, guess_)
        zstr = mpz_get_str(0, 10, guess_)
        Print *zstr; : square_root += *zstr

    Wend

End If
Print

/' remove this line to save the square root to a file
x = FreeFile
Open "square_root_by_hand.txt" For Output As #x
Print #x, square_root
Close
'/

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
