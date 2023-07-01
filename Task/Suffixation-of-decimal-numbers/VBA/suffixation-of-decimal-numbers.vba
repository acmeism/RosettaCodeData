Private Function suffize(number As String, Optional sfractiondigits As String, Optional base As String) As String
    Dim suffix As String, parts() As String, exponent As String
    Dim fractiondigits As Integer, nsuffix As Integer, flag As Boolean
    flag = False
    fractiondigits = Val(sfractiondigits)
    suffixes = " KMGTPEZYXWVU"
    number = Replace(number, ",", "", 1)
    Dim c As Currency
    Dim sign As Integer
    'separate leading sign
    If Left(number, 1) = "-" Then
        number = Right(number, Len(number) - 1)
        outstring = "-"
    End If
    If Left(number, 1) = "+" Then
        number = Right(number, Len(number) - 1)
        outstring = "+"
    End If
    'split exponent
    parts = Split(number, "e")
    number = parts(0)
    If UBound(parts) > 0 Then exponent = parts(1)
    'split fraction
    parts = Split(number, ".")
    number = parts(0)
    If UBound(parts) > 0 Then frac = parts(1)
    If base = "2" Then
        Dim cnumber As Currency
        cnumber = Val(number)
        nsuffix = 0
        Dim dnumber As Double
        If cnumber > 1023 Then
            cnumber = cnumber / 1024@
            nsuffix = nsuffix + 1
            dnumber = cnumber
            Do While dnumber > 1023
                dnumber = dnumber / 1024@ 'caveat: currency has only 4 fractional digits ...
                nsuffix = nsuffix + 1
            Loop
            number = CStr(dnumber)
        Else
            number = CStr(cnumber)
        End If
        leadingstring = Int(number)
        number = Replace(number, ",", "")

        leading = Len(leadingstring)
        suffix = Mid(suffixes, nsuffix + 1, 1)
    Else
        'which suffix
        nsuffix = (Len(number) + Val(exponent) - 1) \ 3
        If nsuffix < 13 Then
            suffix = Mid(suffixes, nsuffix + 1, 1)
            leading = (Len(number) - 1) Mod 3 + 1
            leadingstring = Left(number, leading)
        Else
            flag = True
            If nsuffix > 32 Then
                suffix = "googol"
                leading = Len(number) + Val(exponent) - 99
                leadingstring = number & frac & String$(Val(exponent) - 100 - Len(frac), "0")
            Else
                suffix = "U"
                leading = Len(number) + Val(exponent) - 35
                If Val(exponent) > 36 Then
                    leadingstring = number & String$(Val(exponent) - 36, "0")
                Else
                    leadingstring = Left(number, (Len(number) - 36 + Val(exponent)))
                End If
            End If
        End If
    End If
    'round up if necessary
    If fractiondigits > 0 Then
        If Val(Mid(number, leading + fractiondigits + 1, 1)) >= 5 Then
            fraction = Mid(number, leading + 1, fractiondigits - 1) & _
                CStr(Val(Mid(number, leading + fractiondigits, 1)) + 1)
        Else
            fraction = Mid(number, leading + 1, fractiondigits)
        End If
    Else
        If Val(Mid(number, leading + 1, 1)) >= 5 And sfractiondigits <> "" And sfractiondigits <> "," Then
            leadingstring = Mid(number, 1, leading - 1) & _
                CStr(Val(Mid(number, leading, 1)) + 1)
        End If
    End If
    If flag Then
        If sfractiondigits = "" Or sfractiondigits = "," Then
            fraction = ""
        End If
    Else
        If sfractiondigits = "" Or sfractiondigits = "," Then
            fraction = Right(number, Len(number) - leading)
        End If
    End If
    outstring = outstring & leadingstring
    If Len(fraction) > 0 Then
        outstring = outstring & "." & fraction
    End If
    If base = "2" Then
        outstring = outstring & suffix & "i"
    Else
        outstring = outstring & suffix
    End If
    suffize = outstring
End Function
Sub program()
    Dim s(10) As String, t As String, f As String, r As String
    Dim tt() As String, temp As String
    s(0) = "               87,654,321"
    s(1) = "          -998,877,665,544,332,211,000      3"
    s(2) = "          +112,233                          0"
    s(3) = "           16,777,216                       1"
    s(4) = "           456,789,100,000,000              2"
    s(5) = "           456,789,100,000,000              2      10"
    s(6) = "           456,789,100,000,000              5       2"
    s(7) = "           456,789,100,000.000e+00          0      10"
    s(8) = "          +16777216                         ,       2"
    s(9) = "           1.2e101"
    For i = 0 To 9
        ReDim tt(0)
        t = Trim(s(i))
        Do
            temp = t
            t = Replace(t, "  ", " ")
        Loop Until temp = t
        tt = Split(t, " ")
        If UBound(tt) > 0 Then f = tt(1) Else f = ""
        If UBound(tt) > 1 Then r = tt(2) Else r = ""
        Debug.Print String$(48, "-")
        Debug.Print "     input number = "; tt(0)
        Debug.Print "    fraction digs = "; f
        Debug.Print "  specified radix = "; r
        Debug.Print "       new number = "; suffize(tt(0), f, r)
    Next i
End Sub
