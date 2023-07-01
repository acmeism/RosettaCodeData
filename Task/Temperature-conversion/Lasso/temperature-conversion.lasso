define tempconverter(temp, kind) => {

    local(
        _temp       = decimal(#temp),
        convertratio    = 1.8,
        k_c     = 273.15,
        r_f     = 459.67,
        k,c,r,f
    )

    match(#kind) => {
        case('k')
            #k = #_temp
            #c = -#k_c + #k
            #r = #k * #convertratio
            #f = -#r_f + #r
        case('c')
            #c = #_temp
            #k = #k_c + #c
            #r = #k * #convertratio
            #f = -#r_f + #r
        case('r')
            #r = #_temp
            #f = -#r_f + #r
            #k = #r / #convertratio
            #c = -#k_c + #k
        case('f')
            #f = #_temp
            #r = #r_f + #f
            #k = #r / #convertratio
            #c = -#k_c + #k
        case
            return 'Something wrong'
    }

    return ('K = ' + #k -> asstring(-precision = 2) +
        ' C = ' + #c -> asstring(-precision = 2) +
        ' R = ' + #r -> asstring(-precision = 2) +
        ' F = ' + #f -> asstring(-precision = 2)
        )
}

tempconverter(21, 'k')
'<br />'
tempconverter(21, 'c')
'<br />'
tempconverter(-41, 'c')
'<br />'
tempconverter(37.80, 'r')
'<br />'
tempconverter(69.80, 'f')
