Loop
{
    m := A_index
    ; getting factors=====================
    loop % floor(sqrt(m))
    {
        if ( mod(m, A_index) == "0" )
        {
            if ( A_index ** 2 == m )
            {
                list .= A_index . ":"
                sum := sum + A_index
                continue
            }
            if ( A_index != 1 )
            {
                list .= A_index . ":" . m//A_index . ":"
                sum := sum + A_index + m//A_index
            }
            if ( A_index == "1" )
            {
                list .= A_index . ":"
                sum := sum + A_index
            }
        }
    }
    ; Factors obtained above===============
    if ( sum == m ) && ( sum != 1 )
    {
        result := "perfect"
        perfect++
    }
    if ( sum > m )
    {
        result := "Abundant"
        Abundant++
    }
    if ( sum < m ) or ( m == "1" )
    {
        result := "Deficient"
        Deficient++
    }
    if ( m == 20000 )	
    {
        MsgBox % "number: " . m . "`nFactors:`n" . list . "`nSum of Factors: " . Sum . "`nResult: " . result . "`n_______________________`nTotals up to: " . m . "`nPerfect: " . perfect . "`nAbundant: " . Abundant . "`nDeficient: " . Deficient
        ExitApp
    }
    list := ""
    sum := 0
}

esc::ExitApp
