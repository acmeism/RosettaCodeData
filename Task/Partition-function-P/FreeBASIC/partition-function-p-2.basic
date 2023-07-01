' version 26-06-2021
' compile with: fbc -s console

#Include Once "gmp.bi"

Sub PartitionsP(max As ULong, p() As MpZ_ptr)
    ' based on Numericana code example
    Dim As ULong a, b, i, k
    Dim As Long j

    Dim As Mpz_ptr s = Allocate(Len(__mpz_struct)) : Mpz_init(s)

    Mpz_set_ui(p(0), 1)

    For i = 1 To max
        j = 1 : k = 1 : b = 2 : a = 5
        While j > 0
            ' j = i - (3*k*k+k) \ 2
            j = i - b : b = b + a : a = a + 3
            If j >= 0 Then
                If k And 1 Then Mpz_add(s, s, p(j)) Else Mpz_sub(s, s, p(j))
            End If
            j = j + k
            If j >= 0 Then
                If k And 1 Then Mpz_add(s, s, p(j)) Else Mpz_sub(s, s, p(j))
            End If
            k = k +1
        Wend
        Mpz_swap(p(i), s)
    Next

    Mpz_clear(s)

End Sub

' ------=< MAIN >=------

#Define max 6666

Dim As UInteger n
Dim As ZString Ptr ans
Dim As Double t = Timer

ReDim big_p(max) As Mpz_ptr
For n = 0 To max
    big_p(n) = Allocate(Len(__mpz_struct)) : Mpz_init(big_p(n))
Next

PartitionsP(max, big_p())
ans = Mpz_get_str (0, 10, big_p(max))
Print "PartitionsP("; Str(max); ") = "; "  "; *ans

For n = 0 To max
    Mpz_clear(big_p(n))
Next

Print Using "time = ###.## ms"; (Timer - t) * 1000

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
