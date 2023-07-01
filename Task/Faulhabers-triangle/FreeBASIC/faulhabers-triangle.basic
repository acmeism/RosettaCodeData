' version 12-08-2017
' compile with: fbc -s console
' uses GMP

#Include Once "gmp.bi"

#Define i_max 17

Dim As UInteger i, j, x
Dim As String   s
Dim As ZString Ptr gmp_str : gmp_str = Allocate(100)

Dim As Mpq_ptr n, tmp1, tmp2, sum, one, zero
n    = Allocate(Len(__mpq_struct)) : Mpq_init(n)
tmp1 = Allocate(Len(__mpq_struct)) : Mpq_init(tmp1)
tmp2 = Allocate(Len(__mpq_struct)) : Mpq_init(tmp2)
sum  = Allocate(Len(__mpq_struct)) : Mpq_init(sum)
zero = Allocate(Len(__mpq_struct)) : Mpq_init(zero)
one  = Allocate(Len(__mpq_struct)) : Mpq_init(one)
Mpq_set_ui(zero, 0, 0)  ' 0/0 = 0
Mpq_set_ui(one , 1, 1)  ' 1/1 = 1

Dim As Mpq_ptr Faulhaber_triangle(0 To i_max, 1 To i_max +1)
' only initialize the variables we need
For i = 0 To i_max
    For j = 1 To i +1
        Faulhaber_triangle(i, j) = Allocate(Len(__Mpq_struct))
        Mpq_init(Faulhaber_triangle(i, j))
    Next
Next

Mpq_set(Faulhaber_triangle(0, 1), one)

' we calculate the first 18 rows
For i = 1 To i_max
    Mpq_set(sum, zero)
    For j = i +1 To 2 Step -1
        Mpq_set_ui(tmp1, i, j)            ' i / j
        Mpq_set(tmp2, Faulhaber_triangle(i -1, j -1))
        Mpq_mul(Faulhaber_triangle(i, j), tmp2, tmp1)
        Mpq_canonicalize(Faulhaber_triangle(i, j))
        Mpq_add(sum, sum, Faulhaber_triangle(i, j))
    Next
    Mpq_sub(Faulhaber_triangle(i, 1), one, sum)
Next

Print "The first 10 rows"
For i = 0 To 9
    For j = 1 To i +1
        Mpq_get_str(gmp_str, 10, Faulhaber_triangle(i, j))
        s = Space(6) + *gmp_str + Space(6)
        x = InStr(s,"/")
        If x = 0 Then x = 7               ' in case of 0 or 1
        Print Mid(s, x -3, 7);
    Next
    Print
Next
print

' using the 17'the row
Mpq_set(sum, zero)
Mpq_set_ui(n, 1000, 1)                    ' 1000/1 = 1000
Mpq_set(tmp2, n)
For j = 1 To 18
    Mpq_mul(tmp1, n, Faulhaber_triangle(17, j))
    Mpq_add(sum, sum, tmp1)
    Mpq_mul(n, n, tmp2)
Next

Mpq_get_str(gmp_str, 10, sum)
Print *gmp_str

' free memory
DeAllocate(gmp_str)
Mpq_clear(tmp1) : Mpq_clear(tmp2) : Mpq_clear(n)
Mpq_clear(zero) : Mpq_clear(one)  : Mpq_clear(sum)

For i = 0 To i_max
    For j = 1 To i +1
        Mpq_clear(Faulhaber_triangle(i, j))
    Next
Next

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
