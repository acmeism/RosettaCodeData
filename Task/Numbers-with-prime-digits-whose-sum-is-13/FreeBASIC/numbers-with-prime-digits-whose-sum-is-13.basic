function digit_is_prime( n as integer ) as boolean
    select case n
        case 2,3,5,7
            return true
        case else
            return false
    end select
end function

function all_digits_prime( n as uinteger ) as boolean
    dim as string sn = str(n)
    for i as uinteger = 1 to len(sn)
        if not digit_is_prime( val(mid(sn,i,1)) ) then return false
    next i
    return true
end function

function digit_sum_13( n as uinteger ) as boolean
    dim as string sn = str(n)
    dim as integer k = 0
    for i as uinteger = 1 to len(sn)
        k = k + val(mid(sn,i,1))
        if k>13 then return false
    next i
    if k<>13 then return false else return true
end function

for i as uinteger = 1 to 322222
    if all_digits_prime(i) andalso digit_sum_13(i) then print i,
next i
