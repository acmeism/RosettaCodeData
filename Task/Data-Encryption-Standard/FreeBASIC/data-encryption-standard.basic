' version 20-01-2019
' compile with: fbc -s console

Dim Shared As String * 48 subkey_k()
Dim Shared As String code2

Sub make_subkeys(key As String)

    Dim As UInteger<32> pc_1(55) => _
       {57, 49, 41, 33, 25, 17,  9, _
         1, 58, 50, 42, 34, 26, 18, _
        10,  2, 59, 51, 43, 35, 27, _
        19, 11,  3, 60, 52, 44, 36, _
        63, 55, 47, 39, 31, 23, 15, _
         7, 62, 54, 46, 38, 30, 22, _
        14,  6, 61, 53, 45, 37, 29, _
         21, 13,  5, 28, 20, 12, 4}

    Dim As UInteger<32> pc_2(47) => _
           {14, 17, 11, 24,  1,  5, _
             3, 28, 15,  6, 21, 10, _
            23, 19, 12,  4, 26,  8, _
            16,  7, 27, 20, 13,  2, _
            41, 52, 31, 37, 47, 55, _
            30, 40, 51, 45, 33, 48, _
            44, 49, 39, 56, 34, 53, _
            46, 42, 50, 36, 29, 32}

    Dim As UInteger<32> number_of_left_shl(1 To 16) => _
            {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1}

    Dim As UInteger<32> p1 = Val("&H" + Left(key, 8)), _
                        p2 = Val("&H" + Right(key, 8))
    Dim As String * 64 str_key = Bin(p1, 32) + Bin(p2, 32)
    Dim As String * 56 perm_key
    Dim As UInteger<32> i, k, s = 1
    ReDim subkey_k(1 To 16)

    For i = 0 To 55
        perm_key[i] = str_key[pc_1(i) -1]
    Next

    Dim As String cd, c0 = Left(perm_key, 28), d0 = Right(perm_key, 28)
    c0 += c0 : d0 += d0

    For i = 1 To 16
        s += number_of_left_shl(i)
        cd = Mid(c0, s, 28) + Mid(d0, s, 28)
        For k = 0 To 47
            subkey_k(i)[k] = cd[pc_2(k) -1]
        Next
    Next

End Sub

