    Array := []
    inputbox, string, Enter Number
    stringsplit, string, string, .
    if ( string1 = 0 )
            string1 =
    loop, parse, string, .
            if A_index = 2
                    loop, parse, A_loopfield
                                                    Array[A_index] := A_loopfield,          k := A_index
    if (k = 1)
     {
    numerator := Array[1]
    Denominator := 10
    goto label
    }
    Original1 := K
    To_rn := floor(k/2)
    M_M := k - To_rn
    Original2 := k - To_rn
    loop
    {
    loop, % To_rn

    {
    Check1 .= Array[k]
    Check2 .= Array[M_M]
    k--
    m_M--
    }
    if ( check1 = check2 )
    {
            ;~ process beginsTO check;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      loop, % To_rn
        nines .= 9
    loop, % k - TO_rn
        Zeroes .= 0
    loop % k - TO_rn
            Minus .= Array[A_index]
    loop % k
            Plus .= Array[A_index]
    if ( minus = "" )
            minus := 0
    Numerator := Plus - minus
    Denominator := Nines . Zeroes
    ;;;;;;;;;;;;;HCF
    goto, label
    }
    Check1 =
    check2 =
    k := Original1
    m_M := original2 + A_index
    TO_rn--
    if ( to_rn = 0 )
    {
            zeroes =
            loop % original1
                    zeroes .= 0
    Denominator := 1 . zeroes
    numerator := string2
    goto, label
    }
    }
    esc::Exitapp
    label:
    Index := 2
    loop
    {

            if (mod(denominator, numerator) = 0 )
                    HCF := numerator
            if ( index = floor(numerator/2) )
            break
    if  ( mod(numerator, index) = 0 ) && ( mod(denominator, index) = 0 )
    {
            HCF = %index%
            index++
    }
    else
            index++
    }
    if ( HCF = "" )
            Ans := numerator "/" Denominator
    else
    Ans := floor(numerator/HCF) "/" floor(Denominator/HCF)
    MsgBox % String . "  ->  " . String1 . " " . Ans
    reload
