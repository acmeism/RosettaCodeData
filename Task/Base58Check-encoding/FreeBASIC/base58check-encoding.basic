' version 14-08-2017
' compile with: fbc -s console
' uses GMP

#Include Once "gmp.bi"

Data "25420294593250030202636073700053352635053786165627414518" ' 6UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM
Data "0x61"                                                     ' 2g
Data "0x626262"                                                 ' a3gV
Data "0x636363"                                                 ' aPEr
Data "0x73696d706c792061206c6f6e6720737472696e67"               ' 2cFupjhnEsSn59qHXstmK2ffpLv2
Data "0x516b6fcd0f"                                             ' ABnLTmg
Data "0xbf4f89001e670274dd"                                     ' 3SEo3LWLoPntC
Data "0x572e4794"                                               ' 3EFU7m
Data "0xecac89cad93923c02321"                                   ' EJDM8drfXA6uyA
Data "0x10c8511e"                                               ' Rt5zm
Data ""

Function conv2base58(decimal As String, _base_ As Integer = 0) As String

    Dim As String convert
    Dim As String base58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    Dim As String norm58 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuv"
    Dim As ZString Ptr gmp_str : gmp_str = Allocate(1000)
    Dim As Mpz_ptr tmp = Allocate(Len(__mpz_struct)) : Mpz_init(tmp)

    Mpz_set_str(tmp, decimal, _base_)
    Mpz_get_str(gmp_str, 58, tmp)

    convert = *gmp_str

    For i As uinteger = 0 To Len(convert) -1
        convert[i] = base58[InStr(norm58, Chr(convert[i])) -1]
    Next

    Mpz_clear(tmp) : DeAllocate(gmp_str)

    Return convert

End Function

' ------=< MAIN >=------
Dim As String str_in

Print "OkobppXBkab(58) --> "; conv2base58("OkobppXBkab", 58)  ' 10687460092462769069(10)
Print

Do
    Read str_in
    If str_in = "" Then Exit Do
    Print str_in;
    If Len(str_in) < 54 Then Print Tab(43);
    Print " --> "; conv2base58(str_in)
Loop

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
