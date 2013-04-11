recursive function gcd_rec(u, v) result(gcd)
    integer             :: gcd
    integer, intent(in) :: u, v

    if (mod(u, v) /= 0) then
        gcd = gcd_rec(v, mod(u, v))
    else
        gcd = v
    end if
end function gcd_rec