Function encode_64bit_data(message As String) As String

    Dim As UInteger<32> ip(63) =>   _
    {58, 50, 42, 34, 26, 18, 10, 2, _
     60, 52, 44, 36, 28, 20, 12, 4, _
     62, 54, 46, 38, 30, 22, 14, 6, _
     64, 56, 48, 40, 32, 24, 16, 8, _
     57, 49, 41, 33, 25, 17,  9, 1, _
     59, 51, 43, 35, 27, 19, 11, 3, _
     61, 53, 45, 37, 29, 21, 13, 5, _
     63, 55, 47, 39, 31, 23, 15, 7}

    Dim As UInteger<32> ip_inv(63) => _
      {40, 8, 48, 16, 56, 24, 64, 32, _
       39, 7, 47, 15, 55, 23, 63, 31, _
       38, 6, 46, 14, 54, 22, 62, 30, _
       37, 5, 45, 13, 53, 21, 61, 29, _
       36, 4, 44, 12, 52, 20, 60, 28, _
       35, 3, 43, 11, 51, 19, 59, 27, _
       34, 2, 42, 10, 50, 18, 58, 26, _
       33, 1, 41,  9, 49, 17, 57, 25}

    Dim As UInteger<32> e(47) => _
        {32,  1,  2,  3,  4,  5, _
          4,  5,  6,  7,  8,  9, _
          8,  9, 10, 11, 12, 13, _
         12, 13, 14, 15, 16, 17, _
         16, 17, 18, 19, 20, 21, _
         20, 21, 22, 23, 24, 25, _
         24, 25, 26, 27, 28, 29, _
         28, 29, 30, 31, 32,  1}

    Dim As UInteger<32> p(31) => _
                {16,  7, 20, 21, _
                 29, 12, 28, 17, _
                  1, 15, 23, 26, _
                  5, 18, 31, 10, _
                  2,  8, 24, 14, _
                 32, 27,  3,  9, _
                 19, 13, 30,  6, _
                 22, 11,  4, 25}

    Dim As UInteger<32> S1_8(7, 63) => _
    {{14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,  _  's1
       0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,  _
       4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,  _
      15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13}, _
_
     {15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,  _  's2
       3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,  _
       0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,  _
      13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9}, _
_
     {10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,  _  's3
      13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,  _
      13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,  _
       1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12}, _
 _
         {7, 13, 14, 3,  0,  6,  9, 10,  1, 2, 8,  5, 11, 12,  4, 15,  _  's4
         13,  8, 11, 5,  6, 15,  0,  3,  4, 7, 2, 12,  1, 10, 14,  9,  _
         10,  6,  9, 0, 12, 11,  7, 13, 15, 1, 3, 14,  5,  2,  8,  4,  _
          3, 15,  0, 6, 10,  1, 13,  8,  9, 4, 5, 11, 12,  7,  2, 14}, _
 _
       {2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13, 0, 14,  9,  _  's5
       14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3, 9,  8,  6,  _
        4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6, 3,  0, 14,  _
       11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10, 4,  5,  3}, _
 _
      {12,  1, 10, 15, 9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,  _  's6
       10, 15,  4,  2, 7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,  _
        9, 14, 15,  5, 2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,  _
        4,  3,  2, 12, 9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13}, _
 _
         {4, 11,  2, 14, 15, 0,  8, 13,  3, 12, 9,  7,  5, 10, 6,  1,  _  's7
         13,  0, 11,  7,  4, 9,  1, 10, 14,  3, 5, 12,  2, 15, 8,  6,  _
          1,  4, 11, 13, 12, 3,  7, 14, 10, 15, 6,  8,  0,  5, 9,  2,  _
          6, 11, 13,  8,  1, 4, 10,  7,  9,  5, 0, 15, 14,  2, 3, 12}, _
 _
      {13,  2,  8, 4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,  _  's8
        1, 15, 13, 8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,  _
        7, 11,  4, 1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,  _
        2,  1, 14, 7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11}}

    Dim As UInteger<32> i, i1, k, tmp1, tmp2, tmp3
    tmp1 = Val("&H"+ Left(message,8)) : tmp2 = Val("&H" + Right(message,8))
    Dim As String * 64 Str1, str_message = Bin(tmp1, 32) + Bin(tmp2, 32)
    Dim As String * 48 temp
    Dim As String * 32 l(16), r(16), Str2
    Dim As String Str3

    For i = 0 To 63
        Str1[i] = str_message[ip(i) -1]
    Next

    l(0) = Left(Str1, 32)
    r(0) = Right(Str1, 32)

    For i = 1 To 16
        i1 = i -1
        l(i) = r(i1)

        For k = 0 To 47
            temp[k] = ((subkey_k(i)[k] + r(i1)[e(k) -1]) And 1) + Asc("0")
        Next

        Str3 = ""
        For k = 0 To 42 Step 6
            tmp1 = Val("&B" + Mid(temp, k +1, 1) + Mid(temp, k +6, 1))
            tmp2 = Val("&B" + Mid(temp, k +2, 4))
            Str3 = Str3 + Bin(s1_8(k \ 6 , tmp1 * 16 + tmp2), 4)
        Next

        For k = 0 To 31
            r(i)[k] = ((l(i1)[k] + Str3[p(k) -1]) And 1) + Asc("0")
        Next
    Next

    Str3 = r(16) + l(16)
    For i = 0 To 63
        Str1[i] = Str3[ip_inv(i) -1]
    Next

    tmp1 = Val("&B" + Left(Str1,32))
    tmp2 = Val("&B" + Right(Str1,32))
    Return Hex(tmp1, 8) + Hex(tmp2, 8)

End Function

Function convert(key As String, message As String) As String

    Dim As UInteger<32> i, l
    Dim As String answer, crypto

    If Len(key) = 16 Then
        make_subkeys(key)
        If code2 = "decode" Then
            For i = 1 To 8
                Swap subkey_k(i), subkey_k(16 +1 -i)
            Next
        End If
    Else
        Beep
        Print "wrong key length, program stops"
        End
    End If

    Do Until InStr(message, " ") = 0
        i = InStr(message, " ")
        message = Left(message, i -1) + Mid(message, i +1)
    Loop

    l = Len(message) \ 16
    If Len(message) Mod 16 <> 0 Then
        l += 1
        message = Left((message + String(16, "0")), l * 16)
    End If

    For i = 0 To l -1
        answer = encode_64bit_data(Mid(message, i * 16 +1, 16))
        crypto = crypto + answer
    Next

    If code2 = "decode" And InStrRev(answer, "0D0A0") <> 0 Then
        crypto = RTrim(crypto, "0")
    End If

    Return crypto

End Function

Function encode(key As String, message As String) As String

    code2 = "encode"
    Return convert(key, message)

End Function

Function decode(key As String, message As String) As String

    code2 = "decode"
    Return convert(key, message)

End Function

' ------=< MAIN >=------

Dim As String key, message, crypto, answer

message = "0123456789ABCDEF"
key = "133457799BBCDFF1"
Print "    key "; key
Print "   text "; message
answer = encode(key, message)
Print "encoded "; answer
answer = decode(key, answer)
Print "decoded "; answer
Print

message = "8787878787878787"
key = "0E329232EA6D0D73"
Print "    key "; key
Print "   text "; message
answer = encode(key, message)
Print "encoded "; answer
answer = decode(key, answer)
Print "decoded "; answer
Print

message = "596F7572206C6970 732061726520736D 6F6F746865722074" + _
          " 68616E2076617365 6C696E650D0A"
key = "0E329232EA6D0D73"
Print "    key "; key
Print "   text "; message
answer = encode(key, message)
Print "encoded "; answer
answer = decode(key, answer)
Print "decoded "; answer

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
